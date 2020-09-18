class RocReport < PdfReport

  def initialize(account=[],policy_calculation=[],group_rating=[],view)
    super()
    @account = account
    @policy_calculation = policy_calculation
    @policy_program_history = @policy_calculation.policy_program_histories.order(:policy_year).last
    @group_rating = group_rating
    @view = view


    @account = Account.includes(policy_calculation: [:policy_coverage_status_histories, :policy_program_histories, { manual_class_calculations: :payroll_calculations }]).find(@account.id)

    @current_policy_program = @account.policy_calculation.policy_program_histories.order(reporting_period_start_date: :desc).first

    @current_date = DateTime.now.to_date

    @total_est_payroll = 0
    @account.policy_calculation.manual_class_calculations.each do |man|
      rate = man.payroll_calculations.where("reporting_period_start_date < :current_date and reporting_period_end_date > :current_date", current_date: @current_date).first.manual_class_rate
      est_premium = rate * man.manual_class_current_estimated_payroll * 0.01
      @total_est_payroll += est_premium
    end

    header
    stroke_horizontal_rule
    estimated_current_period_premium

    workers_comp_program_options
    workers_comp_program_additional_options
    descriptions

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
      text "Policy#: #{ @account.policy_number_entered }", size: 10, style: :bold, align: :center
      move_down 2
      text "#{ @account.street_address}, #{ @account.city}, #{ @account.state}, #{ @account.zip_code}", size: 10, align: :center
      move_down 2
      text "As of #{@group_rating.updated_at.in_time_zone("America/New_York").strftime("%m/%d/%y")} with #{ @group_rating.current_payroll_period_upper_date.in_time_zone("America/New_York").strftime("%Y").to_i + 1 } Rates", size: 10, align: :center
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
      bounding_box([0, cursor], :width => 350) do
        table ([[ "Rating Plan: #{@current_policy_program.group_type }" , "Current EM: #{ @current_policy_program.experience_modifier_rate }", "OCP: #{ @current_policy_program.ocp_participation_indicator }", "EM CAP: #{ @current_policy_program.em_cap_participation_indicator }" ], [ "DFSP: #{@current_policy_program.drug_free_program_participation_indicator }" , "Ded Pct: #{ @current_policy_program.deductible_discount_percentage }", "ISSP: #{ @current_policy_program.issp_participation_indicator }", "TWBNS: #{ @current_policy_program.twbns_participation_indicator }" ]]), :column_widths => {0 => 87, 1 => 87, 2 => 87, 3 => 87 } do
          self.position = :center
          row(0..-1).borders = []
          self.cell_style = { size: 9 }
          cells.padding = 3
        end
        stroke_bounds
      end
      bounding_box([0, cursor], :width => 350) do
        table current_policy_data, :column_widths => {0 => 87, 1 => 87, 2 => 87, 3 => 87 }, :row_colors => ["FFFFFF", "F0F0F0"] do
          self.position = :center
          row(0).font_style = :bold
          row(0).overflow = :shring_to_fit
          row(0).align = :center
          row(0).borders = [:bottom]
          row(1..-1).borders = []
          row(0..-1).align = :center
          self.cell_style = { size: 9 }
          cells.padding = 3
        end
        table current_policy_data_total, :column_widths => {0 => 87, 1 => 87, 2 => 87, 3 => 87 } do
          self.position = :center
          row(0).font_style = :bold
          row(0).overflow = :shring_to_fit
          row(0).align = :center
          row(0).borders = [:top]
          row(0..-1).align = :center
          self.cell_style = { size: 9 }
        end
        stroke_bounds
      end
      stroke_bounds
    end

  end

  def current_policy_data
    @data = [["Manual", "Est Payroll", "Rate", "Est Premium" ]]
    @data += @policy_calculation.manual_class_calculations.order(manual_number: :asc).map { |e| [e.manual_number, round(e.manual_class_current_estimated_payroll,0), e.payroll_calculations.where("reporting_period_start_date < :current_date and reporting_period_end_date > :current_date", current_date: @current_date).first.manual_class_rate, "#{ round(e.payroll_calculations.where("reporting_period_start_date < :current_date and reporting_period_end_date > :current_date", current_date: @current_date).first.manual_class_rate * e.manual_class_current_estimated_payroll * 0.01,0)}"   ] }
  end

  def current_policy_data_total
    @data = [["Totals", "#{ round(@policy_calculation.policy_total_current_payroll,0) }", "", "#{round(@total_est_payroll, 0)}" ]]
  end

  def workers_comp_program_options
    move_down 10
    text "#{@account.representative.quote_year} Workers' Compensation Program Options [1]", size: 12, style: :bold, align: :center

    table workers_comp_program_options_data, :column_widths => {0 => 100, 1 => 63, 2 => 62, 3 => 62, 4 => 62, 5 => 62, 6 => 62, 7 => 62 }, :row_colors => ["FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "F0F0F0", "F0F0F0" ]  do
      self.position = :center
      row(0).font_style = :bold
      row(0).align = :center
      row(0).borders = [:bottom]
      row(0..-1).align = :right
      row(-2..-1).font_style = :bold
      self.cell_style = { size: 10 }
      self.before_rendering_page do |t|
        t.row(-2).border_top_width = 2
      end
    end
  end

  def workers_comp_program_options_data
    # Experience Rated
      @experience_eligibility = 'Yes'
      @experience_projected_premium = @policy_calculation.policy_total_individual_premium
      @experience_costs = 0
      @experience_maximum_risk = 0
      @experience_total_cost = @experience_projected_premium - @experience_costs
      @experience_savings = @policy_calculation.policy_total_individual_premium - @experience_total_cost

    # EM Cap
      @em_cap_eligibility =
        (@policy_calculation.policy_individual_experience_modified_rate > (2 * @policy_calculation.policy_program_histories.order(reporting_period_start_date: :desc).first.experience_modifier_rate) ? 'Yes' : 'No')
      if @em_cap_eligibility == 'Yes'
        @em_cap_projected_premium = (2 * @policy_calculation.policy_program_histories.order(reporting_period_start_date: :desc).first.experience_modifier_rate )
        @em_cap_costs = 0
        @em_cap_maximum_risk = 0
        @em_cap_total_cost = @em_projected_premium - @em_costs
        @em_cap_savings = @policy_calculation.policy_total_individual_premium - @em_total_cost
      else
        @em_cap_projected_premium = nil
        @em_cap_costs = nil
        @em_cap_maximum_risk = nil
        @em_cap_total_cost = nil
        @em_cap_savings = nil
      end


    # OCP

    # Group Rating
      @group_rating_eligibility = (@account.group_rating_qualification == 'accept' ? 'Yes' : 'No')
      if @group_rating_eligibility == 'Yes'
        @group_rating_projected_premium = @account.group_premium
        @group_rating_costs = 0
        @group_rating_maximum_risk = 0
        @group_rating_total_cost = @group_rating_projected_premium - @group_rating_costs
        @group_rating_savings = @policy_calculation.policy_total_individual_premium - @group_rating_total_cost
      else
        @group_rating_projected_premium = nil
        @group_rating_costs = nil
        @group_rating_maximum_risk = nil
        @group_rating_total_cost = nil
        @group_rating_savings = nil
      end

    # Group Retro
      @group_retro_eligibility = (@account.group_retro_qualification == 'accept' ? 'Yes' : 'No')
      if @group_retro_eligibility == 'Yes'
        @group_retro_projected_premium = @policy_calculation.policy_total_individual_premium
        @group_retro_costs = @account.group_retro_savings
        @group_retro_maximum_risk = (@policy_calculation.policy_total_standard_premium * 0.15)
        @group_retro_total_cost = @group_retro_projected_premium - @group_retro_costs
        @group_retro_savings = @policy_calculation.policy_adjusted_individual_premium - @group_retro_total_cost
      else
        @group_retro_projected_premium = nil
        @group_retro_costs = nil
        @group_retro_maximum_risk = nil
        @group_retro_total_cost = nil
        @group_retro_savings = nil
      end


    @data = [[" ","Experience Rated", "EM Cap", "One Claim Program", " #{ @account.group_rating_tier } Group", "Group Retro", "Individual Retro", "Minute Men Select" ]]
    @data += [[ "Eligibility","#{@experience_eligibility}","#{@em_cap_eligibility}"," ","#{@group_rating_eligibility}","#{@group_retro_eligibility}"," "," "]]
    @data += [[ "Projected Premium","#{ round(@experience_projected_premium, 0) }","#{ round(@em_cap_projected_premium,0)}"," ","#{round(@group_rating_projected_premium, 0)}","#{round(@group_retro_projected_premium, 0)}"," "," "]]
    @data += [[ "Est Cost/-Credits","#{ round(@experience_costs,0) }","#{ round(@em_cap_costs,0)}"," ","#{ round(@group_rating_costs,0) }","#{ round(-@group_retro_costs, 0)}"," "," "]]
    @data += [[ "Maximum Risk","#{ round(@experience_maximum_risk,0) }","#{ round(@em_cap_maximum_risk,0) }"," ","#{ round(@group_rating_maximum_risk,0) }","#{ round(@group_retro_maximum_risk, 0)}"," "," "]]
    @data += [[ "Total Est Cost","#{ round(@experience_total_cost,0) }","#{ round(@em_cap_total_cost,0)}"," ","#{ round(@group_rating_total_cost,0) }","#{ round(@group_retro_total_cost, 0)}"," "," "]]
    @data += [[ "Est Savings/-Loss","#{ round(@experience_savings,0) }","#{round( @em_cap_savings,0 )}"," ","#{ round(@group_rating_savings,0) }","#{ round(@group_retro_savings, 0)}"," "," "]]
  end


  def workers_comp_program_additional_options
    move_down 10
    text "Additional BWC Discounts, Rebates and Bonuses [2]", size: 12, style: :bold, align: :center
    move_down 5
    table workers_comp_program_additional_options_data, :column_widths => {0 => 100, 1 => 63, 2 => 62, 3 => 62, 4 => 62, 5 => 62, 6 => 62, 7 => 62 }, :row_colors => ["FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "F0F0F0", "F0F0F0"] do
      self.position = :center
      row(0).align = :center
      row(0..-1).align = :center
      row(-3..-1).font_style = :bold
      self.cell_style = { size: 10 }
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
      row(5).column(5).background_color = "aaa9a9"
      row(5).column(6).background_color = "aaa9a9"
      row(5).column(7).background_color = "aaa9a9"
    end

  end

  def workers_comp_program_additional_options_data

    ###### Drug-Free Safety
      @drug_free_experience = @policy_calculation.policy_total_standard_premium * 0.07
      @drug_free_group_rating = (@group_rating_eligibility == 'Yes' ? (@account.group_premium * 0.07) : nil)

    ###### Safety Council
      @safety_council_experience = (@policy_calculation.policy_total_standard_premium * 0.04)
      @safety_council_em_cap = (@em_cap_eligibility == 'Yes' ? (@em_projected_premium * 0.04) : nil)
      # @safety_council_ocp = (@policy_calculation.policy_total_standard_premium * 0.04)
      @safety_council_group_rating = (@group_retro_eligibility == 'Yes' ? (@account.group_premium * 0.02) : nil)
      @safety_council_group_retro = (@group_retro_eligibility == 'Yes' ? (@policy_calculation.policy_total_standard_premium * 0.02) : '')
      # @safety_council_individual_retro = (@account.group_retro_premium * 0.04)
      # @safety_council_mm_select = (@policy_calculation.policy_total_standard_premium * 0.04)

    ###### Industry Specific
      @industry_specific_experience = (@policy_calculation.policy_total_standard_premium * 0.03)
      @industry_specific_em_cap = (@em_cap_eligibility == 'Yes' ? (@em_projected_premium * 0.03) : nil)
      # @industry_specific_ocp = (@policy_calculation.policy_total_standard_premium * 0.03)
      @industry_specific_group_rating = (@group_rating_eligibility == 'Yes' ? (@account.group_premium * 0.03) : nil)
      # @industry_specific_individual_retro = (@account.group_premium * 0.03)
      # @industry_specific_mm_select

    ###### Transitional Work
      @transitional_work_experience = (@policy_calculation.policy_total_standard_premium * 0.1)
      @transitional_work_em_cap = (@em_cap_eligibility == 'Yes' ? (@em_projected_premium * 0.01) : nil)
      # @transitional_work_ocp = (@policy_calculation.policy_total_standard_premium * 0.03)
      @transitional_work_group_rating = ( @group_rating_eligibility == 'Yes' ? (@account.group_premium * 0.12) : nil)
      # @transitional_individual_retro_rating = (@account.group_premium * 0.1)
      # @transitional_mm_select

    ###### Go Green
      @go_green_experience = (@policy_calculation.policy_total_individual_premium * 0.01 > 2000 ? 2000 : @policy_calculation.policy_total_individual_premium * 0.01 )
      @go_green_em_cap = (@em_cap_eligibility == 'Yes' ? (@em_projected_premium * 0.01 > 2000 ? 2000 : @em_projected_premium * 0.01 ) : nil)
      # @go_green_ocp = (@policy_calculation.policy_total_standard_premium * 0.03)
      @go_green_group_rating = (@group_rating_eligibility == 'Yes' ? (@account.group_premium * 0.01 > 2000 ? 2000 : @account.group_premium * 0.01 ) : nil)
      @go_green_group_retro = ((@group_retro_eligibility == 'Yes') ? (@policy_calculation.policy_total_individual_premium * 0.1 > 2000) ? 2000 : (@policy_calculation.policy_total_individual_premium * 0.1) : nil)
      # @go_green_individual_retro = (@account.group_premium * 0.1)
      # @go_green_mm_select = (@account.group_premium * 0.1)

    ###### Lapse Free
      @lapse_free_experience = (@policy_calculation.policy_total_individual_premium * 0.01 > 2000 ? 2000 : @policy_calculation.policy_total_individual_premium * 0.01 )
      @lapse_free_em_cap = (@em_cap_eligibility == 'Yes' ? (@em_projected_premium * 0.01 > 2000 ? 2000 : @em_projected_premium * 0.01 ) : nil)
      # @lapse_free_ocp = (@policy_calculation.policy_total_standard_premium * 0.03)
      @lapse_free_group_rating = ( @group_rating_eligibility == 'Yes' ? (@account.group_premium * 0.01 > 2000 ? 2000 : @account.group_premium * 0.01 ) : nil)
      # @lapse_free_individual_retro = (@account.group_premium * 0.01 > 2000 ? 2000 : @account.group_premium * 0.01)
      # @lapse_free_mm_select = (@account.group_premium * 0.01 > 2000 ? 2000 : @account.group_premium * 0.01 )

    ###### Max Add'l Savings
      @max_savings_experience = ( @drug_free_experience + @safety_council_experience + @industry_specific_experience + @transitional_work_experience + @go_green_experience + @lapse_free_experience)
      @max_savings_em_cap = @em_cap_eligibility == 'Yes' ? (@safety_council_em_cap + @industry_specific_em_cap + @transitional_work_em_cap + @go_green_em_cap + @lapse_free_em_cap) : nil
      # @max_savings_ocp = (@safety_council_ocp + @industry_specific_ocp + @transitional_work_ocp + @go_green_ocp + @lapse_free_ocp)
      @max_savings_group_rating = (@group_rating_eligibility == 'Yes' ? ( @drug_free_group_rating + @safety_council_group_rating + @industry_specific_group_rating + @transitional_work_group_rating + @go_green_group_rating + @lapse_free_group_rating ) : nil)
      @max_savings_group_retro = (@group_retro_eligibility == 'Yes' ? ( @safety_council_group_retro + @go_green_group_retro ) : nil)
      # @max_savings_individual_retro = (  @safety_council_individual_retro + @go_green_individual_retro)
      # @max_savings_mm_select =

    ###### Lowest Possible Costs
      @lowest_costs_experience = @experience_total_cost -  @max_savings_experience
      @lowest_costs_em_cap = @em_cap_eligibility == 'Yes' ? (@em_cap_total_cost -  @max_savings_em_cap) : nil
      @lowest_costs_group_rating = @group_rating_eligibility == 'Yes' ? (@group_rating_total_cost -  @max_savings_group_rating) : nil
      @lowest_costs_group_retro = @group_retro_eligibility == 'Yes' ? (@group_retro_total_cost -  @max_savings_group_retro) : nil
      # @lowest_costs_individual_retro =
      # @lowest_costs_mm_select =



    # Max Save vs Exp
      @max_save_experience = @experience_projected_premium - @lowest_costs_experience
      @max_save_em_cap = (@em_cap_eligibility == 'Yes' ? (@em_cap_projected_premium -  @lowest_costs_em_cap) : nil)
      @max_save_group_rating = (@group_rating_eligibility == 'Yes' ? (@group_rating_projected_premium -  @lowest_costs_group_rating) : nil)
      @max_save_group_retro = (@group_retro_eligibility == 'Yes' ? (@group_retro_projected_premium -  @lowest_costs_group_retro) : nil)
      # @lowest_costs_individual_retro =
      # @lowest_costs_mm_select =



    @data = [[ "Drug Free Safety","#{ round(@drug_free_experience,0) }","","","#{round(@drug_free_group_rating, 0)}","","",""]]
    @data += [[ "Safety Council","#{round(@safety_council_experience,0)}","#{ round(@safety_council_em_cap, 0)}","","#{ round(@safety_council_group_rating, 0)}","#{ round(@safety_council_group_retro,0)}"," ",""]]
    @data += [[ "Industry Specific","#{ round(@industry_specific_experience, 0) }","#{ round(@industry_specific_em_cap, 0)}","","#{ round(@industry_specific_group_rating, 0)}","","",""]]
    @data += [[ "Transitional Work","#{ round(@transitional_work_experience, 0)}","#{ round(@transitional_work_em_cap, 0)}","","#{ round(@transitional_work_group_rating, 0)}","","",""]]
    @data += [[ "Go Green","#{ round(@go_green_experience, 0)}","#{ round(@go_green_em_cap, 0)}","","#{ round(@go_green_group_rating, 0) }","#{ round(@go_green_group_retro, 0) }","",""]]
    @data += [[ "Lapse Free","#{ round(@lapse_free_experience, 0)}","#{ round(@lapse_free_em_cap, 0)}","","#{round(@lapse_free_group_rating, 0)}","","",""]]
    @data += [[ "Max Add'l Savings","#{round(@max_savings_experience, 0)}","#{round(@max_savings_em_cap, 0)}","","#{round(@max_savings_group_rating, 0)}","#{ round(@max_savings_group_retro, 0)}","",""]]
    @data += [[ "Low Poss. Costs","#{ round(@lowest_costs_experience, 0)}","#{ round(@lowest_costs_em_cap, 0)}","","#{ round(@lowest_costs_group_rating, 0)}","#{round(@lowest_costs_group_retro, 0)}","",""]]
    @data += [[ "Max Save vs Exp","#{ round(@max_save_experience, 0)}","#{round(@max_save_em_cap,0)}","","#{round(@max_save_group_rating, 0)}","#{round(@max_save_group_retro, 0)}","",""]]


  end

  def descriptions
    move_down 5
    text "[1] Program Options and costs estimates are based on current eligibility and current and historical data and is not guaranteed. See detail sheets for program parameters. Retro and Deductible Programs savings can vary based on parameters selected.", size: 7
    move_down 3
    text "[2] Additional BWC Discounts often include costs of setting up the program and full savings on certain programs will be difficult to acheive.", size: 7
  end

end
