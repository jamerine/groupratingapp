class RiskReport < PdfReport

  def initialize(account=[],policy_calculation=[],group_rating=[],view)
    super()
    @account = account
    @policy_calculation = policy_calculation
    @policy_program_history = @policy_calculation.policy_program_histories.order(:policy_year).last
    @group_rating = group_rating
    @view = view

    # Section for calculating parameters for Claim Loss Runs

      # Experience Years Parameters

      @first_experience_year = @group_rating.experience_period_lower_date.strftime("%Y").to_i
      @first_experience_year_period = @group_rating.experience_period_lower_date..(("#{(@group_rating.experience_period_lower_date.strftime("%Y").to_i)}-12-31").to_date)
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

      @fifth_experience_year = @fourth_experience_year + 1
      @fifth_experience_year_period = @fourth_experience_year_period.first.advance(years: 1)..@first_experience_year_period.first.advance(days: -1).advance(years: 4)
      @fifth_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @fifth_experience_year_period.first,  @fifth_experience_year_period.last).order(:claim_injury_date)

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



      # Out Of Experience Years Parameters
      @first_out_of_experience_year = @first_experience_year - 5
      @first_out_of_experience_year_period = @first_experience_year_period.first.advance(years: -5)..@first_experience_year_period.last.advance(years: -5)
      @first_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_out_of_experience_year_period.first,  @first_out_of_experience_year_period.last).order(:claim_injury_date)

      @second_out_of_experience_year = @second_experience_year - 5
      @second_out_of_experience_year_period = @second_experience_year_period.first.advance(years: -5)..@second_experience_year_period.last.advance(years: -5)
      @second_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @second_out_of_experience_year_period.first,  @second_out_of_experience_year_period.last).order(:claim_injury_date)

      @third_out_of_experience_year = @third_experience_year - 5
      @third_out_of_experience_year_period = @third_experience_year_period.first.advance(years: -5)..@third_experience_year_period.last.advance(years: -5)
      @third_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @third_out_of_experience_year_period.first,  @third_out_of_experience_year_period.last).order(:claim_injury_date)

      @fourth_out_of_experience_year = @fourth_experience_year - 5
      @fourth_out_of_experience_year_period = @fourth_experience_year_period.first.advance(years: -5)..@fourth_experience_year_period.last.advance(years: -5)
      @fourth_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @fourth_out_of_experience_year_period.first,  @fourth_out_of_experience_year_period.last).order(:claim_injury_date)

      @fifth_out_of_experience_year = @fifth_experience_year - 5
      @fifth_out_of_experience_year_period = @fourth_out_of_experience_year_period.first.advance(years: 1)..@fourth_out_of_experience_year_period.last.advance(years: 1)
      @fifth_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @fifth_out_of_experience_year_period.first,  @fifth_out_of_experience_year_period.last).order(:claim_injury_date)

      @sixth_out_of_experience_year = @fifth_out_of_experience_year + 1
      @sixth_out_of_experience_year_period = @fifth_experience_year_period.first.advance(years: -4)..@fifth_experience_year_period.last.advance(years: -4)
      @sixth_out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @sixth_out_of_experience_year_period.first,  @sixth_out_of_experience_year_period.last).order(:claim_injury_date)

      # Out Of Experience Totals

      @out_of_experience_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_out_of_experience_year_period.first,  @sixth_out_of_experience_year_period.last).order(:claim_injury_date)
      @out_of_experience_med_only = @out_of_experience_year_claims.where("left(claim_type, 1) = '1'").count
      @out_of_experience_lost_time = @out_of_experience_year_claims.where("left(claim_type, 1) = '2'").count


      @out_of_experience_comp_total = (@out_of_experience_year_claims.sum(:claim_modified_losses_group_reduced) - @out_of_experience_year_claims.sum(:claim_medical_paid) - @out_of_experience_year_claims.sum(:claim_mira_medical_reserve_amount))

      @out_of_experience_medical_total = @out_of_experience_year_claims.sum(:claim_medical_paid)
      @out_of_experience_mira_medical_reserve_total = @out_of_experience_year_claims.sum(:claim_mira_medical_reserve_amount)
      @out_of_experience_group_modidified_losses_total = @out_of_experience_year_claims.sum(:claim_modified_losses_group_reduced)
      @out_of_experience_individual_modidified_losses_total = @out_of_experience_year_claims.sum(:claim_modified_losses_individual_reduced)
      @out_of_experience_individual_reduced_total = @out_of_experience_year_claims.sum(:claim_individual_reduced_amount)

      # GREEN YEAR EXPERIENCE
      @first_green_year = @group_rating.experience_period_upper_date.strftime("%Y").to_i
      @first_green_year_period = (@group_rating.experience_period_upper_date.advance(days: 1))..(("#{(@group_rating.experience_period_upper_date.strftime("%Y").to_i)}-12-31").to_date)
      @first_green_year_claims = @account.policy_calculation.claim_calculations.where("claim_injury_date BETWEEN ? AND ? ", @first_green_year_period.first,  @first_green_year_period.last).order(:claim_injury_date)

      @second_green_year = @first_green_year + 1
      @second_green_year_period = @first_green_year_period.last.advance(days: 1)..@first_green_year_period.last.advance(years: 1)
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

      header
      stroke_horizontal_rule
      at_a_glance
      experience_statistics
      stroke_horizontal_rule
      expected_loss_development

      start_new_page
      claim_loss_run

  end



  private

  def header
    # if [9,10,16].include? @account.representative.id
    #   image "#{Rails.root}/app/assets/images/minute men hr.jpeg", height: 75
    # else
    #   image "#{Rails.root}/app/assets/images/logo.png", height: 50
    # end
    text "#{ @account.name}", size: 16, style: :bold, align: :center
    text "DBA: #{ @account.policy_calculation.try(:trading_as_name) }", size: 12, align: :center
    text "Policy#: #{ @account.policy_number_entered }   |   Sale Contact: #{ @account.affiliates.find_by(role: 6).try(:first_name)} #{@account.affiliates.find_by(role: 6).try(:last_name)}   |   Co Code: #{ @account.affiliates.find_by(role: 2).try(:company_name)}", size: 12, align: :center
    text "Risk Report", size: 12, align: :center
    text "As of #{@group_rating.updated_at.in_time_zone("America/New_York").strftime("%m/%d/%y")} with #{ @group_rating.current_payroll_period_upper_date.in_time_zone("America/New_York").strftime("%Y").to_i + 1 } Rates", size: 12, align: :center
    text "Projected 2017 Experience", size: 12, align: :center, style: :bold_italic

  end

  def at_a_glance
    move_down 10
    text "At A Glance", size: 16, style: :bold, align: :center
    move_down 10
    text "Current Employer Rep: #{@account.policy_calculation.currently_assigned_erc_representative_number}", size: 12
    text "Employer Rep Group Risk/Claim: #{@account.policy_calculation.currently_assigned_grc_representative_number}", size: 12
    text "Employer Rep Claim: #{@account.policy_calculation.currently_assigned_clm_representative_number}", size: 12
    text "Employer Rep Risk Management: #{@account.policy_calculation.currently_assigned_risk_representative_number}", size: 12
    move_down 10
    stroke_horizontal_rule
    # stroke_axis
    stroke do
     # just lower the current y position
     vertical_line 400, 525, :at => 275
     horizontal_line 0, 545, :at => 400
    end

    move_down 10
    bounding_box([0, 515], :width => 275, :height => 125) do
      text "FEIN: #{ @account.policy_calculation.federal_identification_number }"
      move_down 15
      text "Current Status: #{@account.policy_calculation.coverage_status_effective_date}-#{ @account.policy_calculation.current_coverage_status }", size: 10
      text "Immediate Combo Policy: #{@policy_calculation.immediate_successor_policy_number}"
      text "Ultimate Combo Policy: #{@policy_calculation.ultimate_successor_policy_number}"
      text "Group Days Lapse: "
      text "Group Retro Days Lapse: "
      text "Currently Lapsed: "
     transparent(0) { stroke_bounds }
    end

    bounding_box([285, 515], :width => 275, :height => 125) do
      text "Current Rating Plan:", style: :bold
      move_down 5
      text "Current EM: #{@policy_program_history.experience_modifier_rate}"
      text "Retro Min%: #{ @policy_program_history.rrr_minimum_premium_percentage }"
      text "One Claim: #{ @policy_program_history.ocp_participation_indicator }   OCP_Year: #{ @policy_program_history.ocp_first_year_of_participation }"
      text "EM Capping: #{ @policy_program_history.em_cap_participation_indicator }"
      text "DFSP: #{ @policy_program_history.drug_free_program_participation_indicator }"
      text "Deductible %: #{ @policy_program_history.deductible_participation_indicator }"
      text "Trans Work: #{ @policy_program_history.twbns_participation_indicator }  ISSP: #{@policy_program_history.issp_participation_indicator }"
      text "Grow Ohio: #{@policy_program_history.drug_free_program_participation_indicator  }"
     transparent(0) { stroke_bounds }
    end
  end

  def experience_statistics
    move_down 10
    text "Experience Statistics and EM Calculation", style: :bold
    move_down 5
    table experience_table_data do
      self.position = :center
      row(0).font_style = :bold
      row(0).borders = [:bottom]
      row(1).columns(0..14).borders = []
      row(0).align = :center
      row(0..-1).align = :center
      self.cell_style = {:font_size => 8}
      self.header = true
    end
    move_down 5
    text "Cycle Date: #{ @account.cycle_date }  |  Sort Code: |  Partner:  "
    text "Group Date: #{ @account.cycle_date }  |  GRTRO Date: "
    move_down 5

  end

  def experience_table_data
    @data = [["ITML", "GTML", "TEL", "Ratio", "IG", "TLL", "C%", "EMR", "CAP", "Max Value", "Stand Prem", "F/S", "ILR" ]]
    @data += [[round(@policy_calculation.policy_total_modified_losses_individual_reduced,0), round(@policy_calculation.policy_total_modified_losses_group_reduced,0), round(@policy_calculation.policy_total_expected_losses,0), round(@policy_calculation.policy_group_ratio, 0), @policy_calculation.policy_industry_group, round(@policy_calculation.policy_total_limited_losses,0), percent(@policy_calculation.policy_credibility_percent), round(@policy_calculation.policy_individual_experience_modified_rate,2),round( @policy_calculation.policy_individual_experience_modified_rate,2), round(@policy_calculation.policy_maximum_claim_value,0), round(@policy_calculation.policy_total_standard_premium,0), "fs", "ILR" ]]
  end

  def expected_loss_development
    move_down 10
    text "Expected Loss Development and Estimated Premium", style: :bold
    move_down 10
    table expected_loss_table_data, :column_widths => {0 => 35, 1 => 25, 2 => 60, 3 => 40, 4 => 60, 5 => 40, 6 => 60, 7 => 45, 8 => 60, 9 => 45, 10 => 60 } do
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
      self.cell_style = {:font_size => 8}
      self.header = true
    end
    move_down 10
    text "Current Expected Losses: #{ round(@current_expected_losses,2) }", style: :bold
  end

  def expected_loss_table_data
    @data = [["Man Num", "IG", "Exp. Payroll", "Exp. Loss Rate", "Total Exp Losses", "Base Rate", "Est. Payroll", "Ind. Rate", "Est Ind Premium", "Group Rate", "Group Prem"]]
    @data +=  @account.policy_calculation.manual_class_calculations.map { |e| [e.manual_number, e.manual_class_industry_group, round(e.manual_class_four_year_period_payroll,0), rate(e.manual_class_expected_loss_rate, 2),  round(e.manual_class_expected_losses,0), rate(e.manual_class_base_rate,2), round(e.manual_class_current_estimated_payroll, 0), rate(e.manual_class_individual_total_rate, 4), round(e.manual_class_estimated_individual_premium,0), rate(e.manual_class_group_total_rate,4), round(e.manual_class_estimated_group_premium,0)] }
    @data += [[{:content => " #{ } Totals", :colspan => 4},"#{round(@policy_calculation.policy_total_expected_losses, 0)}","","#{round(@policy_calculation.policy_total_current_payroll, 0)}","","#{round(@policy_calculation.policy_total_individual_premium, 0)}","","#{round(@account.group_premium, 0)}"]]
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
    move_down 30
    text "Injury Year: #{ @sixth_out_of_experience_year}", style: :bold
    year_claim_table(claim_data(@sixth_out_of_experience_year_claims))


    #############################################################
    # Out of Experience Totals
    move_down 15
    out_of_experience_year_total_table
    move_down 10
    text "Med Only Claim Count: #{@out_of_experience_med_only}", style: :bold
    text "Lost Time Claim Count: #{@out_of_experience_lost_time}", style: :bold
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
    move_down 30
    text "Injury Year: #{ @fifth_experience_year}", style: :bold
    year_claim_table(claim_data(@fifth_experience_year_claims))


    #############################################################
    # IN Experience Totals
    move_down 15
    experience_year_total_table
    move_down 10
    text "Med Only Claim Count: #{@experience_med_only}", style: :bold
    text "Lost Time Claim Count: #{@experience_lost_time}", style: :bold
    move_down 30

    #############################################################

    #Green Year
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
    text "Med Only Claim Count: #{@green_year_med_only}", style: :bold
    text "Lost Time Claim Count: #{@green_year_loss_time}", style: :bold
    move_down 30

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
      self.cell_style = { size: 10 }
      self.header = true
    end
  end


  def totals_out_of_experience_year_data
    @data = [[{:content => "Out Of Experience Year Totals", :colspan => 4},"#{ round(@out_of_experience_comp_total,0) }","#{round(@out_of_experience_medical_total,0)}","#{round(@out_of_experience_mira_medical_reserve_total,0)}","#{round(@out_of_experience_group_modidified_losses_total,0)}","#{round(@out_of_experience_individual_modidified_losses_total,0)}","#{round(@out_of_experience_individual_reduced_total,0)}","","" ]]
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
      self.cell_style = { size: 10 }
      self.header = true
    end
  end


  def totals_experience_year_data
    @data = [[{:content => "Experience Year Totals", :colspan => 4},"#{ round(@experience_comp_total,0) }","#{round(@experience_medical_total,0)}","#{round(@experience_mira_medical_reserve_total,0)}","#{round(@experience_group_modidified_losses_total,0)}","#{round(@experience_individual_modidified_losses_total,0)}","#{round(@experience_individual_reduced_total,0)}","","" ]]
  end



  def year_claim_table(claim_year_data)
    table claim_year_data, :column_widths => {0 => 49, 1 => 55, 2 => 47, 3 => 32, 4 => 50, 5 => 50, 6 => 48, 7 => 48, 8 => 50, 9 => 50, 10 => 26, 11 => 35 } do
      self.position = :center
      row(0).font_style = :bold
      row(0).overflow = :shring_to_fit
      row(0).align = :center
      row(0).borders = [:bottom]
      row(1..-2).borders = []
      row(-1).borders = [:top]
      row(-1).font_style = :bold
      row(0..-1).align = :center
      self.cell_style = { size: 8 }
      self.header = true
    end
  end

  def claim_data(claims_array)
    @data = [["Claim #", "Claimant", "DOI", "Man Num", "Comp Award", "Med. Paid", "MIRA Res.", "GTML", "ITML", "SI Total", "HC", "Code" ]]
    @data +=  claims_array.map { |e| [e.claim_number, e.claimant_name.titleize, e.claim_injury_date.in_time_zone("America/New_York").strftime("%m/%d/%y"), e.claim_manual_number, "#{round((e.claim_modified_losses_group_reduced - e.claim_medical_paid - e.claim_mira_medical_reserve_amount),0) }", round(e.claim_medical_paid, 0), round(e.claim_mira_medical_reserve_amount,0), round(e.claim_modified_losses_group_reduced,0), round(e.claim_modified_losses_individual_reduced, 0), round(e.claim_individual_reduced_amount,0), percent(e.claim_handicap_percent), e.claim_type ] }
    @data += [[{:content => "Totals", :colspan => 4},"#{round((claims_array.sum(:claim_modified_losses_group_reduced) - claims_array.sum(:claim_medical_paid) - claims_array.sum(:claim_mira_medical_reserve_amount)), 0)}", "#{round(claims_array.sum(:claim_medical_paid), 0)}", "#{round(claims_array.sum(:claim_mira_medical_reserve_amount), 0)}" , "#{round(claims_array.sum(:claim_modified_losses_group_reduced), 0)}", "#{round(claims_array.sum(:claim_modified_losses_individual_reduced), 0)}", "#{round(claims_array.sum(:claim_individual_reduced_amount), 0)}", "", "" ]]
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
