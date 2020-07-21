class MatrixAc2 < MatrixPdfReport
  def initialize(quote = [], account = [], policy_calculation = [], view)
    super()
    @quote              = quote
    @account            = account
    @representative     = @account.representative
    @policy_calculation = policy_calculation
    @view               = view
    @group_fees         =
      if @quote.fees.nil?
        0
      else
        @quote.fees
      end
    @current_date       = DateTime.now.to_date

    ac_2
  end

  private

  def ac_2
    text "PERMANENT AUTHORIZATION", style: :bold, align: :right, size: 12
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 275, :height => 200) do
      image "#{Rails.root}/app/assets/images/ohio7.png", height: 50
      move_down 20
      text "TO:  Ohio Bureau of Workers' Compensation", size: 11
      text "[X] Employer Services Department, 22nd Floor", indent_paragraphs: 24, size: 11
      text "[ ] Self-Insured Department, 27th Floor", indent_paragraphs: 24, size: 11
      move_down 5
      text "Please mark a box and return to", indent_paragraphs: 25, size: 11
      text "30 W. Spring St", indent_paragraphs: 25, size: 11, style: :bold
      text "Columbus, OH 43215-2256", indent_paragraphs: 25, size: 11, style: :bold
      move_down 10
      text "Fax: 614-728-0456", indent_paragraphs: 25, size: 11, style: :bold

      transparent(0) { stroke_bounds }
    end


    bounding_box([300, (current_cursor - 25)], width: 225, height: 35) do
      text_box "Policy Number", style: :bold, at: [10, 30], size: 10
      text_box "#{@account.policy_number_entered}", style: :bold, at: [10, 5], size: 10
      # text_box "Entity:", :at => [10, 90], :width => 100, style: :bold
      # text_box "#{@account.name.titleize}", :at => [110, 90], :width => 160, style: :bold
      # text_box "Address:", :at => [10, 50], :width => 100, style: :bold
      # text_box "#{@account.street_address.titleize} #{@account.street_address_2.titleize}", :at => [110, 50], :width => 160, style: :bold
      # text_box "#{@account.city.titleize}, #{@account.state.upcase} #{@account.zip_code}", :at => [110, 35], :width => 160, style: :bold

      stroke_bounds
    end
    move_down 25
    text "NOTE: For this to be a VALID letter, it must be stamped by Risk Underiting or by the Self-Insured Department for self-insured employers."
    move_down 15
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 200, :height => 25) do
      text "This is to certify that effective <b><u>Immediately,</b></u>", inline_format: true, size: 10
      move_down 3
    end
    bounding_box([200, current_cursor], :width => 300, :height => 25) do
      text "#{@account.representative.company_name}   #{@account.representative.representative_number}-80", indent_paragraphs: 45, style: :bold, size: 10
      stroke_horizontal_rule
      move_down 3
      text "(Representative's name and I.D. Number)", size: 8, align: :center
    end
    text "including its agents or representatives identified to you by them, has been retained to represent us before the Bureau of Workers’ Compensation and the Ohio Industrial Commission in any and all matters pertaining to our participation in the Workers’ Compensation Fund according to the type of representation checked below.  Please check the type of representation desired.  See description of representatives on side 2.", size: 10
    move_down 10
    table ([["", "Type of Authorized Representation"], ["X", "Employer Risk/Claim Representative (ERC)"], ["", "Risk Management Representative (RISK)"], ["", "Claim Management Representative (CLM)"]]), :column_widths => { 0 => 25, 1 => 300 } do
      self.position     = :center
      row(0).font_style = :bold
      row(0..-1).align  = :center
      self.cell_style   = { :size => 11 }
    end
    move_down 15
    text "The authorization supersedes all permanent authorizations on file for the type of representation indicated above."
    move_down 15
    text "I understand and agree any letters, requests, and actions initiated by a superseded authority will be processed completely."
    move_down 15
    text "I understand that this authorization, now being granted, is of a continuous nature from the effective date indicated herein.  However, I possess the right to terminate this authorization at any time through written notification to Risk Underwriting or Self-Insured Department as appropriate."
    move_down 10
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 175, :height => 40) do
      move_down 3
      text "Telephone Number", size: 8, indent_paragraphs: 5

      stroke_bounds
    end
    bounding_box([175, current_cursor], :width => 175, :height => 40) do
      move_down 3
      text "Fax Number", size: 8, indent_paragraphs: 5

      stroke_bounds
    end
    bounding_box([350, current_cursor], :width => 175, :height => 40) do
      move_down 3
      text "Email Address", size: 8, indent_paragraphs: 5

      stroke_bounds
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 175, :height => 40) do
      move_down 3
      text "Print Name and Title", size: 8, indent_paragraphs: 5

      stroke_bounds
    end
    bounding_box([175, current_cursor], :width => 175, :height => 40) do
      move_down 3
      text "Employer Signature", size: 8, indent_paragraphs: 5

      stroke_bounds
    end
    bounding_box([350, current_cursor], :width => 175, :height => 40) do
      move_down 3
      text "Date", size: 8, indent_paragraphs: 5

      stroke_bounds
    end
    move_down 5
    text "BWC-0502 (Rev. 7/29/2008)", size: 8
    text "AC-2", size: 10, style: :bold


  end

end
