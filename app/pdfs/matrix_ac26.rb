class MatrixAc26 < MatrixPdfReport
  def initialize(quote = [], account = [], policy_calculation = [], view)
    super()
    @quote              = quote
    @account            = account
    @policy_calculation = policy_calculation
    @view               = view
    @group_fees         =
      if @quote.fees.nil?
        0
      else
        @quote.fees
      end
    @current_date       = DateTime.now.to_date

    ac_26
  end

  private

  def ac_26
    current_cursor = cursor

    bounding_box([0, current_cursor + 15], :width => 175, :height => 50) do
      image "#{Rails.root}/app/assets/images/ohio7.png", height: 50
    end

    bounding_box([bounds.right - 250, current_cursor + 5], :width => 250, :height => 50) do
      text "Employer Statement for", style: :bold, align: :right, size: 15
      text "Group-Experience-Rating Program", style: :bold, align: :right, size: 15
    end

    current_cursor = cursor

    bounding_box([0, current_cursor], :width => 375, :height => 50) do
      text "Instructions:", style: :bold, align: :left, size: 10
      text "• Please print or type", align: :left, size: 8, inline_format: true
      text "• Please return complete statement to the attention of the sponsoring organization you are joining.", style: :bold, align: :left, size: 8
      text "• If you have any group-experience-rating questions calls BWC at 614-466-6773", align: :left, size: 8
      transparent(0) { stroke_bounds }
    end

    bounding_box([380, current_cursor], :width => 160, :height => 50) do
      move_down 5
      text "BWC USE ONLY", style: :bold, size: 12, align: :center
      stroke_horizontal_rule
      move_down 5
      text "Application effective with policy year beginning", style: :bold, size: 8, align: :center
      stroke_bounds
    end

    move_down 5
    text "<b>NOTE:</b> The employer programs unit group underwriters must review and approve this application before it becomes effective.", size: 8, align: :center, inline_format: true
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 275, :height => 25) do
      move_down 2.5
      text "Employer Name", style: :bold, size: 8, :indent_paragraphs => 5
      inline_text "#{@account.name.titleize}", :indent_paragraphs => 5
      stroke_bounds
    end

    bounding_box([275, current_cursor], :width => 180, :height => 25) do
      move_down 2.5
      text "Telephone Number", style: :bold, size: 8, :indent_paragraphs => 5
      inline_text "#{@account.business_phone_number}", :indent_paragraphs => 5
      stroke_bounds
    end

    bounding_box([455, current_cursor], :width => 85, :height => 25) do
      move_down 2.5
      text "Risk Number", style: :bold, size: 8, :indent_paragraphs => 5
      inline_text "#{@account.policy_number_entered}", :indent_paragraphs => 5
      stroke_bounds
    end

    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 275, :height => 25) do
      move_down 2.5
      text "Address", style: :bold, size: 8, :indent_paragraphs => 5
      inline_text "#{@account.street_address.titleize} #{@account.street_address_2}", :indent_paragraphs => 5
      stroke_bounds
    end

    bounding_box([275, current_cursor], :width => 90, :height => 25) do
      move_down 2.5
      text "City", style: :bold, size: 8, :indent_paragraphs => 5
      inline_text "#{@account.city.titleize}", :indent_paragraphs => 5
      stroke_bounds
    end

    bounding_box([365, current_cursor], :width => 90, :height => 25) do
      move_down 2.5
      text "State", style: :bold, size: 8, :indent_paragraphs => 5
      inline_text "#{@account.state.upcase}", :indent_paragraphs => 5
      stroke_bounds
    end

    bounding_box([455, current_cursor], :width => 85, :height => 25) do
      move_down 2.5
      text "9 Digit Zip Code", style: :bold, size: 8, :indent_paragraphs => 5
      inline_text "#{@account.policy_calculation.mailing_zip_code}-#{@account.policy_calculation.mailing_zip_code_plus_4}", :indent_paragraphs => 5
      stroke_bounds
    end

    current_cursor = cursor
    table([["Group-Experience-Rating Enrollment"]], :width => 540, :row_colors => ["EFEFEF"]) do
      row(0).font_style = :bold
      row(0).align      = :center
      self.cell_style   = { :size => 14 }
    end

    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 540, :height => 325, padding: [0, 5, 0, 5]) do
      move_down 5
      indent(5) do
        text "I agree to comply with BWC’s group-experience-rating program rules (Ohio Administrative Code Rules 4123-17-61 through 4123-17-68).  I understand that my participation in the group-experience-rating program is contingent on such compliance. This form supersedes any previously filed AC-26.", size: 10
        move_down 10
        text "I understand only a BWC group-experience-rating program certified sponsor can offer membership into the program.  I also understand if the sponsoring organization listed below is not certified this application is null and void.", size: 10
        move_down 10
        text "I am a member of the <b><u>     NE Ohio Safety Council    </u></b> sponsoring organization or a certified affiliate organization and would like to be included in the group named <b><u>     NEOSC     </u></b> is sponsors for the policy year beginning <b><u>  #{@account.representative.quote_year_lower_date.strftime("%B %e, %Y")}   </u></b>.  In addition, I would like to be included in this group each succeeding policy year until rescinded by the timely filing within the preceding policy year of another AC-26 or until the group administrator does not include my company on the employer roster for group-experience-rating.  I understand the employer roster submitted by the group administrator will be the final, official determination of the group in which I will or will not participate.  Submission of this form does not guarantee participation.", size: 10, inline_format: true
        move_down 10
        text "I understand that the organization’s representative <b><u>     Trident Risk Advisors    </u></b> (currently, as determined by the sponsoring organization) is the only representative I may have in risk-related matters while I remain a member of the group.  I also understand that the representative for the group-experience-rating program will continue as my individual representative in the event that I no longer participate in the group rating plan.  At the time, I am no longer a member of the program, I understand that I must file a Permanent Authorization (AC-2) to cancel or change individual representation. ", size: 10, inline_format: true
        move_down 10
        text "I am associated with the sponsoring organization or a certified affiliate sponsoring organization  <u>  X  </u> Yes <u>     </u> No", size: 10, inline_format: true
        move_down 20
        current_cursor = cursor
        bounding_box([50, current_cursor], :width => 130, :height => 25) do
          inline_text "NEOSC", indent_paragraphs: 45
          stroke_horizontal_rule
          move_down 3
          text "Name of sponsor or affiliate sponsor", size: 8
        end

        bounding_box([350, current_cursor], :width => 130, :height => 25) do
          text "#{@account.policy_number_entered}", indent_paragraphs: 45
          stroke_horizontal_rule
          move_down 3
          text "Policy Number", size: 8, indent_paragraphs: 40
        end
      end
      stroke_bounds
    end

    table([["Certification"]], :width => 540, :row_colors => ["EFEFEF"]) do
      row(0).font_style = :bold
      row(0).align      = :center
      self.cell_style   = { :size => 14 }
    end

    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 540, :height => 150) do
      move_down 25

      text "_<u>                                                        </u> certifies that he/she is the <u>                                                        </u> of", inline_format: true, indent_paragraphs: 10
      text "(Officer Name)                                                                                 (Title)", indent_paragraphs: 65
      move_down 10
      text "_<u>                          #{@account.name}                      </u> , the employer referred to above, and that all the information is", inline_format: true, indent_paragraphs: 10
      text "(Employer Name)", indent_paragraphs: 65
      move_down 10
      text "true to the best of his/her knowledge, information, and belief, after careful investigation.", indent_paragraphs: 10
      move_down 10
      current_cursor = cursor
      bounding_box([50, 50], :width => 130, :height => 50) do
        move_down 25
        stroke_horizontal_rule
        move_down 3
        text "(Officer Signature)", size: 8, align: :center
      end

      bounding_box([350, 50], :width => 130, :height => 50) do
        move_down 25
        stroke_horizontal_rule
        move_down 3
        text "(Date)", size: 8, align: :center
      end

      stroke_bounds
    end

    move_down 5
    text "BWC-0526 (Rev. 12/21/2010) PC", size: 8
    text "AC-26", size: 8, style: :bold
  end
end
