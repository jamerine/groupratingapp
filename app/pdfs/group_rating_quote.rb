class GroupRatingQuote < PdfReport

  TABLE_HEADERS =

  def initialize(quote=[],account=[],policy_calculation=[],view)
    super()
    @quote = quote
    @account = account
    @policy_calculation = policy_calculation
    @view = view

    @group_fees =
      if @quote.fees.nil?
        0
      else
        @quote.fees
      end
   @current_date = DateTime.now.to_date

    quote_analysis

  end

  private



  def quote_analysis
    #Header comes from pdf_report template
    header 'Group Rate Quote Analysis'
    move_down 50
    stroke_horizontal_rule
    move_down 25
    text "#{@account.name}", size: 20, style: :bold, align: :center
    text "Policy Number: #{@account.policy_number_entered}", size: 12,  align: :center
    move_down 25
    stroke_horizontal_rule
    move_down 25
    display_data_table
    move_down 50
    text "Projected Savings: #{price(@account.group_savings)}", align: :right, size: 12, style: :bold
    move_down 10
    text "Enrollment Fee: #{price(@group_fees)}", align: :right, size: 12, style: :bold
    move_down 10
    text "Net Savings: #{ price(@account.group_savings - @group_fees) }", align: :right, size: 16, style: :bold
    # bounding_box([200, cursor], :width => 325, :height => 25) do
    #   stroke_bounds
    # end
  end


  def display_data_table
    if table_data.empty?
      text "No Information Found"
    else
      text "Individual TM%: #{percent(@policy_calculation.policy_individual_total_modifier)}     Group TM%: #{percent(@account.group_rating_tier)}", size: 12, align: :center
      move_down 10
      table table_data do
        self.position = :center
        row(0).font_style = :bold
        row(0).align = :center
        self.row_colors = TABLE_ROW_COLORS
        self.cell_style = {:min_font_size => 9}
        self.header = true
        row(-1).font_style = :bold
      end
    end
  end

  def table_data
    @data = [["Manual Class", "Base Rate", "Estimated Payroll", "Ind. Rate", "Ind. Premium", "Adj. Premium", "Group Rate", "Group Premium"]]
    @data +=  @account.policy_calculation.manual_class_calculations.map { |e| [e.manual_number, e.manual_class_base_rate, price(e.manual_class_current_estimated_payroll), round(e.manual_class_individual_total_rate), price(e.manual_class_estimated_individual_premium), "", round(e.manual_class_group_total_rate), price(e.manual_class_estimated_group_premium)] }
    @data += [["Totals","","#{price(@policy_calculation.policy_total_current_payroll)}","","#{price(@policy_calculation.policy_total_individual_premium)}", "#{price(@policy_calculation.policy_adjusted_standard_premium)}","","#{price(@account.group_premium)}"]]
  end

  def price(num)
    @view.number_to_currency(num)
  end

  def round(num)
    @view.number_with_precision(num, precision: 4)
  end

  def percent(num)
    num = num * 100
    @view.number_to_percentage(num, precision: 0)
  end

end
