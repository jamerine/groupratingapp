class MatrixGroupRetroQuote < MatrixPdfReport
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

    quote_analysis
  end

  private

  def quote_analysis
    matrix_header true, true
    inline_text @current_date.strftime('%m/%d/%Y'), style: :bold, size: 12
    move_down 15
    inline_text "BWC Policy Number: #{@account.policy_number_entered}", size: 12, style: :bold
    inline_text @account.name.titleize, size: 12, style: :bold
    inline_text @account.street_address.titleize, size: 12, style: :bold
    inline_text "#{@account.city.titleize}, #{@account.state.upcase} #{@account.zip_code}", size: 12, style: :bold
    move_down 20
    inline_text "We are pleased to invite you to participate in our Group Retrospective Rating Program for the #{@representative.quote_year} rate year.  Please keep in mind the annual Matrix fee includes all association dues as well as our top-notch claims management.", size: 13
    move_down 25

    display_data_table
    move_down 15

    text '<b>Individual Premium</b> – Employer’s premium including the BWC’s administrative costs.', inline_format: true, size: 8
    text '<b>Adjusted Premium</b> – Employer’s premium after EMR and premium adjustments are applied. Adjusted premium includes the BWC administrative costs.', inline_format: true, size: 8
    text '<b>Standard Premium</b> – Employer’s premium excluding the BWC’s administrative costs. The group retro discount applies to the standard premium only.', inline_format: true, size: 8

    move_down 20

    faq_text "To enroll, complete and fax the following enclosed items by #{@representative.internal_quote_completion_date&.strftime('%B %d, %Y')}."

    if @quote.client_packet?
      bullet_list(["BWC U-153 Employer Statement for Group Retro Rating Program", "Group Retro Rating Safety Assessment", "Matrix Group Rating Agreement (2 pages)"], true)
    else
      bullet_list([
                    "BWC U-153 Employer Statement for Group Retro Rating Program",
                    "BWC AC-2 Permanent Authorization",
                    "Group Retro Rating Safety Assessment",
                    "Matrix Group Rating Agreement (2 pages)",
                    "Payment of #{price(@group_fees)} service fee payable to Matrix Claims Management"
                  ], true)
    end

    move_down 25
    faq_text @quote.client_packet? ? "Questions: Laurie Ritter, lritter@matrixtpa.com" : "Questions: Katie Jones, kjones@matrixtpa.com"
    move_down 15
    text "*Notes: This projection is based on current Ohio BWC data and may be altered or revoked if #{@representative.experience_date&.strftime('%m/%d/%y')} experience data adversely affects your eligibility or Ohio BWC rules you ineligible. Your max assessment of 15% equates to #{price(@policy_calculation.total_assessments)}", size: 9
    matrix_footer
  end

  def display_data_table
    if table_data.empty?
      text "No Information Found"
    else
      table table_data, width: bounds.width - 50 do
        self.position                     = :center
        self.cells.border_width           = 0.5
        self.cell_style                   = { padding: [5, 15, 5, 15], inline_format: true }
        self.cells[0, 0].border_color     = MATRIX_COLOR
        self.cells[1, 0].border_top_color = MATRIX_COLOR
        self.cells[0, 1].border_color     = MATRIX_COLOR
        self.cells[1, 1].border_top_color = MATRIX_COLOR

        [*0..7].each do |row|
          self.cells[row, 0].border_right_width = 0
          self.cells[row, 1].border_left_width  = 0
        end
        self.row_colors                = [MATRIX_COLOR, nil, nil, nil, nil, 'b4c6e7', nil, 'b4c6e7']
        row(1..7).padding              = [5, 30, 5, 30]
        row(0).font_style              = :bold
        row(0).height                  = 30
        row(5).height                  = 25
        row(7).height                  = 25
        row(0).size                    = 18
        row(1..7).size                 = 12
        row(0..7).column(0).font_style = :bold
        row(0..7).column(1).align      = :right
        column(1).width                = 215
      end
    end
  end

  def table_data
    @data = [["<color rgb='FFFFFF'>#{@account.representative.quote_year} ESTIMATED SAVINGS</color>", "<color rgb='FFFFFF'>#{percent(@account.group_retro_tier)} GROUP RETRO</color>"]]
    @data += [["Total Premium", price(@policy_calculation.policy_adjusted_standard_premium)]]
    @data += [["Adjusted Premium", price(@policy_calculation.policy_total_standard_premium)]]
    @data += [["Net Premium", price(@account.group_retro_premium)]]
    @data += [["", ""]]
    @data += [["Group Retro Estimated Refund", price(@account.group_retro_savings)]]
    @data += [["", ""]]
  end
end
