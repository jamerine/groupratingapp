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

    intro_page
    start_new_page
    quote_analysis
    start_new_page
    ac_26

  end

  private

  def intro_page
    header
    move_down 20
    current_cursor = cursor
    bounding_box([50, (current_cursor - 10) ], :width => 100, :height => 65) do
      text "#{@current_date.strftime("%B %e, %Y")}", style: :bold
     transparent(0) { stroke_bounds }
    end

    bounding_box([250, current_cursor], :width => 170, :height => 75) do
      text "2017 Projected Discount:", style: :bold
      move_down 5
      text "Total Premium Savings Estimate: ", style: :bold
     transparent(0) { stroke_bounds }
    end
    bounding_box([425, current_cursor], :width => 75, :height => 75) do
      text "#{percent(@account.group_rating_tier)}", style: :bold
      move_down 5
      text "#{price(@account.group_savings - @group_fees)}", style: :bold
     transparent(0) { stroke_bounds }
    end

    text "#{@account.name.titleize}"
    text "#{@account.street_address.titleize} #{@account.street_address_2}"
    text "#{@account.city.titleize}, #{@account.state.upcase} #{@account.zip_code}"
    move_down 25

    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 25, :height => 25) do
      text "RE:", style: :bold, size: 10
     transparent(0) { stroke_bounds }
    end
    bounding_box([25, current_cursor], :width => 250, :height => 25) do
      text "OHIO WORKERS’ COMPENSATION GROUP RATING", size: 10
      text "IMMEDIATE RESPONSE REQUIRED", style: :bold, size: 10
     transparent(0) { stroke_bounds }
    end

    move_down 15
    text "Congratulations!  <b>#{@account.name}</b> is invited to participate in ARM’s 2017 <b><u>Group Rating Program</u></b>.  We have designed a program that includes the best representation, claims administration, and group premium discounts for Ohio employers through the Northeast Ohio Safety Council.", size: 11, inline_format: true
    move_down 15
    text "Please find the enclosed 2017 group quote and premium projection.  We stand behind our estimations for their accuracy.", size: 11
    move_down 15
    text "Enrollment is simple - please complete and return the enclosed forms (listed below) with a copy of the invoice and your check for the management fee by November 1, 2016:", size: 11
    move_down 15

    text "1.    FROM AC-26, EMPLOYER STATEMENT FOR GROUP RATING", size: 9
    text "2.    FORM AC-2, PERMANENT AUTHORIZATION (please include your email to receive important reminders and updates)", size: 9
    text "3.    GROUP RATING QUESTIONAIRE", size: 9
    text "4.    Fees* of #{ price(@quote.fees) } –payable to #{@account.representative.abbreviated_name}  *fees are all- inclusive ", size: 9

    move_down 15
    text "Our goal is to provide you with the best service at the most cost effective rates possible. If you receive a better offer, we will <b>match your best verifiable Group Rating Proposal.</b>", inline_format: true
    move_down 15
    if [2, 9,10,16].include? @account.representative.id
      text "Thank you for allowing us to prepare the following quote. If you have any questions, please contact us at (MMHR PHONE NUMBER)."
    else
      text "Thank you for allowing us to prepare the following quote. If you have any questions, please contact us at (614) 219-1290."
    end
    move_down 15
    text "Sincerely,"
    move_down 15
    text "Signature"
    if [2,9,10,16].include? @account.representative.id
      text "MMHR President"
      text "President"
    else
      text "Doug Maag"
      text "President"
    end

    bounding_box([0, 50], :width => 550, :height => 50) do
      if [2,9,10,16].include? @account.representative.id
        text "MMHR FOOTER", align: :center, color: "333333"
        text "MMHR FOOTER", align: :center, color: "333333"
        text "MMHR FOOTER", align: :center, color: "333333"
        text "MMHR FOOTER", align: :center, color: "333333"
      else
        text "Cleveland/Columbus Offices", align: :center, color: "333333"
        text "Telephone (888) 235-8051  |  Fax (614) 219-1292", align: :center, color: "333333"
        text "Workers' Compensation & Unemployment Compensation Specialists", align: :center, color: "333333"
        text "<u>www.alternativeriskmgmt.com</u>", align: :center, color: "333333", inline_format: true
      end
     transparent(0) { stroke_bounds }
    end
  end

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
    text "Next Savings: #{ price(@account.group_savings - @group_fees) }", align: :right, size: 16, style: :bold
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
    @data = [["Manual Class", "Base Rate", "Estimated Payroll", "Ind. Rate", "Ind. Premium", "Group Rate", "Group Premium"]]
    @data +=  @account.policy_calculation.manual_class_calculations.map { |e| [e.manual_number, e.manual_class_base_rate, price(e.manual_class_current_estimated_payroll), round(e.manual_class_individual_total_rate),  price(e.manual_class_estimated_individual_premium), round(e.manual_class_group_total_rate), price(e.manual_class_estimated_group_premium)] }
    @data += [["Totals","","#{price(@policy_calculation.policy_total_current_payroll)}","","#{price(@policy_calculation.policy_total_individual_premium)}","","#{price(@account.group_premium)}"]]
  end

  def ac_26
    stroke_axis
    text "Employer Statement for", style: :bold, align: :right, size: 15
    text "Group-Experience-Rating Program", style: :bold, align: :right, size: 15
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 375, :height => 50) do
      text "Instructions:", style: :bold, align: :left, size: 10
      text "• Please print or type", align: :left, size: 8, inline_format: true
      text "• Please return complete statement to the attention of the sponsoring organization you are joining.", style: :bold, align: :left, size: 8
      text "• If you have any group-experience-rating questions calls BWC at 614-466-6773", align: :left, size: 8
     transparent(0) { stroke_bounds }
    end
    bounding_box([375, current_cursor], :width => 175, :height => 50) do
      move_down 5
      text "BWC USE ONLY", style: :bold, size: 12, align: :center
      stroke_horizontal_rule
      move_down 5
      text "Application effective with policy year beginning", style: :bold, size: 8, align: :center
     stroke_bounds
    end
    move_down 5
    text "NOTE: The employer programs unit group underwriters must review and approve this application before it becomes effective.", style: :bold, size: 8
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 275, :height => 25) do
      text "Employer Name", style: :bold, size: 8
      text "#{@account.name.titleize}", :indent_paragraphs => 10, size: 10
     stroke_bounds
    end
    bounding_box([275, current_cursor], :width => 180, :height => 25) do
      text "Telephone Number", style: :bold, size: 8
      text "#{@account.business_phone_number}", :indent_paragraphs => 10, size: 10
     stroke_bounds
    end
    bounding_box([455, current_cursor], :width => 85, :height => 25) do
      text "Risk Number", style: :bold, size: 8
      text "#{@account.policy_number_entered}-0", :indent_paragraphs => 10, size: 10
     stroke_bounds
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 275, :height => 25) do
      text "Address", style: :bold, size: 8
      text "#{@account.street_address.titleize} #{@account.street_address_2}", :indent_paragraphs => 10, size: 10
     stroke_bounds
    end
    bounding_box([275, current_cursor], :width => 90, :height => 25) do
      text "City", style: :bold, size: 8
      text "#{@account.city.titleize}", :indent_paragraphs => 10, size: 10
     stroke_bounds
    end
    bounding_box([365, current_cursor], :width => 90, :height => 25) do
      text "State", style: :bold, size: 8
      text "#{@account.state.upcase}", :indent_paragraphs => 10, size: 10
     stroke_bounds
    end
    bounding_box([455, current_cursor], :width => 85, :height => 25) do
      text "9 Digit Zip Code", style: :bold, size: 8
      text "#{@account.policy_calculation.mailing_zip_code}-#{@account.policy_calculation.mailing_zip_code_plus_4}", :indent_paragraphs => 10, size: 10
     stroke_bounds
    end
    current_cursor = cursor
    table([["Group-Experience-Rating Enrollment"]], :width => 540,  :row_colors => ["EFEFEF"]) do
      row(0).font_style = :bold
      row(0).align = :center
      self.cell_style = {:size => 14}
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 540, :height => 300) do
      move_down 5
      indent(5) do
        text "I agree to comply with BWC’s group-experience-rating program rules (Ohio Administrative Code Rules 4123-17-61 through 4123-17-68).  I understand that my participation in the group-experience-rating program is contingent on such compliance. This form supersedes any previously filed AC-26.", size: 10
        move_down 15
        text "I understand only a BWC group-experience-rating program certified sponsor can offer membership into the program.  I also understand if the sponsoring organization listed below is not certified this application is null and void.", size: 10
        move_down 15
        text "I am a member of the <b><u>NE Ohio Safety Council</u></b> sponsoring organization or a certified affiliate organization and would like to be included in the group named <b><u>NEOSC</u></b> is sponsors for the policy year beginning <b><u>July 1, 2017</u></b>.  In addition, I would like to be included in this group each succeeding policy year until rescinded by the timely filing within the preceding policy year of another AC-26 or until the group administrator does not include my company on the employer roster for group-experience-rating.  I understand the employer roster submitted by the group administrator will be the final, official determination of the group in which I will or will not participate.  Submission of this form does not guarantee participation.", size: 10, inline_format: true
        move_down 15
        text "I understand that the organization’s representative <b><u>Trident Risk Advisors</b></u> (currently, as determined by the sponsoring organization) is the only representative I may have in risk-related matters while I remain a member of the group.  I also understand that the representative for the group-experience-rating program will continue as my individual representative in the event that I no longer participate in the group rating plan.  At the time, I am no longer a member of the program, I understand that I must file a Permanent Authorization (AC-2) to cancel or change individual representation. ", size: 10, inline_format: true
        move_down 15
        text "I am associated with the sponsoring organization or a certified affiliate sponsoring organization  <u>  X  </u> Yes <u>     </u> NO", size: 10, inline_format: true
        move_down 10
        current_cursor = cursor
        bounding_box([50 , current_cursor], :width => 130, :height => 25) do
          text "NEOSC", indent_paragraphs: 45
          stroke_horizontal_rule
          move_down 3
          text "Name of sponsor or affiliate sponsor", size: 8
        end
        bounding_box([350 , current_cursor], :width => 130, :height => 25) do
          text "#{@account.policy_number_entered}-0", indent_paragraphs: 45
          stroke_horizontal_rule
          move_down 3
          text "Policy Number", size: 8, indent_paragraphs: 40
        end
      end
      stroke_bounds
    end
    table([["Certification"]], :width => 540,  :row_colors => ["EFEFEF"]) do
      row(0).font_style = :bold
      row(0).align = :center
      self.cell_style = {:size => 14}
    end
    current_cursor = cursor
    bounding_box([0 , current_cursor], :width => 540, :height => 175) do
      move_down 25

      text "_<u>                                                        </u> certifies that he/she is the <u>                                                        </u> of", inline_format: true, indent_paragraphs: 10
      text "(Officer Name)                                                                                 (Title)", indent_paragraphs: 65
      move_down 10
      text "_<u>                                                                             </u>, the employer referred to above, and that all the information is", inline_format: true, indent_paragraphs: 10
      text "(Employer Name)", indent_paragraphs: 65
      move_down 10
      text "true to the best of his/her knowledge, information, and belief, after careful investigation.", indent_paragraphs: 10
      move_down 10
      current_cursor = cursor
      bounding_box([50 , 50], :width => 130, :height => 25) do
        move_down 10
        stroke_horizontal_rule
        move_down 3
        text "(Officer Signature)", size: 8, align: :center
      end
      bounding_box([350 , 50], :width => 130, :height => 25) do
        move_down 10
        stroke_horizontal_rule
        move_down 3
        text "Date", size: 8, align: :center
      end
      stroke_bounds
    end
    move_down 3
    text "BWC-0526 (Rev. 12/21/2010) PC", size: 8
    text "AC-26", size: 8



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
