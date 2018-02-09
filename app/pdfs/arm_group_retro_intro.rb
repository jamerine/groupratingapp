class ArmGroupRetroIntro < PdfReport
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

  end

  private

  def intro_page
    header
    move_down 20
    current_cursor = cursor
    bounding_box([50, (current_cursor - 10) ], :width => 100, :height => 50) do
      text "#{@current_date.strftime("%B %e, %Y")}", style: :bold
     transparent(0) { stroke_bounds }
    end

    bounding_box([200, current_cursor], :width => 200, :height => 50) do
      text "REFUND ESTIMATE FOR #{@account.representative.quote_year}:", style: :bold
      move_down 5
      text "TOTAL PREMIUM REFUND ESTIMATE: ", style: :bold
     transparent(0) { stroke_bounds }
    end
    bounding_box([400, current_cursor], :width => 150, :height => 50) do
      text "#{percent(@account.group_retro_tier)}", style: :bold
      move_down 5
      text "#{price(@account.group_retro_savings - @group_fees)}", style: :bold
     transparent(0) { stroke_bounds }
    end

    text "#{@account.name.titleize}"
    text "#{@account.street_address.titleize} #{@account.street_address_2}"
    text "#{@account.city.titleize}, #{@account.state.upcase} #{@account.zip_code}"
    move_down 25

    text "Congratulations!  <b>#{@account.name}</b> is invited to participate in the Northeast Ohio Safety Council's <b><u>#{@quote.quote_year} Group Retrospective Program</u></b>. Group Retrospective employers pay their premium to the Ohio BWC and receive a refund based upon claims performance and management for the retrospective year. Retro is a performance based program that the BWC enacted, which carries more benefit than risk potential. Our program includes conservative underwriting and the best program management necessary to maximize your refund. The program does carry a risk of a premium increase. <b><i>Therefore conservative underwriting and superior claims management reduces the liability of members paying additional premiums. Your worst case scenario is capped at 15% of premium.</b></i>", size: 11, inline_format: true
    move_down 15
    text "<b>**REFUNDS MAY VARY FROM THEORETICAL MAX OF OVER 70% AND ARE NOT GUARANTEED.**</b>", size: 11, inline_format: true
    text "<b>#{@account.representative.abbreviated_name} HAS ENCLOSED A CONSERVATIVE ILLUSTRATION OF YOUR POSSIBLE SAVINGS.</b>", size: 11, inline_format: true
    move_down 15
    text "Please find the enclosed #{@quote.quote_year} rate year Group Retro Quote.", size: 11
    move_down 15
    text "Enrollment is easy - Simply complete and return the following forms to #{@account.representative.abbreviated_name} in the provided reply envelope:", size: 11
    move_down 15

    text "1.    FORM U-153, EMPLOYER STATEMENT FOR GROUP RETRO RATING PROGRAM", size: 9
    text "2.    FORM AC-2, PERMANENT AUTHORIZATION (please include your email to receive important reminders and updates)", size: 9
    text "3.    GROUP RETRO AGREEMENT", size: 9
    text "4.    Fees* of #{ price(@group_fees) } –payable to #{@account.representative.abbreviated_name}  *fees are all inclusive, including your association dues. ", size: 9

    move_down 15
    text "Although no program can guarantee savings or refunds, our goal is to provide you with the best service so that you can be assured that you and all group participants are doing everything possible to get the best refund. The Group Retro Deadline is January 30, #{@quote.quote_year} for sponsors and Third Party Administrators to finalize the group rosters; <b><i>therefore we ask that you respond no later than December 31st, #{@quote.quote_year - 1}.</b></i>", inline_format: true
    move_down 15
    if [2, 9,10,16].include? @account.representative.id
      text "Thank you for allowing us to prepare the following quote. If you have any questions, please contact us at (MMHR PHONE NUMBER)."
    else
      text "Thank you for allowing us to prepare the following quote.  If you have any questions regarding the program/quote, Group Retro, other workers’ compensation issues or Unemployment Services, please do not hesitate to contact one of our associates at (614) 219-1290."
    end
    move_down 15
    text "Sincerely,"
    move_down 15
    if [2,9,10,16].include? @account.representative.id
      text "Signature"
      text "MMHR President"
      text "President"
    else
      image "#{Rails.root}/app/assets/images/Doug's signature.jpg", height: 50
      text "#{@account.representative.president_first_name} #{@account.representative.president_last_name}"
      text "President"
    end

    bounding_box([0, 25], :width => 550, :height => 50) do
      if [2].include? @account.representative.id
        text "COSE FOOTER", align: :center, color: "333333"
        text "COSE FOOTER", align: :center, color: "333333"
        text "COSE FOOTER", align: :center, color: "333333"
        text "COSE FOOTER", align: :center, color: "333333"
      elsif [9,10,16].include? @account.representative.id
        text "MMHR FOOTER", align: :center, color: "333333"
        text "MMHR FOOTER", align: :center, color: "333333"
        text "MMHR FOOTER", align: :center, color: "333333"
        text "MMHR FOOTER", align: :center, color: "333333"
      elsif [17].include? @account.representative.id
        text "TARTAN FOOTER", align: :center, color: "333333"
        text "TARTAN FOOTER", align: :center, color: "333333"
        text "TARTAN FOOTER", align: :center, color: "333333"
        text "TARTAN FOOTER", align: :center, color: "333333"
      else
        text "Cleveland/Columbus Offices", align: :center, color: "333333"
        text "Telephone (888) 235-8051  |  Fax (614) 219-1292", align: :center, color: "333333"
        text "Workers' Compensation & Unemployment Compensation Specialists", align: :center, color: "333333"
        text "<u>www.alternativeriskmgmt.com</u>", align: :center, color: "333333", inline_format: true
      end
     transparent(0) { stroke_bounds }
    end
  end

  def percent(num)
    num = num * 100
    @view.number_to_percentage(num, precision: 0)
  end

end
