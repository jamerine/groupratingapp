class RocReport < PdfReport

  def initialize(account=[],policy_calculation=[],group_rating=[],view)
    super()
    @account = account
    @policy_calculation = policy_calculation
    @policy_program_history = @policy_calculation.policy_program_histories.order(:policy_year).last
    @group_rating = group_rating
    @view = view

    @account = Account.includes(policy_calculation: [:claim_calculations, :policy_coverage_status_histories, :policy_program_histories, { manual_class_calculations: :payroll_calculations }]).find(@account.id)

    header
    stroke_horizontal_rule

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

end
