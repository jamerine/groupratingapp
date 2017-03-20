class RiskReport < PdfReport

  def initialize(account=[],policy_calculation=[],group_rating=[],view)
    super()
    @account = account
    @policy_calculation = policy_calculation
    @policy_program_history = @policy_calculation.policy_program_histories.order(:policy_year).last
    @group_rating = group_rating
    @view = view

    @account = Account.includes(policy_calculation: [:claim_calculations, :policy_coverage_status_histories, :policy_program_histories, { manual_class_calculations: :payroll_calculations }]).find(@account.id)

    #LAPSE PERIOD FOR GROUP RATING
      @nov_first = (Date.current.year.to_s + '-11-01').to_date
      @days_to_add = (4 - @nov_first.wday) % 7
      @fourth_thursday = @nov_first + @days_to_add + 21

      @higher_lapse = @fourth_thursday - 3
      @lower_lapse = @higher_lapse - 12.months
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
        elsif period.coverage_effective_date > lower_lapse && period.coverage_end_date < higher_lapse
          @group_lapse_sum += period.coverage_end_date - @period.coverage_effective_date
        end
      end


    # GROUP RETRO LAPS CONFIG

    nov_first = (Date.current.year.to_s + '-11-01').to_date
    days_to_add = (4 - nov_first.wday) % 7
    fourth_thursday = nov_first + days_to_add + 21

    higher_lapse = fourth_thursday - 3
    lower_lapse = higher_lapse - 9.months
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

    @current_coverage_status = if @policy_calculation.policy_coverage_status_histories.order(coverage_effective_date: :desc).first.coverage_status == "LAPSE"
      "Y"
    else
      "N"
    end


    # Section for calculating parameters for Claim Loss Runs

      # Experience Years Parameters

      @first_experience_year = @group_rating.experience_period_lower_date.strftime("%Y").to_i
      @first_experience_year_period = @group_rating.experience_period_lower_date..(@group_rating.experience_period_lower_date.advance(years: 1).advance(days: -1))
      @first_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_experience_year_period.first,  @first_experience_year_period.last).order(:claim_injury_date)

      @second_experience_year = @first_experience_year + 1
      @second_experience_year_period = @first_experience_year_period.last.advance(days: 1)..@first_experience_year_period.last.advance(years: 1)
      @second_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @second_experience_year_period.first,  @second_experience_year_period.last).order(:claim_injury_date)

      @third_experience_year = @second_experience_year + 1
      @third_experience_year_period = @second_experience_year_period.first.advance(years: 1)..@second_experience_year_period.last.advance(years: 1)
      @third_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @third_experience_year_period.first,  @third_experience_year_period.last).order(:claim_injury_date)

      @fourth_experience_year = @third_experience_year + 1
      @fourth_experience_year_period = @third_experience_year_period.first.advance(years: 1)..@third_experience_year_period.last.advance(years: 1)
      @fourth_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @fourth_experience_year_period.first,  @fourth_experience_year_period.last).order(:claim_injury_date)

      # Experience Totals

      @experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @group_rating.experience_period_lower_date,  @group_rating.experience_period_upper_date).order(:claim_injury_date)
      @experience_med_only = @experience_year_claims.where("left(claim_type, 1) = '1'").count
      @experience_lost_time = @experience_year_claims.where("left(claim_type, 1) = '2'").count



      @experience_comp_total = (@experience_year_claims.sum(:claim_modified_losses_group_reduced) - @experience_year_claims.sum(:claim_medical_paid) - @experience_year_claims.sum(:claim_mira_medical_reserve_amount))
      @experience_medical_total = @experience_year_claims.sum(:claim_medical_paid)
      @experience_mira_medical_reserve_total = @experience_year_claims.sum(:claim_mira_medical_reserve_amount)
      @experience_group_modidified_losses_total = @experience_year_claims.sum(:claim_modified_losses_group_reduced)
      @experience_individual_modidified_losses_total = @experience_year_claims.sum(:claim_modified_losses_individual_reduced)
      @experience_individual_reduced_total = @experience_year_claims.sum(:claim_individual_reduced_amount)
      @experience_si_total = @experience_year_claims.sum(:claim_unlimited_limited_loss) - @experience_year_claims.sum(:claim_total_subrogation_collected)
      @experience_si_avg = (@experience_si_total/4)
      @experience_si_ratio_avg = (@experience_si_total / @policy_calculation.policy_total_four_year_payroll) * @policy_calculation.policy_total_current_payroll


      # Out Of Experience Years Parameters
      @first_out_of_experience_year = @first_experience_year - 5
      @first_out_of_experience_year_period = @first_experience_year_period.first.advance(years: -5)..@first_experience_year_period.last.advance(years: -5)
      @first_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_out_of_experience_year_period.first,  @first_out_of_experience_year_period.last).order(:claim_injury_date)

      @second_out_of_experience_year = @first_experience_year - 4
      @second_out_of_experience_year_period = @first_experience_year_period.first.advance(years: -4)..@first_experience_year_period.last.advance(years: -4)
      @second_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @second_out_of_experience_year_period.first,  @second_out_of_experience_year_period.last).order(:claim_injury_date)

      @third_out_of_experience_year = @first_experience_year - 3
      @third_out_of_experience_year_period = @first_experience_year_period.first.advance(years: -3)..@first_experience_year_period.last.advance(years: -3)
      @third_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @third_out_of_experience_year_period.first,  @third_out_of_experience_year_period.last).order(:claim_injury_date)

      @fourth_out_of_experience_year = @first_experience_year - 2
      @fourth_out_of_experience_year_period = @first_experience_year_period.first.advance(years: -2)..@first_experience_year_period.last.advance(years: -2)
      @fourth_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @fourth_out_of_experience_year_period.first,  @fourth_out_of_experience_year_period.last).order(:claim_injury_date)

      @fifth_out_of_experience_year = @first_experience_year - 1
      @fifth_out_of_experience_year_period = @first_experience_year_period.first.advance(years: -1)..@first_experience_year_period.last.advance(years: -1)
      @fifth_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @fifth_out_of_experience_year_period.first,  @fifth_out_of_experience_year_period.last).order(:claim_injury_date)


      # Out Of Experience Totals

      @out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_out_of_experience_year_period.first,  @fifth_out_of_experience_year_period.last).order(:claim_injury_date)
      @out_of_experience_med_only = @out_of_experience_year_claims.where("left(claim_type, 1) = '1'").count
      @out_of_experience_lost_time = @out_of_experience_year_claims.where("left(claim_type, 1) = '2'").count


      @out_of_experience_comp_total = (@out_of_experience_year_claims.sum(:claim_modified_losses_group_reduced) - @out_of_experience_year_claims.sum(:claim_medical_paid) - @out_of_experience_year_claims.sum(:claim_mira_medical_reserve_amount))

      @out_of_experience_medical_total = @out_of_experience_year_claims.sum(:claim_medical_paid)
      @out_of_experience_mira_medical_reserve_total = @out_of_experience_year_claims.sum(:claim_mira_medical_reserve_amount)
      @out_of_experience_group_modidified_losses_total = @out_of_experience_year_claims.sum(:claim_modified_losses_group_reduced)
      @out_of_experience_individual_modidified_losses_total = @out_of_experience_year_claims.sum(:claim_modified_losses_individual_reduced)
      @out_of_experience_individual_reduced_total = @out_of_experience_year_claims.sum(:claim_individual_reduced_amount)
      @out_of_experience_si_total = @out_of_experience_year_claims.sum(:claim_unlimited_limited_loss) - @out_of_experience_year_claims.sum(:claim_total_subrogation_collected)

      # TEN YEAR EXPERIENCE TOTALS

      @ten_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_out_of_experience_year_period.first,  @group_rating.experience_period_upper_date).order(:claim_injury_date)

      @ten_year_med_only = @ten_year_claims.where("left(claim_type, 1) = '1'").count
      @ten_year_lost_time = @ten_year_claims.where("left(claim_type, 1) = '2'").count
      @ten_year_rc_01 = @ten_year_claims.where("left(claim_mira_ncci_injury_type, 1) = '01'").count
      @ten_year_rc_02 = @ten_year_claims.where("left(claim_mira_ncci_injury_type, 1) = '02'").count

      @ten_year_comp_total = (@ten_year_claims.sum(:claim_modified_losses_group_reduced) - @ten_year_claims.sum(:claim_medical_paid) - @ten_year_claims.sum(:claim_mira_medical_reserve_amount))

      @ten_year_medical_total = @ten_year_claims.sum(:claim_medical_paid)
      @ten_year_mira_medical_reserve_total = @ten_year_claims.sum(:claim_mira_medical_reserve_amount)
      @ten_year_group_modidified_losses_total = @ten_year_claims.sum(:claim_modified_losses_group_reduced)
      @ten_year_individual_modidified_losses_total = @ten_year_claims.sum(:claim_modified_losses_individual_reduced)
      @ten_year_individual_reduced_total = @ten_year_claims.sum(:claim_individual_reduced_amount)
      @ten_year_si_total = @experience_si_total + @out_of_experience_si_total
      @ten_year_si_avg = (@ten_year_si_total/10)
      @ten_year_si_ratio_avg = 'N/A'

      @ten_year_si_average = (@ten_year_si_total/10)
      @ten_year_si_ratio_avg = 'N/A'



      # GREEN YEAR EXPERIENCE
      @first_green_year = @group_rating.experience_period_upper_date.strftime("%Y").to_i
      @first_green_year_period = (@group_rating.experience_period_upper_date.advance(days: 1))..(@group_rating.experience_period_upper_date.advance(years: 1))
      @first_green_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_green_year_period.first,  @first_green_year_period.last).order(:claim_injury_date)

      @second_green_year = @first_green_year + 1
      @second_green_year_period = @first_green_year_period.first.advance(years: 1)..@first_green_year_period.last.advance(years: 1)
      @second_green_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @second_green_year_period.first,  @second_green_year_period.last).order(:claim_injury_date)

      # GREEN YEAR EXPERIENCE Totals

      @green_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_green_year_period.first,  @second_green_year_period.last).order(:claim_injury_date)

      @green_year_med_only = @green_year_claims.where("left(claim_type, 1) = '1'").count
      @green_year_loss_time = @green_year_claims.where("left(claim_type, 1) = '2'").count

      @green_year_comp_total = (@green_year_claims.sum(:claim_modified_losses_group_reduced) - @green_year_claims.sum(:claim_medical_paid) - @green_year_claims.sum(:claim_mira_medical_reserve_amount))

      @green_year_medical_total = @green_year_claims.sum(:claim_medical_paid)
      @green_year_mira_medical_reserve_total = @green_year_claims.sum(:claim_mira_medical_reserve_amount)
      @green_year_group_modidified_losses_total = @green_year_claims.sum(:claim_modified_losses_group_reduced)
      @green_year_individual_modidified_losses_total = @green_year_claims.sum(:claim_modified_losses_individual_reduced)
      @green_year_individual_reduced_total = @green_year_claims.sum(:claim_individual_reduced_amount)

      @current_expected_losses = 0

      @account.policy_calculation.manual_class_calculations.each do |man|
        @current_expected_losses += man.manual_class_expected_loss_rate * man.manual_class_current_estimated_payroll
      end

      @payroll_calculations = @policy_calculation.manual_class_calculations.map{|u| u.payroll_calculations}.flatten

      @payroll_periods = PayrollCalculation.select('reporting_period_start_date').group('payroll_calculations.reporting_period_start_date').where(:policy_number => @policy_calculation.policy_number).order(reporting_period_start_date: :desc).pluck(:reporting_period_start_date)



      @ilr = round(((@policy_calculation.policy_total_modified_losses_group_reduced * @policy_calculation.policy_total_current_payroll) / ( @policy_calculation.policy_total_four_year_payroll * @policy_calculation.policy_total_standard_premium)), 2)

      @f_s = round((((3660 * @experience_med_only) + (12500 * @experience_lost_time))/ @policy_calculation.policy_total_four_year_payroll) *  (@policy_calculation.policy_total_current_payroll / @policy_calculation.policy_total_standard_premium), 2)


      @erc =
      if @account.policy_calculation.currently_assigned_erc_representative_number == 0
        "N/A"
      else
        BwcCodesEmployerRepresentative.find_by(representative_number: @account.policy_calculation.currently_assigned_erc_representative_number).employer_rep_name
      end

      @grc =
      if @account.policy_calculation.currently_assigned_grc_representative_number == 0
        "N/A"
      else
        BwcCodesEmployerRepresentative.find_by(representative_number: @account.policy_calculation.currently_assigned_grc_representative_number).employer_rep_name
      end

      @clm =
      if @account.policy_calculation.currently_assigned_clm_representative_number == 0
        "N/A"
      else
        BwcCodesEmployerRepresentative.find_by(representative_number: @account.policy_calculation.currently_assigned_clm_representative_number).employer_rep_name
      end

      @risk =
      if @account.policy_calculation.currently_assigned_risk_representative_number == 0
        "N/A"
      else
        BwcCodesEmployerRepresentative.find_by(representative_number: @account.policy_calculation.currently_assigned_risk_representative_number).employer_rep_name
      end

      @group_rating_levels = BwcCodesIndustryGroupSavingsRatioCriterium.where(industry_group: @account.industry_group)

      @em_cap =
        if  @policy_calculation.policy_individual_experience_modified_rate > (2 * @policy_calculation.policy_program_histories.order(reporting_period_start_date: :desc).first.experience_modifier_rate)
          (2 * @policy_calculation.policy_program_histories.order(reporting_period_start_date: :desc).first.experience_modifier_rate )
        else
          @policy_calculation.policy_individual_experience_modified_rate
        end

      @sort_code =
        if @account.group_rating_rejections.where("program_type = 'group_rating'").empty? && @account.group_rating_qualification == 'accept'
          "accept"
        elsif @account.group_rating_rejections.where("program_type = 'group_rating'").empty? && @account.group_rating_qualification == 'reject'
          "manual_override"
        else
          @account.group_rating_rejections.where("program_type = 'group_rating'").pluck(:reject_reason).map { |i| "'" + i.to_s + "'" }.join(",").to_s.gsub(/\s|"|'/, '')
        end

      @group_rating_date =
          if @account.quotes.where("program_type = 0").first.nil?
            'N/A'
          else
            @account.quotes.where("program_type = 0").first.quote_sent_date
          end

      @group_retro_date =
          if @account.quotes.where("program_type = 1").first.nil?
            'N/A'
          else
            @account.quotes.where("program_type = 1").first.quote_sent_date
          end


      header
      stroke_horizontal_rule
      at_a_glance
      experience_statistics
      stroke_horizontal_rule
      expected_loss_development

      start_new_page
      claim_loss_run

      start_new_page
      group_discount_level
      coverage_status_history
      experience_modifier_history
      start_new_page
      payroll_and_premium_history

  end



  private

  def header
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 100, :height => 100) do
      if [9,10,16].include? @account.representative.id
        image "#{Rails.root}/app/assets/images/minute men hr.jpeg", height: 100
      else
        image "#{Rails.root}/app/assets/images/logo.png", height: 90
      end
      transparent(0) { stroke_bounds }
      # stroke_bounds
    end
    bounding_box([100, current_cursor], :width => 350, :height => 100) do
      text "#{ @account.name}", size: 14, style: :bold, align: :center
      text "DBA: #{ @account.policy_calculation.try(:trading_as_name) }", size: 12, align: :center
      text "Policy#: #{ @account.policy_number_entered }   |   Sale Contact: #{ @account.affiliates.find_by(role: 6).try(:first_name)} #{@account.affiliates.find_by(role: 6).try(:last_name)}   |   Co Code: #{ @account.affiliates.find_by(role: 2).try(:company_name)}", size: 12, align: :center
      text "Risk Report", size: 12, align: :center
      text "As of #{@group_rating.updated_at.in_time_zone("America/New_York").strftime("%m/%d/%y")} with #{ @group_rating.current_payroll_period_upper_date.in_time_zone("America/New_York").strftime("%Y").to_i + 1 } Rates", size: 12, align: :center
      text "Projected 2017 Experience", size: 12, align: :center, style: :bold_italic
      transparent(0) { stroke_bounds }
      # stroke_bounds
    end
  end

  def at_a_glance
    move_down 10
    text "At A Glance", size: 16, style: :bold, align: :center
    move_down 10
    text "Current Employer Rep: #{ @erc }", size: 12
    move_down 2
    text "Employer Rep Group Risk/Claim: #{ @grc }", size: 12
    move_down 2
    text "Employer Rep Claim: #{ @clm }", size: 12
    move_down 2
    text "Employer Rep Risk Management: #{ @risk }", size: 12
    move_down 10
    stroke_horizontal_rule
    pre_current_cursor = cursor

    move_down 10

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
    move_down 20
    text "Experience Statistics and EM Calculation:", style: :bold
    move_down 5
    table experience_table_data do
      self.position = :center
      row(0).font_style = :bold
      row(0).borders = [:bottom]
      row(1).columns(0..14).borders = []
      row(0).align = :center
      row(0..-1).align = :center
      self.cell_style = {:size => 8}
      self.header = true
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
      text   text "Group Date: #{ @group_rating_date }", style: :bold
      transparent(0) { stroke_bounds }
    end

    bounding_box([325, current_cursor], :width => 150, :height => 15) do
      text "GRTRO Date: #{@group_retro_date}", style: :bold
      transparent(0) { stroke_bounds }
    end

    move_down 10

  end

  def experience_table_data
    @data = [["ITML", "GTML", "TEL", "Ratio", "IG", "TLL", "C%", "EMR", "CAP", "Max Value", "Stand Prem", "F/S", "ILR", "10YLR", "4YLR" ]]
    @data += [[round(@policy_calculation.policy_total_modified_losses_individual_reduced,0), round(@policy_calculation.policy_total_modified_losses_group_reduced,0), round(@policy_calculation.policy_total_expected_losses,0), round(@policy_calculation.policy_group_ratio - 1, 4), @policy_calculation.policy_industry_group, round(@policy_calculation.policy_total_limited_losses,0), percent(@policy_calculation.policy_credibility_percent), round(@policy_calculation.policy_individual_experience_modified_rate,2), round(@em_cap,2), round(@policy_calculation.policy_maximum_claim_value,0), round(@policy_calculation.policy_total_standard_premium,0), "#{@f_s}", "#{@ilr}" ]]
  end

  def expected_loss_development
    move_down 10
    text "Expected Loss Development and Estimated Premium:", style: :bold
    move_down 10
    table expected_loss_table_data, :column_widths => {0 => 30, 1 => 20, 2 => 60, 3 => 30, 4 => 55, 5 => 30, 6 => 60, 7 => 35, 8 => 50, 9 => 35, 10 => 50, 11 => 35, 12 => 50 } do
      self.position = :center
      row(0).font_style = :bold
      row(-1).font_style = :bold
      row(0).overflow = :shring_to_fit
      row(0).align = :center
      row(0).borders = [:bottom]
      row(1..-2).borders = []
      row(-1).borders = [:top]
      # row(1).columns(0..14).borders = []
      row(0..-1).align = :center
      self.cell_style = {:size => 8}
      self.header = true
    end
    move_down 10
    text "Current Expected Losses: #{ round(@current_expected_losses,0) }", style: :bold
  end

  def expected_loss_table_data
    @data = [["Man Num", "IG", "Experience Payroll", "Exp. Loss Rate", "Total Exp Losses", "Base Rate", "Estimated Payroll", "Ind. Rate", "Est Ind Premium", "#{@account.group_rating_tier} Group Rate", "Group Premium", "MMS Rate", "MMS Premium"]]
    @data +=  @account.policy_calculation.manual_class_calculations.order(manual_number: :asc).map { |e| [e.manual_number, e.manual_class_industry_group, round(e.manual_class_four_year_period_payroll,0), rate(e.manual_class_expected_loss_rate, 2),  round(e.manual_class_expected_losses,0), rate(e.manual_class_base_rate,2), round(e.manual_class_current_estimated_payroll, 0), rate(e.manual_class_individual_total_rate, 4), round(e.manual_class_estimated_individual_premium,0), rate(e.manual_class_group_total_rate,4), round(e.manual_class_estimated_group_premium,0)] }
    @data += [[{:content => " #{ } Totals", :colspan => 4},"#{round(@policy_calculation.policy_total_expected_losses, 0)}","","#{round(@policy_calculation.policy_total_current_payroll, 0)}","","#{round(@policy_calculation.policy_total_individual_premium, 0)}","","#{round(@account.group_premium, 0)}", "", ""]]
  end

  def claim_loss_run
    text "Claim Loss Run", size: 14, style: :bold, align: :center
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

    #############################################################
    # TEN YEAR Experience Totals
    move_down 15
    ten_year_total_table
    move_down 15

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



  def green_year_total_table
    table totals_green_year_data, :column_widths => {0 => 49, 1 => 55, 2 => 47, 3 => 32, 4 => 50, 5 => 50, 6 => 48, 7 => 48, 8 => 50, 9 => 50, 10 => 26, 11 => 35 }  do
      self.position = :center
      row(0).font_style = :bold
      row(1).font_style = :bold
      row(0).overflow = :shring_to_fit
      row(0).align = :center
      row(0).borders = [:bottom]
      row(-1).borders = [:top]
      self.cell_style = { size: 10 }
      self.header = true
    end
  end


  def totals_green_year_data
    @data = [[{:content => "Green Year Totals", :colspan => 4},"#{ round(@green_year_comp_total,0) }","#{round(@green_year_medical_total,0)}","#{round(@green_year_mira_medical_reserve_total,0)}","#{round(@green_year_group_modidified_losses_total,0)}","#{round(@green_year_individual_modidified_losses_total,0)}","#{round(@green_year_individual_reduced_total,0)}","","" ]]
  end



  def out_of_experience_year_total_table
    table totals_out_of_experience_year_data, :column_widths => {0 => 49, 1 => 55, 2 => 47, 3 => 32, 4 => 50, 5 => 50, 6 => 48, 7 => 48, 8 => 50, 9 => 50, 10 => 26, 11 => 35 }  do
      self.position = :center
      row(0).font_style = :bold
      row(1).font_style = :bold
      row(0).overflow = :shring_to_fit
      row(0).align = :center
      row(0).borders = [:bottom]
      row(-1).borders = [:top]
      self.cell_style = { size: 9 }
      self.header = true
    end
  end


  def totals_out_of_experience_year_data
    @data = [[{:content => "Out Of Experience Year Totals", :colspan => 4},"#{ round(@out_of_experience_comp_total,0) }","#{round(@out_of_experience_medical_total,0)}","#{round(@out_of_experience_mira_medical_reserve_total,0)}","#{round(@out_of_experience_group_modidified_losses_total,0)}","#{round(@out_of_experience_individual_modidified_losses_total,0)}","#{round(@out_of_experience_si_total,0)}","","" ]]
  end

  def experience_year_total_table
    table totals_experience_year_data, :column_widths => {0 => 49, 1 => 55, 2 => 47, 3 => 32, 4 => 50, 5 => 50, 6 => 48, 7 => 48, 8 => 50, 9 => 50, 10 => 26, 11 => 35 }  do
      self.position = :center
      row(0).font_style = :bold
      row(1).font_style = :bold
      row(0).overflow = :shring_to_fit
      row(0).align = :center
      row(0).borders = [:bottom]
      row(-1).borders = [:top]
      self.cell_style = { size: 9 }
      self.header = true
    end
    first_cursor = cursor
    bounding_box([0, first_cursor], :width => 275, :height => 25) do
      text "Med Only Claim Count: #{@experience_med_only}", style: :bold, :indent_paragraphs => 30
      text "Lost Time Claim Count: #{@experience_lost_time}", style: :bold, :indent_paragraphs => 30
    end
    bounding_box([380, first_cursor], :width => 100, :height => 25) do
      text "SI Average: #{round(@experience_si_avg, 0)}", style: :bold
      text "SI Ratio Avg: #{round(@experience_si_ratio_avg, 0)}", style: :bold
    end
  end


  def totals_experience_year_data
    @data = [[{:content => "Experience Year Totals", :colspan => 4},"#{ round(@experience_comp_total,0) }","#{round(@experience_medical_total,0)}","#{round(@experience_mira_medical_reserve_total,0)}","#{round(@experience_group_modidified_losses_total,0)}","#{round(@experience_individual_modidified_losses_total,0)}","#{round(@experience_si_total,0)}","","" ]]
  end

  def ten_year_total_table
    table ten_year_total_data, :column_widths => {0 => 49, 1 => 55, 2 => 47, 3 => 32, 4 => 50, 5 => 50, 6 => 48, 7 => 48, 8 => 50, 9 => 50, 10 => 26, 11 => 35 }  do
      self.position = :center
      row(0).font_style = :bold
      row(1).font_style = :bold
      row(0).overflow = :shring_to_fit
      row(0).align = :center
      row(0).borders = [:bottom]
      row(-1).borders = [:top]
      self.cell_style = { size: 9 }
      self.header = true
    end
    first_cursor = cursor
    bounding_box([0, first_cursor], :width => 275, :height => 25) do
      text "Med Only Claim Count: #{@ten_year_med_only}     RCO1: #{ @ten_year_rc_01 }", style: :bold, :indent_paragraphs => 30
      text "Lost Time Claim Count: #{@ten_year_lost_time}     RCO1: #{@ten_year_rc_02}", style: :bold, :indent_paragraphs => 30
    end
    bounding_box([380, first_cursor], :width => 100, :height => 25) do
      text "SI Average: #{round(@ten_year_si_average, 0)}", style: :bold
      text "SI Ratio Avg: #{@ten_year_si_ratio_avg}", style: :bold
    end

  end


  def ten_year_total_data
    @data = [[{:content => "10 Year Totals", :colspan => 4},"#{ round(@ten_year_comp_total,0) }","#{round(@ten_year_medical_total,0)}","#{round(@ten_year_mira_medical_reserve_total,0)}","#{round(@ten_year_group_modidified_losses_total,0)}","#{round(@ten_year_individual_modidified_losses_total,0)}","#{round(@ten_year_si_total,0)}","","" ]]
  end



  def year_claim_table(claim_year_data)
    table claim_year_data, :column_widths => { 0 => 45, 1 => 80, 2 => 40, 3 => 25, 4 => 45, 5 => 45, 6 => 45, 7 => 45, 8 => 45, 9 => 45, 10 => 25, 11 => 55 } do
      self.position = :center
      row(0).font_style = :bold
      row(0).overflow = :shring_to_fit
      row(0).align = :center
      row(0).borders = [:bottom]
      row(1..-2).borders = []
      row(-1).borders = [:top]
      row(-1).font_style = :bold
      row(0..-1).align = :center
      row(0..-1).columns(1).align = :left
      self.cell_style = { size: 7 }
      self.header = true
    end
  end

  def claim_data(claims_array)
    @data = [["Claim #", "Claimant", "DOI", "Man Num", "Comp Award", "Med. Paid", "MIRA Res.", "GTML", "ITML", "SI Total", "HC", "Code" ]]
    @data +=  claims_array.map { |e| [e.claim_number, e.claimant_name.titleize, e.claim_injury_date.in_time_zone("America/New_York").strftime("%m/%d/%y"), e.claim_manual_number, "#{round((e.claim_modified_losses_group_reduced - e.claim_medical_paid - e.claim_mira_medical_reserve_amount),0) }", round(e.claim_medical_paid, 0), round(e.claim_mira_medical_reserve_amount,0), round(e.claim_modified_losses_group_reduced,0), round(e.claim_modified_losses_individual_reduced, 0), round((e.claim_unlimited_limited_loss - e.claim_total_subrogation_collected),0), percent(e.claim_handicap_percent), "#{claim_code_calc(e)}" ] }
    @data += [[{:content => "Totals", :colspan => 4},"#{round((claims_array.sum(:claim_modified_losses_group_reduced) - claims_array.sum(:claim_medical_paid) - claims_array.sum(:claim_mira_medical_reserve_amount)), 0)}", "#{round(claims_array.sum(:claim_medical_paid), 0)}", "#{round(claims_array.sum(:claim_mira_medical_reserve_amount), 0)}" , "#{round(claims_array.sum(:claim_modified_losses_group_reduced), 0)}", "#{round(claims_array.sum(:claim_modified_losses_individual_reduced), 0)}", "#{round(claims_array.sum(:claim_unlimited_limited_loss) - claims_array.sum(:claim_total_subrogation_collected), 0)}", "", "" ]]
  end

  def group_discount_level
    move_down 30
    text "Group Discount Levels", style: :bold, size: 18, align: :center
    group_discount_level_table
  end


  def group_discount_level_table
    table group_discount_level_data do
      self.position = :center
      row(0).font_style = :bold
      row(0).overflow = :shring_to_fit
      row(0).align = :center
      row(0).borders = [:bottom]
      row(1..-1).borders = []
      row(0..-1).align = :center
      self.cell_style = { size: 8 }
      self.header = true
    end
  end

  def group_discount_level_data
    @data = [["Market TM%", "Cut Point", "Cut Losses", "Level" ]]
    @data +=  @group_rating_levels.map do |e|
      if e.ac26_group_level == @account.group_rating_group_number
        [ e.market_rate, round((e.ratio_criteria - 1),4), round((((e.ratio_criteria - 1) * @policy_calculation.policy_total_expected_losses) + @policy_calculation.policy_total_expected_losses), 0), "Qualified" ]
      else
        [ e.market_rate, round((e.ratio_criteria - 1),4), round((((e.ratio_criteria - 1) * @policy_calculation.policy_total_expected_losses) + @policy_calculation.policy_total_expected_losses), 0), "" ]
      end
    end
  end



  def coverage_status_history
    move_down 30
    text "Coverage Dates and Status", style: :bold, size: 14, align: :center
    move_down 5
    coverage_status_history_table
  end

  def coverage_status_history_table
    table coverage_status_history_data do
      self.position = :center
      row(0).font_style = :bold
      row(0).overflow = :shring_to_fit
      row(0).align = :center
      row(0).borders = [:bottom]
      row(1..-1).borders = []
      row(0..-1).align = :center
      self.header = true
    end
  end

  def coverage_status_history_data
    @data = [["Effective Date", "End Date", "Status" ]]
    @data +=  @account.policy_calculation.policy_coverage_status_histories.order(coverage_effective_date: :desc).map { |e| [ e.coverage_effective_date, e.coverage_end_date, e.coverage_status ] }
  end

  def experience_modifier_history
    move_down 30
    text "Experience Modifier History", style: :bold, size: 14, align: :center
    experience_modifier_history_table
  end

  def experience_modifier_history_table
    table experience_modifier_history_data do
      self.position = :center
      row(0).font_style = :bold
      row(0).overflow = :shring_to_fit
      row(0).align = :center
      row(0).borders = [:bottom]
      row(1..-1).borders = []
      row(0..-1).align = :center
      self.header = true
    end
  end

  def experience_modifier_history_data
    @data = [["Period", "EM", "Group Plan", "Retro%", "Ded%", "OCP Year", "GROH", "DF/Level", "EMCap", "TWBNS", "ISSP" ]]
    @data +=  @account.policy_calculation.policy_program_histories.where("reporting_period_start_date >= ?", @first_out_of_experience_year_period.first).order(reporting_period_start_date: :desc).map { |e| [ e.reporting_period_start_date, e.experience_modifier_rate, e.group_type, e.rrr_minimum_premium_percentage, e.deductible_discount_percentage, e.ocp_first_year_of_participation, e.grow_ohio_participation_indicator, "#{e.drug_free_program_participation_indicator}/#{e.drug_free_program_participation_level}", e.em_cap_participation_indicator, e.twbns_participation_indicator, e.issp_participation_indicator ] }
  end

  def payroll_and_premium_history
    text "Payroll And Premium Histroy", style: :bold, size: 14, align: :center

    @payroll_periods.each do |period|
      @premium_total = 0
      @policy_calculation.manual_class_calculations.each do |man|
        unless PayrollCalculation.find_by(reporting_period_start_date: period, policy_number: @policy_calculation.policy_number, manual_number: man.manual_number).nil?
          @premium_total += ((PayrollCalculation.find_by(reporting_period_start_date: period, policy_number: @policy_calculation.policy_number, manual_number: man.manual_number).manual_class_payroll)  * (PayrollCalculation.find_by(reporting_period_start_date: period, policy_number: @policy_calculation.policy_number, manual_number: man.manual_number).manual_class_rate * 0.01))
        end
      end
      payroll_and_premium_history_table(payroll_and_premium_history_data(PayrollCalculation.where("reporting_period_start_date = ? and policy_number = ?", period, @policy_calculation.policy_number), @premium_total))
    end
  end




  def payroll_and_premium_history_table(payroll_and_premium_history_data)
    table payroll_and_premium_history_data, :column_widths => {0 => 100, 1 => 75, 2 => 75, 3 => 75, 4 => 75, 5 => 75 } do
      self.position = :center
      row(0).font_style = :bold
      row(0).overflow = :shring_to_fit
      row(0).align = :center
      row(0).borders = [:bottom]
      row(1..-1).borders = []
      row(0..-1).align = :center
      row(-1).borders = [:top]
      row(-1).font_style = :bold
      # self.cell_style = { size: 8 }
      self.header = true
    end
  end

  def payroll_and_premium_history_data(payroll_array, premium_total)
    @data = [["Period", "Manual", "Payroll", "Adjusted", "Rate", "Premium"]]
    @data +=  payroll_array.order(manual_number: :asc).map { |e| ["#{e.reporting_period_start_date.strftime("%-m/%-d/%y")} - #{e.reporting_period_end_date.strftime("%-m/%-d/%y")}", e.manual_number, round(e.manual_class_payroll,0), e.data_source, e.manual_class_rate, "#{round((e.manual_class_rate * 0.01) * e.manual_class_payroll, 0)}" ] }
    @data += [[{:content => "Period Totals", :colspan => 2}, "#{round(payroll_array.sum(:manual_class_payroll), 0)}", "", "", "#{ round(premium_total,0) }" ]]
  end

  def claim_code_calc(claim)
    claim_code = ''
    if claim.claim_type[0] == 1
      claim_code  << "MO/"
    else
      claim_code  << "LT/"
    end
    claim_code << claim.claim_status
    claim_code << "/"
    claim_code << claim.claim_mira_ncci_injury_type
    if claim.claim_type[-1] == 1
      claim_code  << "/NO COV"
    end
    return claim_code
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
    num = num * 100
    @view.number_to_percentage(num, precision: 0)
  end


end
