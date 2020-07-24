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

    bounding_box([0, current_cursor + 25], :width => 275, :height => 175) do
      image "#{Rails.root}/app/assets/images/ohio7.png", height: 50
      move_down 20
      text "TO:  Ohio Bureau of Workers' Compensation", size: 10
      text "[X] Employer Services Department, 22nd Floor", indent_paragraphs: 24, size: 10
      move_down 2
      text "[  ] Self-Insured Department, 27th Floor", indent_paragraphs: 24, size: 10
      move_down 10

      indent(38) do
        text "Please mark a box and return to", size: 10
        text "30 W. Spring St", size: 10
        text "Columbus, OH 43215-2256", size: 10
        move_down 10
        text "Fax: 614-728-0456", size: 10
      end

      transparent(0) { stroke_bounds }
    end

    box_height = 110

    bounding_box([300, (current_cursor - 25)], width: 225, height: box_height) do
      text_box "Policy Number", style: :bold, at: [5, box_height - 2.5], size: 8
      text_box "#{@account.policy_number_entered}", at: [5, box_height - 12], size: 10

      entity_box_height = box_height - 25
      line [0, entity_box_height], [225, entity_box_height]
      stroke

      text_box "Entity", style: :bold, at: [5, entity_box_height - 2.5], size: 8
      text_box "#{@account.name.titleize}", at: [5, entity_box_height - 12], size: 10

      dba_box_height = entity_box_height - 25
      line [0, dba_box_height], [225, dba_box_height]
      stroke

      text_box "DBA", style: :bold, at: [5, dba_box_height - 2.5], size: 8

      address_box_height = dba_box_height - 25
      line [0, address_box_height], [225, address_box_height]
      stroke

      text_box "Address", style: :bold, at: [5, address_box_height - 2.5], size: 8
      text_box "#{@account.street_address.titleize} #{@account.street_address_2.titleize}", at: [5, address_box_height - 12], size: 10
      text_box "#{@account.city.titlecase}, #{@account.state.upcase} #{@account.zip_code}", at: [5, address_box_height - 22], size: 10
      stroke_bounds
    end

    move_down 25

    faq_text "NOTE: For this to be a <b>valid</b> letter, it must be stamped by Risk Underwriting or by the Self-Insured Department for self-insured employers."
    move_down 15
    current_cursor = cursor

    bounding_box([0, current_cursor], :width => 150, :height => 25) do
      faq_text "This is to certify that effective"
    end

    bounding_box([175, current_cursor + 5], :width => bounds.right - 200, :height => 25) do
      faq_text @current_date.strftime("%B #{@current_date.day.ordinalize}, %Y"), align: :center
      stroke_horizontal_rule
      move_down 3.5
      text "(Date)", size: 8, align: :center
    end

    move_down 15

    faq_text "Matrix Claims Mgmt - Rep I.D. #{@representative.representative_number}-80", align: :center
    stroke_horizontal_rule
    move_down 3.5
    text "(Representative's name and I.D. Number)", size: 8, align: :center
    move_down 15

    faq_text "Including its agents or representatives identified to you by them, has been retained to represent us before the Ohio Bureau of Workers’ Compensation and the Industrial Commission of Ohio in matters pertaining to our participation in the Workers’ Compensation Fund according to the type of representation checked below."
    faq_text "Please check only one type of representation. See description of representatives on side 2."

    move_down 15

    table ([["", "Type of Authorized Representation"], ["X", "Employer Risk/Claim Representative (ERC)"], ["", "Risk Management Representative (RISK)"], ["", "Claim Management Representative (CLM)"]]), :column_widths => { 0 => 25, 1 => 300 } do
      self.position     = :center
      row(0).font_style = :bold
      row(0..-1).align  = :center
      self.cell_style   = { :size => 11 }
    end

    move_down 20

    faq_text "The authorization supersedes all permanent authorizations on file for the type of representation indicated above."
    move_down 10
    faq_text "I understand and agree BWC will process any letters, requests, and actions initiated by a superseded authority."
    move_down 10
    faq_text "I understand that this authorization, now being granted, is of a continuous nature from the effective date indicated herein. However, I possess the right to terminate this authorization at any time through written notification to the Employer Services or Self-Insured Department as appropriate."
    move_down 20

    page_width = bounds.right - bounds.left

    table ac2_table_data do
      self.width        = page_width
      self.position     = :center
      self.cells.border_width = 0.5
      self.cell_style   = { size: 8, padding: [1, 0, 0, 5], height: 30 }
    end

    move_down 25
    text "BWC-0502 (Rev. 7/21/2009)", size: 8
    text "AC-2", size: 10, style: :bold
  end

  def ac2_table_data
    [
      ['Telephone Number', 'Fax Number', { content: 'E-mail Address', colspan: 2 }],
      [{ content: 'Print Name and Title', colspan: 2 }, 'Employer Signature', 'Date']
    ]
  end
end
