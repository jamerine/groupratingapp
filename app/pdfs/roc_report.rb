class RocReport < PdfReport

  def initialize(account=[],policy_calculation=[],group_rating=[],view)
    super()
    @account = account
    @policy_calculation = policy_calculation
    @policy_program_history = @policy_calculation.policy_program_histories.order(:policy_year).last
    @group_rating = group_rating
    @view = view


    @account = Account.includes(policy_calculation: [:claim_calculations, :policy_coverage_status_histories, :policy_program_histories, { manual_class_calculations: :payroll_calculations }]).find(@account.id)

    @current_policy_program = @account.policy_calculation.policy_program_histories.order(reporting_period_start_date: :desc).first

    header
    stroke_horizontal_rule
    stroke_axis
    estimated_current_period_premium

    workers_comp_program_options


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
      text "Policy#: #{ @account.policy_number_entered }", size: 12, style: :bold, align: :center
      move_down 2
      text "#{ @account.street_address}, #{ @account.city}, #{ @account.state}, #{ @account.zip_code}", size: 12, align: :center
      move_down 2
      text "As of #{@group_rating.updated_at.in_time_zone("America/New_York").strftime("%m/%d/%y")} with #{ @group_rating.current_payroll_period_upper_date.in_time_zone("America/New_York").strftime("%Y").to_i + 1 } Rates", size: 12, align: :center
      move_down 2
      text "Rating Option Comparison Report", size: 12, align: :center, style: :bold_italic
      transparent(0) { stroke_bounds }
      # stroke_bounds
    end
  end

  def estimated_current_period_premium

    bounding_box([100, cursor], :width => 350) do
      move_down 3
      text "Estimated Current Period Premium", size: 12, style: :bold, align: :center
      horizontal_line 0, 350, :at => cursor
      bounding_box([0, cursor], :width => 350) do
        table ([[ "Rating Plan: #{@current_policy_program.group_type }" , "Current EM: #{ @current_policy_program.experience_modifier_rate }", "OCP: #{ @current_policy_program.ocp_participation_indicator }", "EM CAP: #{ @current_policy_program.em_cap_participation_indicator }" ], [ "DFSP: #{@current_policy_program.drug_free_program_participation_indicator }" , "Ded Pct: #{ @current_policy_program.deductible_discount_percentage }", "ISSP: #{ @current_policy_program.issp_participation_indicator }", "TWBNS: #{ @current_policy_program.twbns_participation_indicator }" ]]), :column_widths => {0 => 87, 1 => 87, 2 => 87, 3 => 87 } do
          self.position = :center
          row(0..-1).borders = []
          self.cell_style = { size: 9 }
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
          row(1..-1).borders = [:top, :bottom]
          row(0..-1).align = :center
          row(-1).row_colors = ["FFFFFF"]
          self.cell_style = { size: 10 }
        end
        table current_policy_data_total, :column_widths => {0 => 87, 1 => 87, 2 => 87, 3 => 87 } do
          self.position = :center
          row(0).font_style = :bold
          row(0).overflow = :shring_to_fit
          row(0).align = :center
          row(0).borders = []
          row(0..-1).align = :center
          self.cell_style = { size: 11 }
        end
        stroke_bounds
      end
      stroke_bounds
    end

  end

  def current_policy_data
    @data = [["Manual", "Est Payroll", "Rate", "Est Premium" ]]
    @data += @policy_calculation.manual_class_calculations.map { |e| [round(e.manual_number,0), round(e.manual_class_current_estimated_payroll,0), 'rate?', 'P/R * rate?'   ] }
  end

  def current_policy_data_total
    @data = [["Totals", "#{ round(@policy_calculation.policy_total_current_payroll,0) }", "Rate", "Est Premium" ]]
  end

  def workers_comp_program_options
    move_down 15
    text "2017 Workers' Compensation Program Options [1]", size: 12, style: :bold, align: :center
    move_down 15

    table workers_comp_program_options_data, :column_widths => {0 => 100, 1 => 63, 2 => 62, 3 => 62, 4 => 62, 5 => 62, 6 => 62, 7 => 62 } do
      self.position = :center
      row(0).font_style = :bold

      row(0).align = :center
      row(0).borders = [:bottom]
      row(0..-1).align = :center
      row(-2..-1).font_style = :bold
      self.cell_style = { size: 10 }
    end
  end

  def workers_comp_program_options_data
    # Experience Rated
      @experience_eligibility = 'Yes'
      @experience_projected_premium = @policy_calculation.policy_total_individual_premium
      @experience_costs = 0
      @experience_maximum_risk = 0
      @experience_total_cost = @experience_projected_premium - @experience_costs
      @experience_savings = @experience_projected_premium - @experience_total_cost

    # EM Cap

    # OCP

    # Group Rating
      @group_rating_eligibility = (@account.group_rating_qualification == 'accept' ? 'Yes' : 'No')
      @group_rating_projected_premium = @account.group_premium
      @group_rating_costs = 0
      @group_rating_maximum_risk = 0
      @group_rating_total_cost = @group_rating_projected_premium - @group_rating_costs
      @group_rating_savings = @experience_projected_premium - @group_rating_total_cost

    # Group Retro
      @group_retro_eligibility = (@account.group_retro_qualification == 'accept' ? 'Yes' : 'No')
      @group_retro_projected_premium = @account.group_premium
      @group_retro_costs = 0
      @group_retro_maximum_risk = 0
      @group_retro_total_cost = @group_retro_projected_premium - @group_retro_costs
      @group_retro_savings = @experience_projected_premium - @group_rating_total_cost


    @data = [[" ","Experience Rated", "EM Cap", "One Claim Program", " #{ @account.group_rating_tier } Group", "Group Retro", "Individual Retro", "Minute Men Select" ]]
    @data += [[ "Eligibility","#{@experience_eligibility}"," "," ","#{@group_rating_eligibility}","#{@group_retro_eligibility}"," "," "]]
    @data += [[ "Projected Premium","#{ round(@experience_projected_premium, 0) }",""," ","#{round(@group_rating_projected_premium, 0)}"," "," "," "]]
    @data += [[ "Est Cost/-Credits","#{ round(@experience_costs,0) }"," "," ","#{ round(@group_rating_costs,0) }"," "," "," "]]
    @data += [[ "Maximum Risk","#{ round(@experience_maximum_risk,0) }"," "," ","#{ round(@group_rating_maximum_risk,0) }"," "," "," "]]
    @data += [[ "Total Est Cost","#{ round(@experience_total_cost,0) }"," "," ","#{ round(@group_rating_total_cost,0) }"," "," "," "]]
    @data += [[ "Est Savings/-Loss","#{ round(@experience_savings,0) }"," "," ","#{ round(@group_rating_savings,0) }"," "," "," "]]
  end


end
