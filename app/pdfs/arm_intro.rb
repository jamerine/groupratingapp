class ArmIntro < PdfReport
  def initialize(quote=[],account=[],policy_calculation=[],view)
    super()
    @quote = quote
    @account = account
    @policy_calculation = policy_calculation
    @view = view

    @group_fees =
      if @account.group_fees.nil?
        0
      else
        @account.group_fees
      end
   @current_date = DateTime.now.to_date

   intro_page

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

end
