class RiskReport < PdfReport

  def initialize(account = [], policy_calculation = [], group_rating = [], report_params = {}, view)
    super()
    @account                = account
    @policy_calculation     = policy_calculation
    @policy_program_history = @policy_calculation.policy_program_histories.order(:policy_year).last
    @group_rating           = group_rating
    @report_params          = report_params

    @view = view

    @account = Account.includes(policy_calculation: [:policy_coverage_status_histories, :policy_program_histories, { manual_class_calculations: :payroll_calculations }]).find(@account.id)

    #LAPSE PERIOD FOR GROUP RATING
    @nov_first       = (Date.current.year.to_s + '-11-01').to_date
    @days_to_add     = (4 - @nov_first.wday) % 7
    @fourth_thursday = @nov_first + @days_to_add + 21

    @higher_lapse    = @fourth_thursday - 3
    @lower_lapse     = @higher_lapse - 12.months
    @group_lapse_sum = 0

    @coverage_lapse_periods = @account.policy_calculation.policy_coverage_status_histories.where("coverage_status = :coverage_status and (coverage_end_date BETWEEN :lower_lapse and :higher_lapse or coverage_end_date is null)", coverage_status: "LAPSE", lower_lapse: @lower_lapse, higher_lapse: @higher_lapse)

    @coverage_lapse_periods.each do |period|
      # period starts before and ends out of range
      if period.coverage_effective_date < @lower_lapse && period.coverage_end_date.nil?
        @group_lapse_sum += Date.current - @lower_lapse
        # period starts after and ends out of range
      elsif period.coverage_effective_date > @lower_lapse && period.coverage_end_date.nil?
        @group_lapse_sum += Date.current - period.coverage_effective_date
        # period starts before and ends in range
      elsif period.coverage_effective_date < @lower_lapse && period.coverage_end_date < @higher_lapse
        @group_lapse_sum += period.coverage_end_date - @lower_lapse
        # period starts after and ends in range
      elsif period.coverage_effective_date > @lower_lapse && period.coverage_end_date < @higher_lapse
        @group_lapse_sum += period.coverage_end_date - period.coverage_effective_date
      end
    end

    # GROUP RETRO LAPS CONFIG

    nov_first       = (Date.current.year.to_s + '-11-01').to_date
    days_to_add     = (4 - nov_first.wday) % 7
    fourth_thursday = nov_first + days_to_add + 21

    higher_lapse           = fourth_thursday - 3
    lower_lapse            = higher_lapse - 9.months
    @group_retro_lapse_sum = 0

    coverage_lapse_periods = @account.policy_calculation.policy_coverage_status_histories.where("coverage_status = :coverage_status and (coverage_end_date BETWEEN :lower_lapse and :higher_lapse or coverage_end_date is null)", coverage_status: "LAPSE", lower_lapse: lower_lapse, higher_lapse: higher_lapse)

    coverage_lapse_periods.each do |period|
      # period starts before and ends out of range
      if period.coverage_effective_date < lower_lapse && period.coverage_end_date.nil?
        @group_retro_lapse_sum += Date.current - lower_lapse
        # period starts after and ends out of range
      elsif period.coverage_effective_date > lower_lapse && period.coverage_end_date.nil?
        @group_retro_lapse_sum += Date.current - period.coverage_effective_date
        # period starts before and ends in range
      elsif period.coverage_effective_date < lower_lapse && period.coverage_end_date < higher_lapse
        @group_retro_lapse_sum += period.coverage_end_date - lower_lapse
        # period starts after and ends in range
      elsif period.coverage_effective_date > lower_lapse && period.coverage_end_date < higher_lapse
        @group_retro_lapse_sum += period.coverage_end_date - period.coverage_effective_date
      end
    end

    @current_coverage_status = if @policy_calculation.policy_coverage_status_histories.order(coverage_effective_date: :desc).first&.coverage_status == "LAPSE"
                                 "Y"
                               else
                                 "N"
                               end

    # Section for calculating parameters for Claim Loss Runs

    # Experience Years Parameters

    @first_experience_year        = @group_rating.experience_period_lower_date.strftime("%Y").to_i
    @first_experience_year_period = @group_rating.experience_period_lower_date..(@group_rating.experience_period_lower_date.advance(years: 1).advance(days: -1))
    @first_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_experience_year_period.first, @first_experience_year_period.last).order(:claim_injury_date)

    @second_experience_year        = @first_experience_year + 1
    @second_experience_year_period = @first_experience_year_period.last.advance(days: 1)..@first_experience_year_period.last.advance(years: 1)
    @second_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @second_experience_year_period.first, @second_experience_year_period.last).order(:claim_injury_date)

    @third_experience_year        = @second_experience_year + 1
    @third_experience_year_period = @second_experience_year_period.first.advance(years: 1)..@second_experience_year_period.last.advance(years: 1)
    @third_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @third_experience_year_period.first, @third_experience_year_period.last).order(:claim_injury_date)

    @fourth_experience_year        = @third_experience_year + 1
    @fourth_experience_year_period = @third_experience_year_period.first.advance(years: 1)..@third_experience_year_period.last.advance(years: 1)
    @fourth_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @fourth_experience_year_period.first, @fourth_experience_year_period.last).order(:claim_injury_date)

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
    @first_out_of_experience_year_period = @first_experience_year_period.first.advance(years: -5)..@first_experience_year_period.last.advance(years: -5)
    @first_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_out_of_experience_year_period.first, @first_out_of_experience_year_period.last).order(:claim_injury_date)

    @second_out_of_experience_year        = @first_experience_year - 4
    @second_out_of_experience_year_period = @first_experience_year_period.first.advance(years: -4)..@first_experience_year_period.last.advance(years: -4)
    @second_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @second_out_of_experience_year_period.first, @second_out_of_experience_year_period.last).order(:claim_injury_date)

    @third_out_of_experience_year        = @first_experience_year - 3
    @third_out_of_experience_year_period = @first_experience_year_period.first.advance(years: -3)..@first_experience_year_period.last.advance(years: -3)
    @third_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @third_out_of_experience_year_period.first, @third_out_of_experience_year_period.last).order(:claim_injury_date)

    @fourth_out_of_experience_year        = @first_experience_year - 2
    @fourth_out_of_experience_year_period = @first_experience_year_period.first.advance(years: -2)..@first_experience_year_period.last.advance(years: -2)
    @fourth_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @fourth_out_of_experience_year_period.first, @fourth_out_of_experience_year_period.last).order(:claim_injury_date)

    @fifth_out_of_experience_year        = @first_experience_year - 1
    @fifth_out_of_experience_year_period = @first_experience_year_period.first.advance(years: -1)..@first_experience_year_period.last.advance(years: -1)
    @fifth_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @fifth_out_of_experience_year_period.first, @fifth_out_of_experience_year_period.last).order(:claim_injury_date)

    # Out Of Experience Totals

    @out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_out_of_experience_year_period.first, @fifth_out_of_experience_year_period.last).order(:claim_injury_date)
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

    @ten_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_out_of_experience_year_period.first, @group_rating.experience_period_upper_date).order(:claim_injury_date)

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

    # GREEN YEAR EXPERIENCE Totals

    @green_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_green_year_period.first, @second_green_year_period.last).order(:claim_injury_date)

    @green_year_med_only  = @green_year_claims.where("left(claim_type, 1) = '1'").count
    @green_year_loss_time = @green_year_claims.where("left(claim_type, 1) = '2'").count

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

    @current_expected_losses = 0

    @account.policy_calculation.manual_class_calculations.each do |man|
      @current_expected_losses += man.manual_class_expected_loss_rate * man.manual_class_current_estimated_payroll
    end

    @current_expected_losses = @current_expected_losses / 100
    @payroll_calculations    = @policy_calculation.manual_class_calculations.map { |u| u.payroll_calculations }.flatten
    @payroll_periods         = PayrollCalculation.select('reporting_period_start_date').group('payroll_calculations.reporting_period_start_date').where(:policy_number => @policy_calculation.policy_number).order(reporting_period_start_date: :desc).pluck(:reporting_period_start_date)
    @ilr                     = round(((@policy_calculation.policy_total_modified_losses_group_reduced * @policy_calculation.policy_total_current_payroll) / (@policy_calculation.policy_total_four_year_payroll * (@policy_calculation.policy_adjusted_standard_premium || @policy_calculation.policy_total_standard_premium))), 2)
    @f_s                     = round((((3660 * @experience_med_only) + (12500 * @experience_lost_time)) / @policy_calculation.policy_total_four_year_payroll) * (@policy_calculation.policy_total_current_payroll / (@policy_calculation.policy_adjusted_standard_premium || @policy_calculation.policy_total_standard_premium)), 2)

    @erc =
      if @account.policy_calculation.currently_assigned_erc_representative_number == 0
        "N/A"
      else
        if BwcCodesEmployerRepresentative.find_by(representative_number: @account.policy_calculation.currently_assigned_erc_representative_number).nil?
          "#{@account.policy_calculation.currently_assigned_erc_representative_number}"
        else
          BwcCodesEmployerRepresentative.find_by(representative_number: @account.policy_calculation.currently_assigned_erc_representative_number).employer_rep_name
        end
      end

    @grc =
      if @account.policy_calculation.currently_assigned_grc_representative_number == 0
        "N/A"
      else
        if BwcCodesEmployerRepresentative.find_by(representative_number: @account.policy_calculation.currently_assigned_grc_representative_number).nil?
          "#{@account.policy_calculation.currently_assigned_grc_representative_number}"
        else
          BwcCodesEmployerRepresentative.find_by(representative_number: @account.policy_calculation.currently_assigned_grc_representative_number).employer_rep_name
        end

      end

    @clm =
      if @account.policy_calculation.currently_assigned_clm_representative_number == 0
        "N/A"
      else
        if BwcCodesEmployerRepresentative.find_by(representative_number: @account.policy_calculation.currently_assigned_clm_representative_number).nil?
          "#{@account.policy_calculation.currently_assigned_clm_representative_number}"
        else
          BwcCodesEmployerRepresentative.find_by(representative_number: @account.policy_calculation.currently_assigned_clm_representative_number).employer_rep_name
        end

      end

    @risk =
      if @account.policy_calculation.currently_assigned_risk_representative_number == 0
        "N/A"
      else
        if BwcCodesEmployerRepresentative.find_by(representative_number: @account.policy_calculation.currently_assigned_risk_representative_number).nil?
          "#{@account.policy_calculation.currently_assigned_risk_representative_number}"
        else
          BwcCodesEmployerRepresentative.find_by(representative_number: @account.policy_calculation.currently_assigned_risk_representative_number).try(:employer_rep_name)
        end
      end

    @group_rating_levels = BwcCodesIndustryGroupSavingsRatioCriterium.where(industry_group: @account.industry_group)

    @em_cap =
      policy_em_rate = @policy_calculation.policy_individual_adjusted_experience_modified_rate || @policy_calculation.policy_individual_experience_modified_rate

    if policy_em_rate > (2 * (@policy_calculation.policy_program_histories.order(reporting_period_start_date: :desc).first&.experience_modifier_rate || 0))
      (2 * (@policy_calculation.policy_program_histories.order(reporting_period_start_date: :desc).first&.experience_modifier_rate || 0))
    else
      policy_em_rate
    end

    @sort_code =
      if @account.group_rating_rejections.where("program_type = 'group_rating'").empty? && @account.group_rating_qualification == 'accept'
        "accept"
      elsif @account.group_rating_rejections.where("program_type = 'group_rating'").empty? && @account.group_rating_qualification == 'reject'
        "manual_override"
      else
        @account.group_rating_rejections.where("program_type = 'group_rating'").pluck(:reject_reason).map { |i| "'" + i.to_s + "'" }.join(",").to_s.gsub(/\s|"|'/, '')
      end

    group_rating_quote = @account.quotes.where(program_type: 0).first
    group_retro_quote  = @account.quotes.where(program_type: 1).first

    @group_rating_date = group_rating_quote.nil? || @account.group_rating_rejected? ? 'N/A' : group_rating_quote.quote_date
    @group_retro_date  = group_retro_quote.nil? || @account.group_retro_rejected? ? 'N/A' : group_retro_quote.quote_date

    if @report_params["at_a_glance"] == "1" || @report_params["experience_statistics"] == "1" || @report_params["expected_loss_and_premium"] == "1"
      header
      stroke_horizontal_rule
    end
    if @report_params["at_a_glance"] == "1"
      at_a_glance
    end
    if @report_params["experience_statistics"] == "1"
      experience_statistics
      stroke_horizontal_rule
    end
    if @report_params["expected_loss_and_premium"] == "1"
      expected_loss_development
    end

    if @report_params["at_a_glance"] == "1" || @report_params["experience_statistics"] == "1" || @report_params["expected_loss_and_premium"] == "1"
      start_new_page
    end
    roc_report

    claim_loss_run

    if @report_params["group_discount_levels"] == "1" || @report_params[":coverage_status"] == "1" || @report_params["experience_modifier_info"] == "1" || @report_params["payroll_history"] == "1"
      start_new_page
    end
    if @report_params["group_discount_levels"] == "1"
      group_discount_level
      individual_discount_level
    end
    if @report_params["coverage_status"] == "1"
      coverage_status_history
    end
    if @report_params["experience_modifier_info"] == "1"
      experience_modifier_history
    end
    if @report_params["payroll_history"] == "1"
      payroll_and_premium_history
    end
    # number_pages "<page> in a total of <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 50, 0], :align => :right, :size => 14 }
    footer(@account)
  end

  private

  def header
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 80, :height => 80) do
      representative_logo
      transparent(0) { stroke_bounds }
      # stroke_bounds
    end

    bounding_box([100, current_cursor], :width => 350, :height => 80) do
      text "#{ @account.name}", size: 12, style: :bold, align: :center
      text "DBA: #{ @account.policy_calculation.try(:trading_as_name) }", size: 10, align: :center
      text "Policy#: #{ @account.policy_number_entered }   |   Sale Contact: #{ @account.affiliates.find_by(role: 6).try(:first_name)} #{@account.affiliates.find_by(role: 6).try(:last_name)}   |   Co Code: #{ @account.affiliates.find_by(role: 2).try(:company_name)}", size: 10, align: :center
      text "Risk Report", size: 10, align: :center
      text "As of #{@group_rating.updated_at.in_time_zone("America/New_York").strftime("%m/%d/%y")} with #{ @account.representative.quote_year } Rates", size: 10, align: :center
      text "Projected #{@account.representative.quote_year} Experience", size: 12, align: :center, style: :bold_italic
      transparent(0) { stroke_bounds }
      # stroke_bounds
    end
  end

  def at_a_glance
    move_down 5
    text "At A Glance", size: 12, style: :bold, align: :center
    move_down 5
    text "Current Employer Rep: #{ @erc }", size: 10
    move_down 2
    text "Employer Rep Group Risk/Claim: #{ @grc }", size: 10
    move_down 2
    text "Employer Rep Claim: #{ @clm }", size: 10
    move_down 2
    text "Employer Rep Risk Management: #{ @risk }", size: 10
    move_down 5
    stroke_horizontal_rule
    pre_current_cursor = cursor
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 275, :height => 125) do
      text "FEIN: #{ @account.policy_calculation.federal_identification_number }"
      move_down 15
      text "Current Status: #{@account.policy_calculation.coverage_status_effective_date}-#{ @account.policy_calculation.current_coverage_status }", size: 10
      move_down 2
      text "Immediate Combo Policy: #{@policy_calculation.immediate_successor_policy_number}"
      move_down 2
      text "Ultimate Combo Policy: #{@policy_calculation.ultimate_successor_policy_number}"
      move_down 2
      text "Group Days Lapse: #{ @group_lapse_sum }"
      move_down 2
      text "Group Retro Days Lapse: #{ @group_retro_lapse_sum }"
      move_down 2
      text "Currently Lapsed: #{@current_coverage_status}"
      transparent(0) { stroke_bounds }
    end

    if @policy_program_history.present?
      bounding_box([285, current_cursor], :width => 275, :height => 125) do
        text "Current Rating Plan:", style: :bold
        move_down 5
        text "Current EM: #{@policy_program_history.experience_modifier_rate}"
        move_down 2
        text "Retro Min%: #{ @policy_program_history.rrr_minimum_premium_percentage }"
        move_down 2
        text "One Claim: #{ @policy_program_history.ocp_participation_indicator }   OCP_Year: #{ @policy_program_history.ocp_first_year_of_participation }"
        move_down 2
        text "EM Capping: #{ @policy_program_history.em_cap_participation_indicator }"
        move_down 2
        text "DFSP: #{ @policy_program_history.drug_free_program_participation_indicator }"
        move_down 2
        text "Deductible %: #{ @policy_program_history.deductible_participation_indicator }"
        move_down 2
        text "Trans Work: #{ @policy_program_history.twbns_participation_indicator }  ISSP: #{@policy_program_history.issp_participation_indicator }"
        move_down 2
        text "Grow Ohio: #{@policy_program_history.drug_free_program_participation_indicator  }"
        transparent(0) { stroke_bounds }
      end
    end

    post_current_cursor = cursor
    stroke do
      # just lower the current y position
      #  horizontal_line 0, 545, :at => current_cursor
      vertical_line (pre_current_cursor), post_current_cursor, :at => 275
      #  horizontal_line 0, 545, :at => 385
    end
    stroke_horizontal_rule
  end

  def experience_statistics
    move_down 10
    text "Experience Statistics and EM Calculation:", style: :bold
    move_down 5

    table experience_table_data do
      self.position                 = :center
      row(0).font_style             = :bold
      row(0).borders                = [:bottom]
      row(1).columns(0..15).borders = []
      row(0).align                  = :center
      row(0..-1).align              = :center
      self.cell_style               = { :size => 8 }
      self.header                   = true
    end

    move_down 10
    stroke_horizontal_rule
    move_down 10
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 125, :height => 15) do
      text "Cycle Date: #{ @account.cycle_date }", style: :bold
      transparent(0) { stroke_bounds }
    end
    bounding_box([125, current_cursor], :width => 275, :height => 15) do
      text "Sort Code: #{ @sort_code.to_s }", style: :bold
      transparent(0) { stroke_bounds }
    end
    bounding_box([400, current_cursor], :width => 150, :height => 15) do
      text "Partner:  ", style: :bold
      transparent(0) { stroke_bounds }
    end
    current_cursor = cursor
    bounding_box([75, current_cursor], :width => 150, :height => 15) do
      text text "Group Date: #{ @group_rating_date }", style: :bold
      transparent(0) { stroke_bounds }
    end

    bounding_box([325, current_cursor], :width => 150, :height => 15) do
      text "GRTRO Date: #{@group_retro_date}", style: :bold
      transparent(0) { stroke_bounds }
    end

    move_down 5
  end

  def experience_table_data
    @data = [["ITML", "GTML", "TEL", "Ratio", "IG", "TLL", "C%", "EMR", "Adj. EMR", "CAP", "Max Value", "Stand Prem", "F/S", "ILR", "10YLR", "4YLR"]]
    @data += [[round(@policy_calculation.policy_total_modified_losses_individual_reduced, 0), round(@policy_calculation.policy_total_modified_losses_group_reduced, 0), round(@policy_calculation.policy_total_expected_losses, 0), round(@policy_calculation.policy_group_ratio - 1, 4), @policy_calculation.policy_industry_group, round(@policy_calculation.policy_total_limited_losses, 0), percent(@policy_calculation.policy_credibility_percent), round(@policy_calculation.policy_individual_experience_modified_rate, 2), round(@policy_calculation.policy_individual_adjusted_experience_modified_rate + 1, 2), round(@em_cap, 2), round(@policy_calculation.policy_maximum_claim_value, 0), round(@policy_calculation.policy_total_standard_premium, 0), "#{@f_s}", "#{@ilr}"]]
  end

  def expected_loss_development
    move_down 10
    text "Expected Loss Development and Estimated Premium:", style: :bold
    move_down 5

    table expected_loss_table_data, :column_widths => { 0 => 30, 1 => 20, 2 => 60, 3 => 30, 4 => 55, 5 => 30, 6 => 60, 7 => 35, 8 => 50, 9 => 35, 10 => 50, 11 => 35, 12 => 50 } do
      self.position          = :center
      row(0).font_style      = :bold
      row(-3..-1).font_style = :bold
      row(0).overflow        = :shring_to_fit
      row(0).align           = :center
      row(0).borders         = [:bottom]
      row(1..-1).borders     = []
      row(-4).borders        = [:top]
      # row(1).columns(0..14).borders = []
      row(0..-1).align = :center
      self.cell_style  = { :size => 8 }
      self.header      = true
    end

    move_down 10
    text "Current Expected Losses: #{ round(@current_expected_losses, 0) }", style: :bold
  end

  def expected_loss_table_data
    if ['MMHR2', 'MMHR1', 'CPM', 'ARM'].include? @account.representative.abbreviated_name
      @data = [["Man Num", "IG", "Experience Payroll", "Exp. Loss Rate", "Total Exp Losses", "Base Rate", "Estimated Payroll", "Ind. Rate", "Est Ind Premium", "#{@account.group_rating_tier} Group Rate", "Group Premium", "MMS Rate", "MMS Premium"]]
      @data += @account.policy_calculation.manual_class_calculations.order(manual_number: :asc).map { |e| [e.manual_number, e.manual_class_industry_group, round(e.manual_class_four_year_period_payroll, 0), rate(e.manual_class_expected_loss_rate / 100, 2), round(e.manual_class_expected_losses, 0), rate(e.manual_class_base_rate / 100, 2), round(e.manual_class_current_estimated_payroll, 0), rate(e.manual_class_individual_total_rate, 4), round(e.manual_class_estimated_individual_premium, 0), rate(e.manual_class_group_total_rate, 4), round(e.manual_class_estimated_group_premium, 0)] }
      @data += [[{ :content => " #{ } Totals", :colspan => 4 }, "#{round(@policy_calculation.policy_total_expected_losses, 0)}", "", "#{round(@policy_calculation.policy_total_current_payroll, 0)}", "", "#{round(@policy_calculation.policy_total_individual_premium, 0)}", "", "#{round(@account.group_premium, 0)}", "", ""]]
      @data += [[{ :content => " #{ } Adjusted Premium", :colspan => 4 }, { :content => "", :colspan => 4 }, "#{round(@policy_calculation.policy_adjusted_individual_premium, 0)}", { :content => "", :colspan => 4 }]]
    else
      @data = [["Man Num", "IG", "Experience Payroll", "Exp. Loss Rate", "Total Exp Losses", "Base Rate", "Estimated Payroll", "Ind. Rate", "Est Ind Premium", "#{@account.group_rating_tier} Group Rate", "Group Premium"]]
      @data += @account.policy_calculation.manual_class_calculations.order(manual_number: :asc).map { |e| [e.manual_number, e.manual_class_industry_group, round(e.manual_class_four_year_period_payroll, 0), rate(e.manual_class_expected_loss_rate / 100, 2), round(e.manual_class_expected_losses, 0), rate(e.manual_class_base_rate / 100, 2), round(e.manual_class_current_estimated_payroll, 0), rate(e.manual_class_individual_total_rate, 4), round(e.manual_class_estimated_individual_premium, 0), rate(e.manual_class_group_total_rate, 4), round(e.manual_class_estimated_group_premium, 0)] }
      @data += [[{ :content => " #{ } Totals", :colspan => 4 }, "#{round(@policy_calculation.policy_total_expected_losses, 0)}", "", "#{round(@policy_calculation.policy_total_current_payroll, 0)}", "", "#{round(@policy_calculation.policy_total_individual_premium, 0)}", "", "#{round(@account.group_premium, 0)}"]]
      @data += [[{ :content => " #{ } Adjusted Before Assessments", :colspan => 4 }, { :content => "", :colspan => 4 }, "#{round(@policy_calculation.policy_adjusted_standard_premium, 0)}", { :content => "", :colspan => 2 }]]
      @data += [[{ :content => " #{ } Assessments", :colspan => 4 }, { :content => "", :colspan => 4 }, "#{round(@policy_calculation.total_assessments, 0)}", { :content => "", :colspan => 2 }]]
      @data += [[{ :content => " #{ } Adjusted Premium", :colspan => 4 }, { :content => "", :colspan => 4 }, "#{round(@policy_calculation.policy_adjusted_individual_premium, 0)}", { :content => "", :colspan => 2 }]]
    end
  end

  def roc_report
    @account                = Account.includes(policy_calculation: [:policy_coverage_status_histories, :policy_program_histories, { manual_class_calculations: :payroll_calculations }]).find(@account.id)
    @current_policy_program = @account.policy_calculation.policy_program_histories&.order(reporting_period_start_date: :desc)&.first
    @current_date           = DateTime.now.to_date
    @total_est_premium      = 0

    @account.policy_calculation.manual_class_calculations.each do |man|
      rate               = man.payroll_calculations.where("reporting_period_start_date < :current_date and reporting_period_end_date > :current_date", current_date: @current_date).first&.manual_class_rate
      @total_est_premium += rate.nil? ? 0 : rate * man.manual_class_current_estimated_payroll * 0.01
    end

    if @report_params["estimated_current_premium"] == "1" || @report_params["program_options"] == "1"
      header_two
      stroke_horizontal_rule
    end

    if @report_params["estimated_current_premium"] == "1"
      estimated_current_period_premium
    end

    if @report_params["program_options"] == "1"
      workers_comp_program_options
      workers_comp_program_additional_options
      descriptions
    end
  end

  def header_two
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 80, :height => 80) do
      representative_logo
      transparent(0) { stroke_bounds }
      # stroke_bounds
    end
    bounding_box([100, current_cursor], :width => 350, :height => 80) do
      text "#{ @account.name}", size: 12, style: :bold, align: :center
      text "DBA: #{ @account.policy_calculation.try(:trading_as_name) }", size: 10, align: :center
      text "Policy#: #{ @account.policy_number_entered }", size: 10, style: :bold, align: :center
      move_down 2
      text "#{ @account.street_address}, #{ @account.city}, #{ @account.state}, #{ @account.zip_code}", size: 10, align: :center
      move_down 2
      text "As of #{@group_rating.updated_at.in_time_zone("America/New_York").strftime("%m/%d/%y")} with #{ @group_rating.quote_year } Rates", size: 10, align: :center
      move_down 2
      text "Rating Option Comparison Report", size: 12, align: :center, style: :bold_italic
      transparent(0) { stroke_bounds }
      # stroke_bounds
    end
  end

  def estimated_current_period_premium

    bounding_box([100, cursor], :width => 350) do
      move_down 3
      text "Estimated Current Period Premium", size: 10, style: :bold, align: :center
      horizontal_line 0, 350, :at => cursor

      if @current_policy_program.present?
        bounding_box([0, cursor], :width => 350) do
          table ([["Rating Plan: #{@current_policy_program.group_type }", "Current EM: #{ @current_policy_program.experience_modifier_rate }", "OCP: #{ @current_policy_program.ocp_participation_indicator }", "EM CAP: #{ @current_policy_program.em_cap_participation_indicator }"], ["DFSP: #{@current_policy_program.drug_free_program_participation_indicator }", "Ded Pct: #{ @current_policy_program.deductible_discount_percentage }", "ISSP: #{ @current_policy_program.issp_participation_indicator }", "TWBNS: #{ @current_policy_program.twbns_participation_indicator }"]]), :column_widths => { 0 => 89, 1 => 87, 2 => 87, 3 => 87 } do
            self.position      = :center
            row(0..-1).borders = []
            self.cell_style    = { size: 9 }
            cells.padding      = 3
          end
          stroke_bounds
        end
      end

      bounding_box([0, cursor], :width => 350) do
        table current_policy_data, :column_widths => { 0 => 87, 1 => 87, 2 => 87, 3 => 87 }, :row_colors => ["FFFFFF", "F0F0F0"] do
          self.position      = :center
          row(0).font_style  = :bold
          row(0).overflow    = :shring_to_fit
          row(0).align       = :center
          row(0).borders     = [:bottom]
          row(1..-1).borders = []
          row(0..-1).align   = :center
          self.cell_style    = { size: 9 }
          cells.padding      = 3
        end
        table current_policy_data_total, :column_widths => { 0 => 87, 1 => 87, 2 => 87, 3 => 87 } do
          self.position     = :center
          row(0).font_style = :bold
          row(0).overflow   = :shring_to_fit
          row(0).align      = :center
          row(0).borders    = [:top]
          row(0..-1).align  = :center
          self.cell_style   = { size: 9 }
          cells.padding     = 3
        end
        stroke_bounds
      end
      stroke_bounds
    end

  end

  def current_policy_data
    @data = [["Manual", "Est Payroll", "Rate", "Est Premium"]]
    @data += @policy_calculation.manual_class_calculations.order(manual_number: :asc).map { |e| [e.manual_number, round(e.manual_class_current_estimated_payroll, 0), e.payroll_calculations.where("reporting_period_start_date < :current_date and reporting_period_end_date > :current_date", current_date: @current_date).first.nil? ? '0.00' : e.payroll_calculations.where("reporting_period_start_date < :current_date and reporting_period_end_date > :current_date", current_date: @current_date).first.manual_class_rate, "#{ (e.payroll_calculations.where("reporting_period_start_date < :current_date and reporting_period_end_date > :current_date", current_date: @current_date).first.nil? || e.payroll_calculations.where("reporting_period_start_date < :current_date and reporting_period_end_date > :current_date", current_date: @current_date).first.manual_class_rate.nil?) ? "0.00" : round(e.payroll_calculations.where("reporting_period_start_date < :current_date and reporting_period_end_date > :current_date", current_date: @current_date).first.manual_class_rate * e.manual_class_current_estimated_payroll * 0.01, 0)}"] }
  end

  def current_policy_data_total
    @data = [["Totals", "#{ round(@policy_calculation.policy_total_current_payroll, 0) }", "", "#{round(@total_est_premium, 0)}"]]
  end

  def workers_comp_program_options
    move_down 10
    text "#{@account.representative.quote_year} Workers' Compensation Program Options [1]", size: 10, style: :bold, align: :center

    table workers_comp_program_options_data,
          :column_widths => { 0 => 100, 1 => 63, 2 => 62, 3 => 62, 4 => 62, 5 => 62, 6 => 62, 7 => 62 },
          :row_colors    => ["FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "F0F0F0", "F0F0F0"],
          :cell_style    => { :height => 20 } do
      self.position          = :center
      row(0).font_style      = :bold
      row(0).align           = :center
      row(0).borders         = [:bottom]
      row(0..-1).align       = :right
      row(-2..-1).font_style = :bold
      self.cell_style        = { size: 9 }
      self.before_rendering_page do |t|
        t.row(-2).border_top_width = 2
      end
    end
  end

  def workers_comp_program_options_data
    # Experience Rated
    @experience_eligibility       = 'Yes'
    @experience_projected_premium = @policy_calculation.policy_adjusted_individual_premium || 0
    @experience_costs             = 0
    @experience_maximum_risk      = 0
    @experience_total_cost        = @experience_projected_premium - @experience_costs
    @experience_savings           = @policy_calculation.policy_total_individual_premium - @experience_total_cost

    # EM Cap
    @em_cap_eligibility =
      (@policy_calculation.policy_individual_experience_modified_rate > (2 * (@policy_calculation.policy_program_histories.order(reporting_period_start_date: :desc).first&.experience_modifier_rate || 0)) ? 'Yes' : 'No')
    if @em_cap_eligibility == 'Yes'
      @em_cap_projected_premium = (2 * (@policy_calculation.policy_program_histories.order(reporting_period_start_date: :desc).first&.experience_modifier_rate || 0))
      @em_cap_costs             = 0
      @em_cap_maximum_risk      = 0
      @em_cap_total_cost        = @em_cap_projected_premium - @em_cap_costs
      @em_cap_savings           = @policy_calculation.policy_total_individual_premium - @em_cap_total_cost
    else
      @em_cap_projected_premium = nil
      @em_cap_costs             = nil
      @em_cap_maximum_risk      = nil
      @em_cap_total_cost        = nil
      @em_cap_savings           = nil
    end

    # OCP

    # Group Rating
    @group_rating_eligibility = (@account.group_rating_qualification == 'accept' ? 'Yes' : 'No')
    if @group_rating_eligibility == 'Yes'
      @group_rating_projected_premium = @account.group_premium || 0
      @group_rating_costs             = 0
      @group_rating_maximum_risk      = 0
      @group_rating_total_cost        = @group_rating_projected_premium - @group_rating_costs
      @group_rating_savings           = @policy_calculation.policy_total_individual_premium - @group_rating_total_cost
    else
      @group_rating_projected_premium = nil
      @group_rating_costs             = nil
      @group_rating_maximum_risk      = nil
      @group_rating_total_cost        = nil
      @group_rating_savings           = nil
    end

    # Group Retro
    @group_retro_eligibility = (@account.group_retro_qualification == 'accept' ? 'Yes' : 'No')
    if @group_retro_eligibility == 'Yes'
      @group_retro_projected_premium = @policy_calculation.policy_adjusted_standard_premium # Changing from this due to Doug request 1/20/21: @policy_calculation.policy_total_individual_premium
      @group_retro_costs             = -@account.group_retro_savings
      @group_retro_maximum_risk      = (@policy_calculation.policy_adjusted_standard_premium * 0.15) # Changing from this due to Doug request 1/20/21: (@policy_calculation.policy_total_standard_premium * 0.15)
      @group_retro_total_cost        = @group_retro_projected_premium + @group_retro_costs
      @group_retro_savings           = (@policy_calculation.policy_adjusted_standard_premium || @policy_calculation.calculate_premium_with_assessments) - @group_retro_total_cost
    else
      @group_retro_projected_premium = nil
      @group_retro_costs             = nil
      @group_retro_maximum_risk      = nil
      @group_retro_total_cost        = nil
      @group_retro_savings           = nil
    end

    @data = [[" ", "Exp. Rated", "EM Cap", "OCP", " #{ @account.group_rating_tier } Gr.", "Gr. Retro", "Ind. Retro", "#{@account.representative.abbreviated_name}"]]
    @data += [["Eligibility", "#{@experience_eligibility}", "#{@em_cap_eligibility}", " ", "#{@group_rating_eligibility}", "#{@group_retro_eligibility}", " ", " "]]
    @data += [["Projected Premium", "#{ round(@experience_projected_premium, 0) }", "#{ round(@em_cap_projected_premium, 0)}", " ", "#{round(@group_rating_projected_premium, 0)}", "#{round(@group_retro_projected_premium, 0)}", " ", " "]]
    @data += [["Est Cost/-Credits", "#{ round(@experience_costs, 0) }", "#{ round(@em_cap_costs, 0)}", " ", "#{ round(@group_rating_costs, 0) }", "#{ round(@group_retro_costs, 0)}", " ", " "]]
    @data += [["Maximum Risk", "#{ round(@experience_maximum_risk, 0) }", "#{ round(@em_cap_maximum_risk, 0) }", " ", "#{ round(@group_rating_maximum_risk, 0) }", "#{ round(@group_retro_maximum_risk, 0)}", " ", " "]]
    @data += [["Total Est Cost", "#{ round(@experience_total_cost, 0) }", "#{ round(@em_cap_total_cost, 0)}", " ", "#{ round(@group_rating_total_cost, 0) }", "#{ round(@group_retro_total_cost, 0)}", " ", " "]]
    @data += [["Est Savings/-Loss", "#{ round(@experience_savings, 0) }", "#{round(@em_cap_savings, 0)}", " ", "#{ round(@group_rating_savings, 0) }", "#{ round(@group_retro_savings, 0)}", " ", " "]]
  end

  def workers_comp_program_additional_options
    move_down 10
    text "Additional BWC Discounts, Rebates and Bonuses [2]", size: 10, style: :bold, align: :center
    move_down 5
    table workers_comp_program_additional_options_data,
          :column_widths => { 0 => 100, 1 => 63, 2 => 62, 3 => 62, 4 => 62, 5 => 62, 6 => 62, 7 => 62 },
          :row_colors    => ["FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "F0F0F0", "F0F0F0"],
          :cell_style    => { :height => 20 } do
      self.position          = :center
      row(0).align           = :center
      row(0..-1).align       = :center
      row(-3..-1).font_style = :bold
      self.cell_style        = { size: 9 }
      self.before_rendering_page do |t|
        t.row(-3).border_top_width = 2
        t.row(-2).border_top_width = 2
      end
      row(0).column(2).background_color = "aaa9a9"
      row(0).column(3).background_color = "aaa9a9"
      row(0).column(5).background_color = "aaa9a9"
      row(0).column(6).background_color = "aaa9a9"
      row(0).column(7).background_color = "aaa9a9"
      row(1).column(7).background_color = "aaa9a9"
      row(2).column(5).background_color = "aaa9a9"
      row(2).column(6).background_color = "aaa9a9"
      row(2).column(7).background_color = "aaa9a9"
      row(3).column(5).background_color = "aaa9a9"
      row(3).column(6).background_color = "aaa9a9"
      row(3).column(7).background_color = "aaa9a9"
      row(4).column(7).background_color = "aaa9a9"
      row(5).column(6).background_color = "aaa9a9"
      row(5).column(7).background_color = "aaa9a9"
    end

  end

  def workers_comp_program_additional_options_data

    ###### Drug-Free Safety
    @drug_free_experience   = @policy_calculation.policy_adjusted_standard_premium * 0.07 # Changing from this due to Doug request 1/20/21: @policy_calculation.policy_total_standard_premium * 0.07
    @drug_free_group_rating = (@group_rating_eligibility == 'Yes' ? ((@account.group_premium || 0) * 0.07) : nil)

    ###### Safety Council
    @safety_council_experience = (@policy_calculation.policy_adjusted_standard_premium * 0.04) # Changing from this due to Doug request 1/20/21: (@policy_calculation.policy_total_standard_premium * 0.04)
    @safety_council_em_cap     = (@em_cap_eligibility == 'Yes' ? (@em_cap_projected_premium * 0.04) : nil)
    # @safety_council_ocp = (@policy_calculation.policy_total_standard_premium * 0.04)
    @safety_council_group_rating = (@group_rating_eligibility == 'Yes' ? ((@account.group_premium || 0) * 0.02) : nil)
    @safety_council_group_retro  = (@group_retro_eligibility == 'Yes' ? (@policy_calculation.policy_adjusted_standard_premium * 0.02) : '') # Changing from this due to Doug request 1/20/21: (@group_retro_eligibility == 'Yes' ? (@policy_calculation.policy_total_standard_premium * 0.02) : '')
    # @safety_council_individual_retro = (@account.group_retro_premium * 0.04)
    # @safety_council_mm_select = (@policy_calculation.policy_total_standard_premium * 0.04)

    ###### Industry Specific
    @industry_specific_experience = (@policy_calculation.policy_adjusted_standard_premium * 0.03) # Changing from this due to Doug request 1/20/21: (@policy_calculation.policy_total_standard_premium * 0.03)
    @industry_specific_em_cap     = (@em_cap_eligibility == 'Yes' ? (@em_cap_projected_premium * 0.03) : nil)
    # @industry_specific_ocp = (@policy_calculation.policy_total_standard_premium * 0.03)
    @industry_specific_group_rating = (@group_rating_eligibility == 'Yes' ? ((@account.group_premium || 0) * 0.03) : nil)
    # @industry_specific_individual_retro = (@account.group_premium * 0.03)
    # @industry_specific_mm_select

    ###### Transitional Work
    @transitional_work_experience = (@policy_calculation.policy_adjusted_standard_premium * 0.1) # Changing from this due to Doug request 1/20/21: (@policy_calculation.policy_total_standard_premium * 0.1)
    @transitional_work_em_cap     = (@em_cap_eligibility == 'Yes' ? (@em_cap_projected_premium * 0.01) : nil)
    # @transitional_work_ocp = (@policy_calculation.policy_total_standard_premium * 0.03)
    @transitional_work_group_rating = (@group_rating_eligibility == 'Yes' ? ((@account.group_premium || 0) * 0.10) : nil)
    # @transitional_individual_retro_rating = (@account.group_premium * 0.1)
    # @transitional_mm_select

    ###### Go Green
    @go_green_experience = (@policy_calculation.policy_total_individual_premium * 0.01 > 2000 ? 2000 : @policy_calculation.policy_total_individual_premium * 0.01)
    @go_green_em_cap     = (@em_cap_eligibility == 'Yes' ? (@em_cap_projected_premium * 0.01 > 2000 ? 2000 : @em_cap_projected_premium * 0.01) : nil)
    # @go_green_ocp = (@policy_calculation.policy_total_standard_premium * 0.03)
    @go_green_group_rating = (@group_rating_eligibility == 'Yes' ? ((@account.group_premium || 0) * 0.01 > 2000 ? 2000 : (@account.group_premium || 0) * 0.01) : nil)
    @go_green_group_retro  = ((@group_retro_eligibility == 'Yes') ? (@policy_calculation.policy_total_individual_premium * 0.01 > 2000) ? 2000 : (@policy_calculation.policy_total_individual_premium * 0.01) : nil)
    # @go_green_individual_retro = (@account.group_premium * 0.1)
    # @go_green_mm_select = (@account.group_premium * 0.1)

    ###### Lapse Free
    @lapse_free_experience = (@policy_calculation.policy_total_individual_premium * 0.01 > 2000 ? 2000 : @policy_calculation.policy_total_individual_premium * 0.01)
    @lapse_free_em_cap     = (@em_cap_eligibility == 'Yes' ? (@em_cap_projected_premium * 0.01 > 2000 ? 2000 : @em_cap_projected_premium * 0.01) : nil)
    # @lapse_free_ocp = (@policy_calculation.policy_total_standard_premium * 0.03)
    @lapse_free_group_rating = (@group_rating_eligibility == 'Yes' ? ((@account.group_premium || 0) * 0.01 > 2000 ? 2000 : (@account.group_premium || 0) * 0.01) : nil)
    @lapse_free_group_retro  = (@group_retro_eligibility == 'Yes' ? (@policy_calculation.policy_total_individual_premium * 0.01 > 2000) ? 2000 : (@policy_calculation.policy_total_individual_premium * 0.01) : nil)
    # @lapse_free_individual_retro = (@account.group_premium * 0.01 > 2000 ? 2000 : @account.group_premium * 0.01)
    # @lapse_free_mm_select = (@account.group_premium * 0.01 > 2000 ? 2000 : @account.group_premium * 0.01 )

    ###### Max Add'l Savings
    @max_savings_experience = (@drug_free_experience + @safety_council_experience + @industry_specific_experience + @transitional_work_experience + @go_green_experience + @lapse_free_experience)
    @max_savings_em_cap     = @em_cap_eligibility == 'Yes' ? (@safety_council_em_cap + @industry_specific_em_cap + @transitional_work_em_cap + @go_green_em_cap + @lapse_free_em_cap) : nil
    # @max_savings_ocp = (@safety_council_ocp + @industry_specific_ocp + @transitional_work_ocp + @go_green_ocp + @lapse_free_ocp)
    @max_savings_group_rating = (@group_rating_eligibility == 'Yes' ? (@drug_free_group_rating + @safety_council_group_rating + @industry_specific_group_rating + @transitional_work_group_rating + @go_green_group_rating + @lapse_free_group_rating) : nil)
    @max_savings_group_retro  = (@group_retro_eligibility == 'Yes' ? (@safety_council_group_retro + @go_green_group_retro + @lapse_free_group_retro) : nil)
    # @max_savings_individual_retro = (  @safety_council_individual_retro + @go_green_individual_retro)
    # @max_savings_mm_select =

    ###### Lowest Possible Costs
    @lowest_costs_experience   = @experience_total_cost - @max_savings_experience
    @lowest_costs_em_cap       = @em_cap_eligibility == 'Yes' ? (@em_cap_total_cost - @max_savings_em_cap) : nil
    @lowest_costs_group_rating = @group_rating_eligibility == 'Yes' ? (@group_rating_total_cost - @max_savings_group_rating) : nil
    @lowest_costs_group_retro  = @group_retro_eligibility == 'Yes' ? (@group_retro_total_cost - @max_savings_group_retro) : nil
    # @lowest_costs_individual_retro =
    # @lowest_costs_mm_select =

    # Max Save vs Exp
    @max_save_experience   = @experience_projected_premium - @lowest_costs_experience
    @max_save_em_cap       = (@em_cap_eligibility == 'Yes' ? (@em_cap_projected_premium - @lowest_costs_em_cap) : nil)
    @max_save_group_rating = (@group_rating_eligibility == 'Yes' ? (@group_rating_projected_premium - @lowest_costs_group_rating) : nil)
    @max_save_group_retro  = (@group_retro_eligibility == 'Yes' ? (@group_retro_projected_premium - @lowest_costs_group_retro) : nil)
    # @lowest_costs_individual_retro =
    # @lowest_costs_mm_select =

    @data = [["Drug Free Safety", "#{ round(@drug_free_experience, 0) }", "", "", "#{round(@drug_free_group_rating, 0)}", "", "", ""]]
    @data += [["Safety Council", "#{round(@safety_council_experience, 0)}", "#{ round(@safety_council_em_cap, 0)}", "", "#{ round(@safety_council_group_rating, 0)}", "#{ round(@safety_council_group_retro, 0)}", " ", ""]]
    @data += [["Industry Specific", "#{ round(@industry_specific_experience, 0) }", "#{ round(@industry_specific_em_cap, 0)}", "", "#{ round(@industry_specific_group_rating, 0)}", "", "", ""]]
    @data += [["Transitional Work", "#{ round(@transitional_work_experience, 0)}", "#{ round(@transitional_work_em_cap, 0)}", "", "#{ round(@transitional_work_group_rating, 0)}", "", "", ""]]
    @data += [["Go Green", "#{ round(@go_green_experience, 0)}", "#{ round(@go_green_em_cap, 0)}", "", "#{ round(@go_green_group_rating, 0) }", "#{ round(@go_green_group_retro, 0) }", "", ""]]
    @data += [["Lapse Free", "#{ round(@lapse_free_experience, 0)}", "#{ round(@lapse_free_em_cap, 0)}", "", "#{round(@lapse_free_group_rating, 0)}", "#{round(@lapse_free_group_retro, 0)}", "", ""]]
    @data += [["Max Add'l Savings", "#{round(@max_savings_experience, 0)}", "#{round(@max_savings_em_cap, 0)}", "", "#{round(@max_savings_group_rating, 0)}", "#{ round(@max_savings_group_retro, 0)}", "", ""]]
    @data += [["Low Poss. Costs", "#{ round(@lowest_costs_experience, 0)}", "#{ round(@lowest_costs_em_cap, 0)}", "", "#{ round(@lowest_costs_group_rating, 0)}", "#{round(@lowest_costs_group_retro, 0)}", "", ""]]
    @data += [["Max Save vs Exp", "#{ round(@max_save_experience, 0)}", "#{round(@max_save_em_cap, 0)}", "", "#{round(@max_save_group_rating, 0)}", "#{round(@max_save_group_retro, 0)}", "", ""]]

  end

  def descriptions
    move_down 5
    text "[1] Program Options and costs estimates are based on current eligibility and current and historical data and is not guaranteed. See detail sheets for program parameters. Retro and Deductible Programs savings can vary based on parameters selected.", size: 6
    move_down 3
    text "[2] Additional BWC Discounts often include costs of setting up the program and full savings on certain programs will be difficult to acheive.", size: 6
  end

  def claim_loss_run
    if @report_params["out_of_experience_claims"] == "1" || @report_params["in_experience_claims"] == "1" || @report_params["green_year_claims"] == "1"
      start_new_page
      text "Claim Loss Run", size: 14, style: :bold, align: :center
    end
    if @report_params["out_of_experience_claims"] == "1"
      # OUT OF EXPERIENCE
      stroke_horizontal_rule
      move_down 5
      text "Out Of Experience", style: :bold, size: 12
      stroke_horizontal_rule
      move_down 15
      text "Injury Year: #{ @first_out_of_experience_year}", style: :bold
      year_claim_table(claim_data(@first_out_of_experience_year_claims))
      move_down 30
      text "Injury Year: #{ @second_out_of_experience_year}", style: :bold
      year_claim_table(claim_data(@second_out_of_experience_year_claims))
      move_down 30
      text "Injury Year: #{ @third_out_of_experience_year}", style: :bold
      year_claim_table(claim_data(@third_out_of_experience_year_claims))
      move_down 30
      text "Injury Year: #{ @fourth_out_of_experience_year}", style: :bold
      year_claim_table(claim_data(@fourth_out_of_experience_year_claims))
      move_down 30
      text "Injury Year: #{ @fifth_out_of_experience_year}", style: :bold
      year_claim_table(claim_data(@fifth_out_of_experience_year_claims))

      #############################################################
      # Out of Experience Totals
      move_down 15
      out_of_experience_year_total_table
      move_down 10
      text "Med Only Claim Count: #{@out_of_experience_med_only}", style: :bold, :indent_paragraphs => 30
      text "Lost Time Claim Count: #{@out_of_experience_lost_time}", style: :bold, :indent_paragraphs => 30
      move_down 30

    end

    if @report_params["in_experience_claims"] == "1"
      #############################################################

      #IN EXPERIENCE
      stroke_horizontal_rule
      move_down 5
      text "Experience", style: :bold, size: 12
      stroke_horizontal_rule
      move_down 15
      text "Injury Year: #{ @first_experience_year}", style: :bold
      year_claim_table(claim_data(@first_experience_year_claims))
      move_down 30
      text "Injury Year: #{ @second_experience_year}", style: :bold
      year_claim_table(claim_data(@second_experience_year_claims))
      move_down 30
      text "Injury Year: #{ @third_experience_year}", style: :bold
      year_claim_table(claim_data(@third_experience_year_claims))
      move_down 30
      text "Injury Year: #{ @fourth_experience_year}", style: :bold
      year_claim_table(claim_data(@fourth_experience_year_claims))

      #############################################################
      # IN Experience Totals
      move_down 15
      experience_year_total_table
      move_down 15
    end

    if @report_params["out_of_experience_claims"] == "1" && @report_params["in_experience_claims"] == "1"
      #############################################################
      # TEN YEAR Experience Totals
      move_down 15
      ten_year_total_table
      move_down 15
    end

    if @report_params["green_year_claims"] == "1"
      #############################################################
      #Green Year
      move_down 15
      stroke_horizontal_rule
      move_down 5
      text "Green Year", style: :bold, size: 12
      stroke_horizontal_rule
      move_down 15
      text "Injury Year: #{ @first_green_year}", style: :bold
      year_claim_table(claim_data(@first_green_year_claims))
      move_down 30
      text "Injury Year: #{ @second_green_year}", style: :bold
      year_claim_table(claim_data(@second_green_year_claims))

      #############################################################

      # Green Year Totals

      move_down 15
      green_year_total_table
      move_down 10
      text "Med Only Claim Count: #{@green_year_med_only}", style: :bold, :indent_paragraphs => 30
      text "Lost Time Claim Count: #{@green_year_loss_time}", style: :bold, :indent_paragraphs => 30
      move_down 30
      stroke_horizontal_rule

      #############################################################
    end
  end

  def green_year_total_table
    table totals_green_year_data, :column_widths => { 0 => 49, 1 => 55, 2 => 47, 3 => 32, 4 => 50, 5 => 50, 6 => 48, 7 => 48, 8 => 50, 9 => 50, 10 => 26, 11 => 35 } do
      self.position     = :center
      row(0).font_style = :bold
      row(1).font_style = :bold
      row(0).overflow   = :shring_to_fit
      row(0).align      = :center
      row(0).borders    = [:bottom]
      row(-1).borders   = [:top]
      self.cell_style   = { size: 10 }
      self.header       = true
    end
  end

  def totals_green_year_data
    @data = [[{ :content => "Green Year Totals", :colspan => 4 }, "#{ round(@green_year_comp_total, 0) }", "#{round(@green_year_medical_total, 0)}", "#{round(@green_year_mira_medical_reserve_total, 0)}", "#{round(@green_year_group_modified_losses_total, 0)}", "#{round(@green_year_individual_modified_losses_total, 0)}", "#{round(@green_year_individual_reduced_total, 0)}", "", ""]]
  end

  def out_of_experience_year_total_table
    table totals_out_of_experience_year_data, :column_widths => { 0 => 49, 1 => 55, 2 => 47, 3 => 32, 4 => 50, 5 => 50, 6 => 48, 7 => 48, 8 => 50, 9 => 50, 10 => 26, 11 => 35 } do
      self.position     = :center
      row(0).font_style = :bold
      row(1).font_style = :bold
      row(0).overflow   = :shring_to_fit
      row(0).align      = :center
      row(0).borders    = [:bottom]
      row(-1).borders   = [:top]
      self.cell_style   = { size: 9 }
      self.header       = true
    end
  end

  def totals_out_of_experience_year_data
    @data = [[{ :content => "Out Of Experience Year Totals", :colspan => 4 }, "#{ round(@out_of_experience_comp_total, 0) }", "#{round(@out_of_experience_medical_total, 0)}", "#{round(@out_of_experience_mira_medical_reserve_total, 0)}", "#{round(@out_of_experience_group_modified_losses_total, 0)}", "#{round(@out_of_experience_individual_modified_losses_total, 0)}", "#{round(@out_of_experience_si_total, 0)}", "", ""]]
  end

  def experience_year_total_table
    table totals_experience_year_data, :column_widths => { 0 => 49, 1 => 55, 2 => 47, 3 => 32, 4 => 50, 5 => 50, 6 => 48, 7 => 48, 8 => 50, 9 => 50, 10 => 26, 11 => 35 } do
      self.position     = :center
      row(0).font_style = :bold
      row(1).font_style = :bold
      row(0).overflow   = :shring_to_fit
      row(0).align      = :center
      row(0).borders    = [:bottom]
      row(-1).borders   = [:top]
      self.cell_style   = { size: 9 }
      self.header       = true
    end
    first_cursor = cursor
    bounding_box([0, first_cursor], :width => 275, :height => 25) do
      text "Med Only Claim Count: #{@experience_med_only}", style: :bold, :indent_paragraphs => 30
      text "Lost Time Claim Count: #{@experience_lost_time}", style: :bold, :indent_paragraphs => 30
    end
    # bounding_box([380, first_cursor], :width => 125, :height => 25) do
    #   text "SI Average: #{round(@experience_si_avg, 0)}", style: :bold
    #   text "SI Ratio Avg: #{round(@experience_si_ratio_avg, 0)}", style: :bold
    # end
  end

  def totals_experience_year_data
    @data = [[{ :content => "Experience Year Totals", :colspan => 4 }, "#{ round(@experience_comp_total, 0) }", "#{round(@experience_medical_total, 0)}", "#{round(@experience_mira_medical_reserve_total, 0)}", "#{round(@experience_group_modified_losses_total, 0)}", "#{round(@experience_individual_modified_losses_total, 0)}", "#{round(@experience_si_total, 0)}", "", ""]]
  end

  def ten_year_total_table
    table ten_year_total_data, :column_widths => { 0 => 49, 1 => 55, 2 => 47, 3 => 32, 4 => 50, 5 => 50, 6 => 48, 7 => 48, 8 => 50, 9 => 50, 10 => 26, 11 => 35 } do
      self.position     = :center
      row(0).font_style = :bold
      row(1).font_style = :bold
      row(0).overflow   = :shring_to_fit
      row(0).align      = :center
      row(0).borders    = [:bottom]
      row(-1).borders   = [:top]
      self.cell_style   = { size: 9 }
      self.header       = true
    end
    first_cursor = cursor
    bounding_box([0, first_cursor], :width => 275, :height => 25) do
      text "Med Only Claim Count: #{@ten_year_med_only}     RCO1: #{ @ten_year_rc_01 }", style: :bold, :indent_paragraphs => 30
      text "Lost Time Claim Count: #{@ten_year_lost_time}     RCO2: #{@ten_year_rc_02}", style: :bold, :indent_paragraphs => 30
    end
    # bounding_box([380, first_cursor], :width => 125, :height => 25) do
    #   text "SI Average: #{round(@ten_year_si_average, 0)}", style: :bold
    #   text "SI Ratio Avg: #{@ten_year_si_ratio_avg}", style: :bold
    # end

  end

  def ten_year_total_data
    @data = [[{ :content => "10 Year Totals", :colspan => 4 }, "#{ round(@ten_year_comp_total, 0) }", "#{round(@ten_year_medical_total, 0)}", "#{round(@ten_year_mira_medical_reserve_total, 0)}", "#{round(@ten_year_group_modified_losses_total, 0)}", "#{round(@ten_year_individual_modified_losses_total, 0)}", "#{round(@ten_year_si_total, 0)}", "", ""]]
  end

  def year_claim_table(claim_year_data)
    table claim_year_data, :column_widths => { 0 => 45, 1 => 80, 2 => 40, 3 => 25, 4 => 45, 5 => 45, 6 => 45, 7 => 45, 8 => 45, 9 => 45, 10 => 25, 11 => 55 } do
      self.position               = :center
      row(0).font_style           = :bold
      row(0).overflow             = :shring_to_fit
      row(0).align                = :center
      row(0).borders              = [:bottom]
      row(1..-2).borders          = []
      row(-1).borders             = [:top]
      row(-1).font_style          = :bold
      row(0..-1).align            = :center
      row(0..-1).columns(1).align = :left
      self.cell_style             = { size: 7 }
      self.header                 = true
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

    @data = [["Claim #", "Claimant", "DOI", "Man Num", "Comp Award", "Med. Paid", "MIRA Res.", "GTML", "ITML", "Claim Total", "HC", "Code"]]

    @data += claims_array.map do |e|
      comp_awarded = "0"
      medical_paid = "0"
      mira_res     = "0"

      if e.claim_handicap_percent.present? && e.claim_subrogation_percent.present? && e.claim_group_multiplier.present?
        comp_awarded = "#{round((((e.claim_mira_reducible_indemnity_paid + e.claim_mira_non_reducible_indemnity_paid) * (1 - e.claim_subrogation_percent) - (e.claim_mira_non_reducible_indemnity_paid)) * (1 - e.claim_handicap_percent) + (e.claim_mira_non_reducible_indemnity_paid)) * e.claim_group_multiplier, 0)}"
        medical_paid = "#{round((((e.claim_medical_paid + e.claim_mira_non_reducible_indemnity_paid_2) * (1 - e.claim_subrogation_percent) - e.claim_mira_non_reducible_indemnity_paid_2) * (1 - e.claim_handicap_percent) + e.claim_mira_non_reducible_indemnity_paid_2) * e.claim_group_multiplier, 0)}"
        mira_res     = "#{round((1 - e.claim_handicap_percent) * (e.claim_mira_medical_reserve_amount + (e.claim_mira_indemnity_reserve_amount)) * e.claim_group_multiplier * (1 - e.claim_subrogation_percent), 0)}"
      end

      [e.claim_number, e.claimant_name.titleize, e.claim_injury_date.in_time_zone("America/New_York").strftime("%m/%d/%y"), e.claim_manual_number, comp_awarded, medical_paid, mira_res, round(e.claim_modified_losses_group_reduced, 0), round(e.claim_modified_losses_individual_reduced, 0), "#{round((e.claim_unlimited_limited_loss || 0) - (e.claim_total_subrogation_collected || 0), 0)}", percent(e.claim_handicap_percent), "#{claim_code_calc(e)}"]
    end
    @data += [[{ :content => "Totals", :colspan => 4 }, "#{round(comp_total, 0)}", "#{round(med_paid_total, 0)}", "#{round(mira_res_total, 0)}", "#{round(claims_array.sum(:claim_modified_losses_group_reduced), 0)}", "#{round(claims_array.sum(:claim_modified_losses_individual_reduced), 0)}", "#{round(claims_array.sum(:claim_unlimited_limited_loss) - claims_array.sum(:claim_total_subrogation_collected), 0)}", "", ""]]
  end

  def group_discount_level
    move_down 30
    text "Group Discount Levels", style: :bold, size: 14, align: :center
    group_discount_level_table
  end

  def group_discount_level_table
    table group_discount_level_data do
      self.position      = :center
      row(0).font_style  = :bold
      row(0).overflow    = :shring_to_fit
      row(0).align       = :center
      row(0).borders     = [:bottom]
      row(1..-1).borders = []
      row(0..-1).align   = :center
      self.cell_style    = { size: 8 }
      self.header        = true
    end
  end

  def group_discount_level_data
    @data = [["Market TM%", "Cut Point", "Cut Losses", "Level", "Premium"]]
    @data += @group_rating_levels.map do |e|
      if e.ac26_group_level == @account.group_rating_group_number
        [e.market_rate, round((e.ratio_criteria - 1), 4), round((((e.ratio_criteria - 1) * @policy_calculation.policy_total_expected_losses) + @policy_calculation.policy_total_expected_losses), 0), "Qualified", round(@account.group_premium, 0)]
      else
        [e.market_rate, round((e.ratio_criteria - 1), 4), round((((e.ratio_criteria - 1) * @policy_calculation.policy_total_expected_losses) + @policy_calculation.policy_total_expected_losses), 0), "-", round(@account.estimated_premium(e.market_rate), 0)]
      end
    end
  end

  def individual_discount_level
    move_down 30
    text "Individual Discount Levels", style: :bold, size: 14, align: :center
    individual_discount_level_table
  end

  def individual_discount_level_table
    table individual_discount_level_data do
      self.position      = :center
      row(0).font_style  = :bold
      row(5).font_style  = :bold
      row(0).overflow    = :shring_to_fit
      row(0).align       = :center
      row(0).borders     = [:bottom]
      row(1..-1).borders = []
      row(0..-1).align   = :center
      self.cell_style    = { size: 8 }
      self.header        = true
    end
  end

  def individual_discount_level_data
    @data                        = [["Ind TM%", "Losses", "Premium"]]
    original_modifier            = round(@policy_calculation.adjusted_total_modifier, 2)
    original_modifier_as_percent = (original_modifier.to_f * 100.00).to_f
    min_modifier                 = original_modifier_as_percent.to_i - 4
    max_modifier                 = original_modifier_as_percent.to_i + 4
    rows                         = []

    if @policy_calculation.policy_credibility_percent.zero? || @policy_calculation.policy_total_limited_losses.zero?
      ntm = 0.0
    else
      ntm = ((0.01 / @policy_calculation.policy_credibility_percent) * @policy_calculation.policy_total_limited_losses).round(0)
    end

    [*min_modifier..max_modifier].each do |modifier|
      new_mod      = modifier - original_modifier_as_percent
      new_modifier = (modifier.to_f / 100.00).to_f
      mod_amount   = new_mod * ntm
      rows << [round(new_modifier, 2), round(@experience_group_modified_losses_total + mod_amount, 0), round(@policy_calculation.calculate_premium_for_risk(new_modifier), 0)]
    end

    @data += rows
  end

  def coverage_status_history
    move_down 30
    text "Coverage Dates and Status", style: :bold, size: 14, align: :center
    move_down 5
    coverage_status_history_table
  end

  def coverage_status_history_table
    table coverage_status_history_data do
      self.position      = :center
      row(0).font_style  = :bold
      row(0).overflow    = :shring_to_fit
      row(0).align       = :center
      row(0).borders     = [:bottom]
      row(1..-1).borders = []
      row(0..-1).align   = :center
      self.header        = true
    end
  end

  def coverage_status_history_data
    @data = [["Effective Date", "End Date", "Status"]]
    @data += @account.policy_calculation.policy_coverage_status_histories.order(coverage_effective_date: :desc).map { |e| [e.coverage_effective_date, e.coverage_end_date, e.coverage_status] }
  end

  def experience_modifier_history
    move_down 30
    text "Experience Modifier History", style: :bold, size: 14, align: :center
    experience_modifier_history_table
  end

  def experience_modifier_history_table
    table experience_modifier_history_data do
      self.position      = :center
      row(0).font_style  = :bold
      row(0).overflow    = :shring_to_fit
      row(0).align       = :center
      row(0).borders     = [:bottom]
      row(1..-1).borders = []
      row(0..-1).align   = :center
      self.header        = true
    end
  end

  def experience_modifier_history_data
    @data = [["Period", "EM", "Group Plan", "Retro%", "Ded%", "OCP Year", "GROH", "DF/Level", "EMCap", "TWBNS", "ISSP"]]
    @data += @account.policy_calculation.policy_program_histories.where("reporting_period_start_date >= ?", @first_out_of_experience_year_period.first).order(reporting_period_start_date: :desc).map { |e| [e.reporting_period_start_date, e.experience_modifier_rate, e.group_type, e.rrr_minimum_premium_percentage, e.deductible_discount_percentage, e.ocp_first_year_of_participation, e.grow_ohio_participation_indicator, "#{e.drug_free_program_participation_indicator}/#{e.drug_free_program_participation_level}", e.em_cap_participation_indicator, e.twbns_participation_indicator, e.issp_participation_indicator] }
  end

  def payroll_and_premium_history
    move_down 30
    text "Payroll And Premium History", style: :bold, size: 14, align: :center

    @payroll_periods.each do |period|
      @premium_total = 0
      @policy_calculation.manual_class_calculations.each do |man|
        unless PayrollCalculation.find_by(reporting_period_start_date: period, policy_number: @policy_calculation.policy_number, manual_number: man.manual_number, representative_number: @account.representative.representative_number).nil?
          if PayrollCalculation.find_by(reporting_period_start_date: period, policy_number: @policy_calculation.policy_number, manual_number: man.manual_number, representative_number: @account.representative.representative_number).manual_class_rate.nil?
            @premium_total = 0.0
          else
            @premium_total += ((PayrollCalculation.find_by(reporting_period_start_date: period, policy_number: @policy_calculation.policy_number, manual_number: man.manual_number, representative_number: @account.representative.representative_number).manual_class_payroll) * (PayrollCalculation.find_by(reporting_period_start_date: period, policy_number: @policy_calculation.policy_number, manual_number: man.manual_number, representative_number: @account.representative.representative_number).manual_class_rate * 0.01))
          end
        end
      end
      payroll_and_premium_history_table(payroll_and_premium_history_data(PayrollCalculation.where("reporting_period_start_date = ? and policy_number = ? and representative_number = ?", period, @policy_calculation.policy_number, @account.representative.representative_number), @premium_total))

    end
  end

  def payroll_and_premium_history_table(payroll_and_premium_history_data)
    table payroll_and_premium_history_data, :column_widths => { 0 => 100, 1 => 75, 2 => 75, 3 => 75, 4 => 75, 5 => 75 } do
      self.position      = :center
      row(0).font_style  = :bold
      row(0).overflow    = :shring_to_fit
      row(0).align       = :center
      row(0).borders     = [:bottom]
      row(1..-1).borders = []
      row(0..-1).align   = :center
      row(-1).borders    = [:top]
      row(-1).font_style = :bold
      # self.cell_style = { size: 8 }
      self.header = true
    end
  end

  def payroll_and_premium_history_data(payroll_array, premium_total)
    @data = [["Period", "Manual", "Payroll", "Adjusted", "Rate", "Premium"]]
    @data += payroll_array.order(manual_number: :asc).map { |e| ["#{e.reporting_period_start_date.strftime("%-m/%-d/%y")} - #{e.reporting_period_end_date.strftime("%-m/%-d/%y")}", e.manual_number, round(e.manual_class_payroll, 0), e.data_source, "#{ e.manual_class_rate.nil? ? "N/A" : e.manual_class_rate }", "#{ e.manual_class_rate.nil? ? "0.00" : round((e.manual_class_rate * 0.01) * e.manual_class_payroll, 0)}"] }
    @data += [[{ :content => "Period Totals", :colspan => 2 }, "#{round(payroll_array.sum(:manual_class_payroll), 0)}", "", "", "#{ round(premium_total, 0) }"]]
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

  def price(num)
    @view.number_to_currency(num)
  end

  def round(num, prec)
    @view.number_with_precision(num, precision: prec, :delimiter => ',')
  end

  def rate(num, prec)
    if num.nil?
      return nil
    end
    num = num * 100
    @view.number_with_precision(num, precision: prec)
  end

  def percent(num)
    num = (num || 0) * 100
    @view.number_to_percentage(num, precision: 0)
  end

end
