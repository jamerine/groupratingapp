module ClaimLossConcern
  extend ActiveSupport::Concern
  DEFAULT_COLUMN_WIDTH = 13.freeze
  CLAIM_LOSS_HEADERS   = ['Claim Number', 'Claimant', 'DOI', 'Manual Number', 'Comp Awarded', 'Medical Paid', 'MIRA Reserve', 'GTML', 'ITML', 'SI Total', 'HC', 'Code'].freeze

  module ClassMethods
    def claim_loss
      include InstanceMethods
      before_action :set_claim_loss_account, only: :claim_loss_export
      before_action :prepare_claim_loss_data, only: :claim_loss_export
    end
  end

  module InstanceMethods
    extend ActiveSupport::Concern

    def claim_loss_export
      require 'rubyXL'
      require 'rubyXL/convenience_methods'

      # Create workbook
      @claim_loss_workbook = RubyXL::Workbook.new
      out_of_experience_worksheet

      # Set font size of whole file
      @claim_loss_workbook.worksheets.each(&method(:check_column_widths))

      # Out of Experience
      # worksheet = claim_loss_workbook.add_worksheet('Out of Experience')

      send_data @claim_loss_workbook.stream.string, filename: "#{@account.name.parameterize.underscore}_claim_loss.xlsx", disposition: :attachment
    end

    private

    def set_claim_loss_account
      @account = Account.find_by(id: params[:account_id])
      redirect_to page_not_found_path and return unless @account.present?

      @group_rating       = GroupRating.find_by(id: params[:group_rating_id])
      @representative     = @account.representative
      @policy_calculation = @account.policy_calculation
      redirect_to page_not_found_path unless @policy_calculation.present?
    end

    def prepare_claim_loss_data
      # Logic should be the same as risk report for claim loss
      # Experience Years Parameters
      @first_experience_year        = @group_rating.experience_period_lower_date.strftime("%Y").to_i
      first_experience_year_period  = @group_rating.experience_period_lower_date..(@group_rating.experience_period_lower_date.advance(years: 1).advance(days: -1))
      @first_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", first_experience_year_period.first, first_experience_year_period.last).order(:claim_injury_date)

      @second_experience_year        = @first_experience_year + 1
      second_experience_year_period  = first_experience_year_period.last.advance(days: 1)..first_experience_year_period.last.advance(years: 1)
      @second_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", second_experience_year_period.first, second_experience_year_period.last).order(:claim_injury_date)

      @third_experience_year        = @second_experience_year + 1
      third_experience_year_period  = second_experience_year_period.first.advance(years: 1)..second_experience_year_period.last.advance(years: 1)
      @third_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", third_experience_year_period.first, third_experience_year_period.last).order(:claim_injury_date)

      @fourth_experience_year        = @third_experience_year + 1
      fourth_experience_year_period  = third_experience_year_period.first.advance(years: 1)..third_experience_year_period.last.advance(years: 1)
      @fourth_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", fourth_experience_year_period.first, fourth_experience_year_period.last).order(:claim_injury_date)

      # Experience Totals

      @experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date).order(:claim_injury_date)
      @experience_med_only    = @experience_year_claims.where("left(claim_type, 1) = '1'").count
      @experience_lost_time   = @experience_year_claims.where("left(claim_type, 1) = '2'").count

      @experience_comp_total                 = 0
      @experience_medical_total              = 0
      @experience_mira_medical_reserve_total = 0

      @experience_year_claims.each do |e|
        @experience_comp_total                 += (((e.claim_mira_reducible_indemnity_paid + e.claim_mira_non_reducible_indemnity_paid) * (1 - (e.claim_subrogation_percent || 0.00)) - (e.claim_mira_non_reducible_indemnity_paid)) * (1 - e.claim_handicap_percent) + (e.claim_mira_non_reducible_indemnity_paid)) * (e.claim_group_multiplier || 1)
        @experience_medical_total              += (((e.claim_medical_paid + e.claim_mira_non_reducible_indemnity_paid_2) * (1 - (e.claim_subrogation_percent || 0.00)) - e.claim_mira_non_reducible_indemnity_paid_2) * (1 - e.claim_handicap_percent) + e.claim_mira_non_reducible_indemnity_paid_2) * (e.claim_group_multiplier || 1)
        @experience_mira_medical_reserve_total += (1 - e.claim_handicap_percent) * (e.claim_mira_medical_reserve_amount + (e.claim_mira_indemnity_reserve_amount)) * (e.claim_group_multiplier || 1) * (1 - (e.claim_subrogation_percent || 0.00))
      end

      @experience_group_modified_losses_total      = @experience_year_claims.sum(:claim_modified_losses_group_reduced)
      @experience_individual_modified_losses_total = @experience_year_claims.sum(:claim_modified_losses_individual_reduced)
      @experience_individual_reduced_total         = @experience_year_claims.sum(:claim_individual_reduced_amount)
      @experience_si_total                         = @experience_year_claims.sum(:claim_unlimited_limited_loss) - @experience_year_claims.sum(:claim_total_subrogation_collected)
      @experience_si_avg                           = (@experience_si_total / 4)
      @experience_si_ratio_avg                     = (@experience_si_total / @policy_calculation.policy_total_four_year_payroll) * @policy_calculation.policy_total_current_payroll

      # Out Of Experience Years Parameters
      @first_out_of_experience_year        = @first_experience_year - 5
      first_out_of_experience_year_period  = first_experience_year_period.first.advance(years: -5)..first_experience_year_period.last.advance(years: -5)
      @first_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", first_out_of_experience_year_period.first, first_out_of_experience_year_period.last).order(:claim_injury_date)

      @second_out_of_experience_year        = @first_experience_year - 4
      second_out_of_experience_year_period  = first_experience_year_period.first.advance(years: -4)..first_experience_year_period.last.advance(years: -4)
      @second_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", second_out_of_experience_year_period.first, second_out_of_experience_year_period.last).order(:claim_injury_date)

      @third_out_of_experience_year        = @first_experience_year - 3
      third_out_of_experience_year_period  = first_experience_year_period.first.advance(years: -3)..first_experience_year_period.last.advance(years: -3)
      @third_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", third_out_of_experience_year_period.first, third_out_of_experience_year_period.last).order(:claim_injury_date)

      @fourth_out_of_experience_year        = @first_experience_year - 2
      fourth_out_of_experience_year_period  = first_experience_year_period.first.advance(years: -2)..first_experience_year_period.last.advance(years: -2)
      @fourth_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", fourth_out_of_experience_year_period.first, fourth_out_of_experience_year_period.last).order(:claim_injury_date)

      @fifth_out_of_experience_year        = @first_experience_year - 1
      fifth_out_of_experience_year_period  = first_experience_year_period.first.advance(years: -1)..first_experience_year_period.last.advance(years: -1)
      @fifth_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", fifth_out_of_experience_year_period.first, fifth_out_of_experience_year_period.last).order(:claim_injury_date)

      # Out Of Experience Totals
      @out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", first_out_of_experience_year_period.first, fifth_out_of_experience_year_period.last).order(:claim_injury_date)
      @out_of_experience_med_only    = @out_of_experience_year_claims.where("left(claim_type, 1) = '1'").count
      @out_of_experience_lost_time   = @out_of_experience_year_claims.where("left(claim_type, 1) = '2'").count

      @out_of_experience_comp_total                 = 0
      @out_of_experience_medical_total              = 0
      @out_of_experience_mira_medical_reserve_total = 0

      @out_of_experience_year_claims.each do |e|
        if e.claim_handicap_percent.present? && e.claim_subrogation_percent.present? && e.claim_group_multiplier.present?
          @out_of_experience_comp_total                 += (((e.claim_mira_reducible_indemnity_paid + e.claim_mira_non_reducible_indemnity_paid) * (1 - e.claim_subrogation_percent) - (e.claim_mira_non_reducible_indemnity_paid)) * (1 - e.claim_handicap_percent) + (e.claim_mira_non_reducible_indemnity_paid)) * e.claim_group_multiplier
          @out_of_experience_medical_total              += (((e.claim_medical_paid + e.claim_mira_non_reducible_indemnity_paid_2) * (1 - e.claim_subrogation_percent) - e.claim_mira_non_reducible_indemnity_paid_2) * (1 - e.claim_handicap_percent) + e.claim_mira_non_reducible_indemnity_paid_2) * e.claim_group_multiplier
          @out_of_experience_mira_medical_reserve_total += (1 - e.claim_handicap_percent) * (e.claim_mira_medical_reserve_amount + (e.claim_mira_indemnity_reserve_amount)) * e.claim_group_multiplier * (1 - e.claim_subrogation_percent)
        end
      end

      @out_of_experience_group_modified_losses_total      = @out_of_experience_year_claims.sum(:claim_modified_losses_group_reduced)
      @out_of_experience_individual_modified_losses_total = @out_of_experience_year_claims.sum(:claim_modified_losses_individual_reduced)
      @out_of_experience_individual_reduced_total         = @out_of_experience_year_claims.sum(:claim_individual_reduced_amount)
      @out_of_experience_si_total                         = @out_of_experience_year_claims.sum(:claim_unlimited_limited_loss) - @out_of_experience_year_claims.sum(:claim_total_subrogation_collected)

      # TEN YEAR EXPERIENCE TOTALS

      @ten_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", first_out_of_experience_year_period.first, @group_rating.experience_period_upper_date).order(:claim_injury_date)

      @ten_year_med_only  = @ten_year_claims.where("left(claim_type, 1) = '1'").count
      @ten_year_lost_time = @ten_year_claims.where("left(claim_type, 1) = '2'").count
      @ten_year_rc_01     = @ten_year_claims.where("left(claim_mira_ncci_injury_type, 1) = '01'").count
      @ten_year_rc_02     = @ten_year_claims.where("left(claim_mira_ncci_injury_type, 1) = '02'").count

      @ten_year_comp_total = (@ten_year_claims.sum(:claim_modified_losses_group_reduced) - @ten_year_claims.sum(:claim_medical_paid) - @ten_year_claims.sum(:claim_mira_medical_reserve_amount))

      @ten_year_medical_total                    = @ten_year_claims.sum(:claim_medical_paid)
      @ten_year_mira_medical_reserve_total       = @ten_year_claims.sum(:claim_mira_medical_reserve_amount)
      @ten_year_group_modified_losses_total      = @ten_year_claims.sum(:claim_modified_losses_group_reduced)
      @ten_year_individual_modified_losses_total = @ten_year_claims.sum(:claim_modified_losses_individual_reduced)
      @ten_year_individual_reduced_total         = @ten_year_claims.sum(:claim_individual_reduced_amount)
      @ten_year_si_total                         = @experience_si_total + @out_of_experience_si_total
      @ten_year_si_avg                           = (@ten_year_si_total / 10)
      @ten_year_si_ratio_avg                     = 'N/A'

      @ten_year_si_average   = (@ten_year_si_total / 10)
      @ten_year_si_ratio_avg = 'N/A'

      # GREEN YEAR EXPERIENCE

      @first_green_year        = @group_rating.experience_period_upper_date.strftime("%Y").to_i
      @first_green_year_period = (@group_rating.experience_period_upper_date.advance(days: 1))..(@group_rating.experience_period_upper_date.advance(years: 1))
      @first_green_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_green_year_period.first, @first_green_year_period.last).order(:claim_injury_date)

      @second_green_year        = @first_green_year + 1
      @second_green_year_period = @first_green_year_period.first.advance(years: 1)..@first_green_year_period.last.advance(years: 1)
      @second_green_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @second_green_year_period.first, @second_green_year_period.last).order(:claim_injury_date)

      # GREEN YEAR EXPERIENCE TOTALS

      @green_year_claims     = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_green_year_period.first, @second_green_year_period.last).order(:claim_injury_date)
      @green_year_med_only   = @green_year_claims.where("left(claim_type, 1) = '1'").count
      @green_year_loss_time  = @green_year_claims.where("left(claim_type, 1) = '2'").count
      @green_year_comp_total = (@green_year_claims.sum(:claim_modified_losses_group_reduced) - @green_year_claims.sum(:claim_medical_paid) - @green_year_claims.sum(:claim_mira_medical_reserve_amount))

      @green_year_comp_total                 = 0
      @green_year_medical_total              = 0
      @green_year_mira_medical_reserve_total = 0

      @green_year_claims.each do |e|
        if e.claim_handicap_percent.present? && e.claim_subrogation_percent.present? && e.claim_group_multiplier.present?
          @green_year_comp_total                 += (((e.claim_mira_reducible_indemnity_paid + e.claim_mira_non_reducible_indemnity_paid) * (1 - e.claim_subrogation_percent) - (e.claim_mira_non_reducible_indemnity_paid)) * (1 - e.claim_handicap_percent) + (e.claim_mira_non_reducible_indemnity_paid)) * e.claim_group_multiplier
          @green_year_medical_total              += (((e.claim_medical_paid + e.claim_mira_non_reducible_indemnity_paid_2) * (1 - e.claim_subrogation_percent) - e.claim_mira_non_reducible_indemnity_paid_2) * (1 - e.claim_handicap_percent) + e.claim_mira_non_reducible_indemnity_paid_2) * e.claim_group_multiplier
          @green_year_mira_medical_reserve_total += (1 - e.claim_handicap_percent) * (e.claim_mira_medical_reserve_amount + (e.claim_mira_indemnity_reserve_amount)) * e.claim_group_multiplier * (1 - e.claim_subrogation_percent)
        end
      end

      @green_year_group_modified_losses_total      = @green_year_claims.sum(:claim_modified_losses_group_reduced)
      @green_year_individual_modified_losses_total = @green_year_claims.sum(:claim_modified_losses_individual_reduced)
      @green_year_individual_reduced_total         = @green_year_claims.sum(:claim_individual_reduced_amount)
    end

    def out_of_experience_worksheet
      worksheet            = @claim_loss_workbook.worksheets[0]
      worksheet.sheet_name = 'Out of Experience'

      injury_years           = [@first_out_of_experience_year, @second_out_of_experience_year, @third_out_of_experience_year, @fourth_out_of_experience_year, @fifth_out_of_experience_year]
      out_of_experience_data = [@first_out_of_experience_year_claims, @second_out_of_experience_year_claims, @third_out_of_experience_year_claims, @fourth_out_of_experience_year_claims, @fifth_out_of_experience_year_claims]
      table_data             = []

      out_of_experience_data.each do |data|
        claims_data, total_data = claim_data(data)
        table_data << { data: claims_data, totals: total_data }
      end

      current_row = 0

      injury_years.each_with_index do |year, index|
        worksheet.merge_cells(current_row, 0, current_row, 1)
        worksheet.add_cell(current_row, 0, "Injury Year: #{year}")
        worksheet.change_row_bold(current_row, true)

        year_data   = table_data[index]
        current_row += 2

        CLAIM_LOSS_HEADERS.each_with_index do |header, column|
          worksheet.add_cell(current_row, column, header)
          worksheet[current_row][column].change_border(:bottom, :medium)
          worksheet.change_row_bold(current_row, true)
        end

        current_row += 1

        year_data[:data].each_with_index do |claim_data, row_index|
          [*0..CLAIM_LOSS_HEADERS.size].each_with_index do |column, column_index|
            worksheet.add_cell(current_row, column, claim_data[column])
            worksheet[current_row][column_index - 1].change_border(:bottom, :medium) if row_index == year_data[:data].size - 1
          end

          current_row += 1
        end

        worksheet.change_row_bold(current_row, true)
        worksheet.merge_cells(current_row, 0, current_row, 3)
        worksheet.add_cell(current_row, 0, "Totals").change_horizontal_alignment(:center)

        [*0..year_data[:totals].size].each do |total_data_index|
          worksheet.add_cell(current_row, total_data_index + 4, year_data[:totals][total_data_index])
        end

        current_row += 3
      end
    end

    def check_column_widths(worksheet)
      max_column_index = worksheet.map { |row| row && row.cells.size || 0 }.max

      [*0..max_column_index].each do |column|
        column_width = DEFAULT_COLUMN_WIDTH

        worksheet.each_with_index do |_, row|
          next unless worksheet[row].present?

          cell = worksheet[row][column]
          next unless cell.present?

          worksheet.change_row_font_size(row, 12)
          worksheet.change_row_height(row, 16)
          cell_width   = (cell.value&.to_s&.size || 0) * 1.5
          column_width = cell_width if cell_width > column_width
        end

        worksheet.change_column_width(column, column_width)
      end
    end

    def claim_data(claims_array)
      comp_total     = 0
      med_paid_total = 0
      mira_res_total = 0

      claims_array.each do |e|
        if e.claim_handicap_percent.present? && e.claim_subrogation_percent.present? && e.claim_group_multiplier.present?
          comp_total     += (((e.claim_mira_reducible_indemnity_paid + e.claim_mira_non_reducible_indemnity_paid) * (1 - e.claim_subrogation_percent) - (e.claim_mira_non_reducible_indemnity_paid)) * (1 - e.claim_handicap_percent) + (e.claim_mira_non_reducible_indemnity_paid)) * e.claim_group_multiplier
          med_paid_total += (((e.claim_medical_paid + e.claim_mira_non_reducible_indemnity_paid_2) * (1 - e.claim_subrogation_percent) - e.claim_mira_non_reducible_indemnity_paid_2) * (1 - e.claim_handicap_percent) + e.claim_mira_non_reducible_indemnity_paid_2) * e.claim_group_multiplier
          mira_res_total += (1 - e.claim_handicap_percent) * (e.claim_mira_medical_reserve_amount + (e.claim_mira_indemnity_reserve_amount)) * e.claim_group_multiplier * (1 - e.claim_subrogation_percent)
        end
      end

      data = claims_array.map do |e|
        comp_awarded = "0"
        medical_paid = "0"
        mira_res     = "0"

        if e.claim_handicap_percent.present? && e.claim_subrogation_percent.present? && e.claim_group_multiplier.present?
          comp_awarded = "#{round((((e.claim_mira_reducible_indemnity_paid + e.claim_mira_non_reducible_indemnity_paid) * (1 - e.claim_subrogation_percent) - (e.claim_mira_non_reducible_indemnity_paid)) * (1 - e.claim_handicap_percent) + (e.claim_mira_non_reducible_indemnity_paid)) * e.claim_group_multiplier, 0)}"
          medical_paid = "#{round((((e.claim_medical_paid + e.claim_mira_non_reducible_indemnity_paid_2) * (1 - e.claim_subrogation_percent) - e.claim_mira_non_reducible_indemnity_paid_2) * (1 - e.claim_handicap_percent) + e.claim_mira_non_reducible_indemnity_paid_2) * e.claim_group_multiplier, 0)}"
          mira_res     = "#{round((1 - e.claim_handicap_percent) * (e.claim_mira_medical_reserve_amount + (e.claim_mira_indemnity_reserve_amount)) * e.claim_group_multiplier * (1 - e.claim_subrogation_percent), 0)}"
        end

        [e.claim_number, e.claimant_name.titleize, e.claim_injury_date.in_time_zone("America/New_York").strftime("%m/%d/%y"), e.claim_manual_number, comp_awarded, medical_paid, mira_res, round(e.claim_modified_losses_group_reduced, 0), round(e.claim_modified_losses_individual_reduced, 0), round((e.claim_unlimited_limited_loss || 0) - (e.claim_total_subrogation_collected || 0), 0), percent(e.claim_handicap_percent), claim_code_calc(e)]
      end

      [data, [round(comp_total, 0), round(med_paid_total, 0), round(mira_res_total, 0), round(claims_array.sum(:claim_modified_losses_group_reduced), 0), round(claims_array.sum(:claim_modified_losses_individual_reduced), 0), round(claims_array.sum(:claim_unlimited_limited_loss) - claims_array.sum(:claim_total_subrogation_collected), 0), "", ""]]
    end

    def price(num)
      view_context.number_to_currency(num)
    end

    def round(num, prec)
      view_context.number_with_precision(num, precision: prec, :delimiter => ',')
    end

    def rate(num, prec)
      if num.nil?
        return nil
      end
      num = num * 100
      view_context.number_with_precision(num, precision: prec)
    end

    def percent(num)
      num = (num || 0) * 100
      view_context.number_to_percentage(num, precision: 0)
    end

    def claim_code_calc(claim)
      claim_code = ''

      if claim.claim_type.present? && claim.claim_type[0] == '1'
        claim_code << "MO/"
      else
        claim_code << "LT/"
      end

      claim_code << claim.claim_status if claim.claim_status.present?
      claim_code << "/"
      claim_code << claim.claim_mira_ncci_injury_type if claim.claim_mira_ncci_injury_type.present?
      claim_code << "/NO COV" if claim.claim_type.present? && claim.claim_type[-1] == '1'

      claim_code
    end
  end
end
