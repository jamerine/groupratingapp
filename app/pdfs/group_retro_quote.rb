class GroupRetroQuote < PdfReport


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
    header "Group Rate Quote Analysis"
    move_down 15
    text "<b>Congratulations, #{@account.name}!</b>", size: 11, inline_format: true
    move_down 15
    text "#{@account.representative.company_name} and the North East Ohio Safety Council have selectively chosen your company to become a member and receive a premium refund through our Group Retro program for the #{@quote.quote_year} rate year. Unlike the prospective Group Rating program, premium refunds are paid based on the performance of the group. Members receive a dependable and aggressive cost control strategy upon enrollment. All members will be required to meet the program safety requirements. <i>(i.e.: salary continuation and/or transitional work for a minimum of 8 weeks, IME requirements, aggressive settlements, handicap reimbursement and subrogation)</i> These safety requirements along with #{@account.representative.company_name.upcase}’s superior claims management are why our program is the best for maximizing refunds and limiting any risks.", size: 8, inline_format: true
    move_down 15
    text "Cost Control Strategies and requirements for membership:", size: 10
    move_down 5
        text "\u2022 All Industrial Commission hearings will have legal counsel representation on behalf of the employer", :indent_paragraphs => 3, size: 8
        move_down 3
        text "\u2022 Members are required to be of adequate size and to complete a safety review, results may require further enhancements", :indent_paragraphs => 3, size: 8
        move_down 3
        text "\u2022 Salary continuation and/or transitional work for a minimum of 8 weeks", :indent_paragraphs => 3, size: 8
        move_down 3
        text "\u2022 Aggressive pursuit of Vocational Rehab", :indent_paragraphs => 3, size: 8

    move_down 15
    # stroke_horizontal_rule
    # text "#{@quote.quote_year} Group Retro Quote Analysis", style: :bold, size: 12
    # stroke_horizontal_rule

    bounding_box([0, cursor], width: 550) do
      move_down 3
      text "#{@quote.quote_year} Group Retro Quote Analysis", style: :bold, size: 12, :indent_paragraphs => 2
      stroke_bounds
    end
    move_down 5
    text "**REFUNDS MAY VARY BASED ON THE GROUP PERFORMANCE.**", style: :bold, align: :center, size: 8
    text "#{@account.representative.company_name.upcase}", style: :bold, align: :center, size: 8
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 300) do
      display_data_table
    end
    bounding_box([325, current_cursor], :width => 225) do
      move_down 25
      text "All applications are subject to Ohio BWC review and may be rejected for:", size: 8
      # text "1.	Lapse in coverage of greater than 40 days within twelve months.", :indent_paragraphs => 5, size: 8
      table([
        ["1.", "Lapse coverage greater than 40 days within 12 months"], ["2.", "Balance due for more than 45 days"], ["3.", "Dual applications"], ["4.", "Non-homogeneous industry type"], ["5.", "Incomplete application"]]) do
          cells.borders = []
          self.cell_style = { size: 8 }
          self.cell_style = { :height => 17 }
        end
    end
    move_down 25
    text "To clarify the timeline for group retro premium refunds, the Ohio BWC and #{@account.representative.company_name} operate under the following timeframe.", size: 8
    move_down 5
    text "\u2022 Group Retro enrollment plan year begins #{@quote.quote_year_lower_date.try(:strftime, "%m/%d/%y")} and ends #{@quote.quote_year_upper_date.try(:strftime, "%m/%d/%y")}.", size: 8, :indent_paragraphs => 10
    text "\u2022 Group Retro partial premium refunds will be refunded in November #{@quote.quote_year + 2}, November #{@quote.quote_year + 3} with a final rebate in November #{@quote.quote_year + 4}.", size: 8, :indent_paragraphs => 10
    move_down 15
    text "Group Retro is not compatible with the following programs:", size: 8
    text "\u2022 Drug-free safety", size: 8, :indent_paragraphs => 40
    text "\u2022 $15,000 medical only", size: 8, :indent_paragraphs => 40
    text "\u2022 Group-experience rating", size: 8, :indent_paragraphs => 40
    text "\u2022 Large or small deductible", size: 8, :indent_paragraphs => 40
    text "\u2022 OCP", size: 8, :indent_paragraphs => 40
    text "\u2022 Retrospective Rating", size: 8, :indent_paragraphs => 40
    text "\u2022 Safety Council - Performance", size: 8, :indent_paragraphs => 40
    move_down 15
    text "If you have any questions regarding the Group Retro Program and the above quote, please do not hesitate to call one of our associates at #{@account.representative.toll_free_number}.", size: 8
    move_down 15
    text "As noted above there is a potential maximum assessment for your company in this program that could increase your individual premium. However to ensure program success and premium savings the sponsor requires members to fulfill the outlined cost control methods working with #{@account.representative.company_name}: safety program, salary continuation, transitional duty program, lump sum settlement and onsite safety visits. Statements made to the employer regarding the Group Retro Program and potential refunds are not guarantees, but projections based upon information available from BWC at the time of review. This offer may be withdrawn or revised based upon participation levels.", style: :bold_italic, size: 9


    # move_down 25
    # text "#{@account.name}", size: 20, style: :bold, align: :center
    # text "Policy Number: #{@account.policy_number_entered}", size: 12,  align: :center
    # move_down 25
    # stroke_horizontal_rule
    # move_down 25
    # # display_data_table
    # move_down 50
    # text "Projected Savings: #{price(@account.group_savings)}", align: :right, size: 12, style: :bold
    # move_down 10
    # text "Enrollment Fee: #{price(@group_fees)}", align: :right, size: 12, style: :bold
    # move_down 10
    # text "Net Savings: #{ price(@account.group_savings - @group_fees) }", align: :right, size: 16, style: :bold
    # bounding_box([200, cursor], :width => 325, :height => 25) do
    #   stroke_bounds
    # end
  end


  def display_data_table
    if table_data.empty?
      text "No Information Found"
    else
      table table_data, :column_widths => {0 => 225, 1 => 75 } do
        row(0).font_style = :bold
        self.cell_style = { size: 8 }
        self.header = true
        row(0).column(0).background_color = "aaa9a9"
        row(0).column(1).background_color = "aaa9a9"
      end
    end
  end

  def table_data
    @data = [["Illustration", ""]]
    @data += [[ "Projected Premium w/o Assessments","#{ price(@policy_calculation.policy_total_standard_premium) }"]]
    @data += [[ "Premium Refund %","#{ percent(@account.group_retro_tier) }"]]
    @data += [[ "Premium Refund Estimation","#{ price(@account.group_retro_savings) }"]]
    @data += [[ "Premium Assessment Cap %","N/A"]]
    @data += [[ "Premium Assessment Cap Value","N/A"]]
    @data += [[ "ARM / BAYLOR Enrollment & Administrative Fee","#{ price(@group_fees) }"]]
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
