class U153 < PdfReport
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
   u_153

  end

  private

  def u_153
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 250, height: 50) do
      image "#{Rails.root}/app/assets/images/ohio7.png", height: 50
    end
    bounding_box([250, current_cursor], :width => 300, height: 50) do
      text "Employer Statement for", style: :bold, align: :right, size: 12
      text "Group-Retrospective-Rating Program", style: :bold, align: :right, size: 12
    end
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 375, :height => 85) do
      text "Instructions:", style: :bold, align: :left, size: 8
      text "• Please print or type", align: :left, size: 8, inline_format: true
      text "• Please return completed statement to the attention of the sponsoring organization you are joining.", align: :left, size: 8
      text "• The Group Administrator’s third party administrator will submit your original U-153 to:", align: :left, size: 8
      text "Ohio Bureau of Workers’ Compensation", align: :left, size: 8, indent_paragraphs: 15
      text "Attn: employer programs unit", align: :left, size: 8, indent_paragraphs: 15
      text "30 W. Spring St., 22nd floor", align: :left, size: 8, indent_paragraphs: 15
      text "Columbus, OH 43215-2256", align: :left, size: 8, indent_paragraphs: 15
      text "• If you have any group-experience-rating questions calls BWC at 614-466-6773", align: :left, size: 8
     transparent(0) { stroke_bounds }
    end
    text "NOTE: The employer programs unit group underwriters must review and approve this application before it becomes effective.", style: :bold, size: 8, align: :center
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 275, :height => 25) do
      text "Employer Name", style: :bold, size: 8
      text "#{@account.name.titleize}", :indent_paragraphs => 10, size: 10
     stroke_bounds
    end
    bounding_box([275, current_cursor], :width => 180, :height => 25) do
      text "Telephone Number", style: :bold, size: 8
      text "#{@account.business_phone_number}#{@account&.business_phone_extension.present? ? " Ext: #{@account&.business_phone_extension}" : ''}", :indent_paragraphs => 10, size: 10
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
    table([["Group-Retrospective-Rating Enrollment"]], :width => 540,  :row_colors => ["EFEFEF"]) do
      row(0).font_style = :bold
      row(0).align = :center
      self.cell_style = {:size => 14}
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 540, :height => 305) do
      move_down 5
      indent(5) do
        text "I agree to comply with the Ohio Bureau of Workers’ Compensation Group-Retrospective-Rating Program rules (Ohio Administrative Rule 4123-17-73). I understand that my participation in the program is contingent on such compliance.", size: 9
        move_down 10
        text "This form supersedes any previously executed U-153.", size: 9
        move_down 10
        text "I understand that only a BWC Group-Retrospective-Rating Program certified sponsor can offer membership into the program. I also understand that if the sponsoring organization listed below, is not certified, this application is null and void.", size: 9
        move_down 10
        text "I am a member of the <b><u>NORTHEAST OHIO SAFETY COUNCIL</u></b> sponsoring organization or a certified affiliate organization and would like to be included in that Group-Retrospective-Rating Program that they sponsor for the policy year beginning <b><u>#{@account.representative.quote_year_lower_date.strftime("%B %e, %Y")}</u></b>. I understand that the employer roster submitted by the group will be the final, official determination of the group in which I will or will not participate. Submission of their form does not guarantee participation.", size: 9, inline_format: true
        move_down 10
        text "I understand that the organization’s representative <b><u>Trident Risk Advisors</b></u> (currently, as determined by the sponsoring organization) is the only representative I may have in risk-related matters while I remain a member of the group.  I also understand that the representative for the group-experience-rating program will continue as my individual representative in the event that I no longer participate in the group rating plan.  At the time, I am no longer a member of the program, I understand that I must file a Permanent Authorization (AC-2) to cancel or change individual representation. ", size: 9, inline_format: true
        move_down 10
        text "I understand that a new U-153 shall be filed each policy year I participate in the group-retrospective-rating plan.", size: 9
        move_down 10
        text "I am associated with the sponsoring organization or a certified affiliate sponsoring organization  <u>  X  </u> Yes <u>     </u> NO", size: 9, inline_format: true
        move_down 5
        current_cursor = cursor
        bounding_box([50 , current_cursor], :width => 130, :height => 25) do
          text "NEOSC", indent_paragraphs: 45
          stroke_horizontal_rule
          move_down 3
          text "Name of sponsor or affiliate sponsor", size: 8
        end
        bounding_box([300 , current_cursor], :width => 200, :height => 25) do
          text "#{@account.policy_number_entered}-0", indent_paragraphs: 75
          stroke_horizontal_rule
          move_down 3
          text "Sponsor or affiliate sponsor policy number", size: 8, indent_paragraphs: 20
        end
      end
      stroke_horizontal_rule
      move_down 5
      indent(5) do
        text "Note: For injuries that occur during the period an employer is enrolled in the Group-Retrospective-Rating Program, employers may not utilize or participate in the Deductible Program, Group Rating, Retrospective Rating, Safety Council Discount Program, $15,000 Medical-Only Program, or the Drug-Free Safety Program.", size: 8
      end
      stroke_bounds

    end
    table([["Certification"]], :width => 540,  :row_colors => ["EFEFEF"]) do
      row(0).font_style = :bold
      row(0).align = :center
      self.cell_style = {:size => 10}
      self.cell_style = {:height => 20}
    end
    current_cursor = cursor
    bounding_box([0 , current_cursor], :width => 540, :height => 148) do
      move_down 15
      text "_<u>                                                        </u> certifies that he/she is the <u>                                                        </u> of", inline_format: true, indent_paragraphs: 10
      text "(Officer Name)                                                                                 (Title)", indent_paragraphs: 65
      move_down 10
      text "_<u>                                                                             </u>, the employer referred to above, and that all the information is", inline_format: true, indent_paragraphs: 10
      text "(Employer Name)", indent_paragraphs: 65
      move_down 10
      text "true to the best of his/her knowledge, information, and belief, after careful investigation.", indent_paragraphs: 10
      move_down 10
      bounding_box([50 , 35], :width => 130, :height => 23) do
        move_down 10
        stroke_horizontal_rule
        move_down 3
        text "(OFFICER SIGNATURE)", size: 8, align: :center
      end
      bounding_box([350 , 35], :width => 130, :height => 23) do
        move_down 10
        stroke_horizontal_rule
        move_down 3
        text "(DATE)", size: 8, align: :center
      end
      stroke_bounds
    end
    move_down 3
    text "BWC-7659 (Rev. 12/15/2010)", size: 8
    text "U-153", size: 8, style: :bold



  end

end
