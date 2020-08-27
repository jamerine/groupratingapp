class MatrixGroupRatingQuote < MatrixPdfReport
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
    matrix_header
    inline_text @current_date.strftime('%m/%d/%Y'), style: :bold, size: 12
    move_down 15
    inline_text "BWC Policy Number: #{@account.policy_number_entered}", size: 12, style: :bold
    inline_text @account.name.titleize, size: 12, style: :bold
    inline_text @account.street_address.titleize, size: 12, style: :bold
    inline_text "#{@account.city.titleize}, #{@account.state.upcase} #{@account.zip_code}", size: 12, style: :bold
    move_down 20
    inline_text "We are pleased to invite you to participate in our Group Rating Program for the #{@representative.quote_year} rate year. Please keep in mind the annual Matrix fee includes our top-notch claims management and there are no additional association dues.", size: 13
    move_down 35

    display_data_table
    move_down 40
    inline_text "To enroll, complete and fax the following enclosed items by #{@representative.internal_quote_completion_date&.strftime('%B %d, %Y')}#{@quote.client_packet? ? " to #{@representative.fax_number}." : '.'}"
    move_down 15

    if @quote.client_packet?
      bullet_list(["BWC AC-26 Employer Statement for Group Experience Rating Program", "Group Rating Enrollment Questionnaire", "Matrix Group Rating Agreement (2 pages)"])
    else
      bullet_list([
                    "BWC AC-26 Employer Statement for Group Experience Rating Program",
                    "Group Rating Enrollment Questionnaire",
                    "BWC AC-2 Permanent Authorization",
                    "Matrix Group Rating Agreement (2 pages)",
                    "Payment of #{price(@group_fees)} service fee payable to Matrix Claims Management"
                  ])
    end

    move_down 35
    inline_text @quote.client_packet? ? "Questions: Laurie Ritter, lritter@matrixtpa.com" : "Questions: Katie Jones, kjones@matrixtpa.com"
    move_down 15
    text "*Note: Based on current Ohio BWC data, the offer may be altered/revoked if #{@representative.experience_date&.strftime('%m/%d/%y')} experience data adversely affects your eligibility or Ohio BWC rules you ineligible.", size: 10
    matrix_footer
  end

  def display_data_table
    if table_data.empty?
      text "No Information Found"
    else
      table table_data do
        self.position                     = :center
        self.width                        = 425
        self.cells.border_width           = 0.5
        self.cell_style                   = { padding: [5, 15, 10, 15], inline_format: true }
        self.cells[0, 0].border_color     = MATRIX_COLOR
        self.cells[1, 0].border_top_color = MATRIX_COLOR
        self.cells[0, 1].border_color     = MATRIX_COLOR
        self.cells[1, 1].border_top_color = MATRIX_COLOR

        [*1..3].each do |row|
          self.cells[row, 0].border_right_color = 'FFFFFF'
          self.cells[row, 1].border_left_color  = 'FFFFFF'
        end

        self.row_colors                = [MATRIX_COLOR, nil, nil, nil]
        row(0).font_style              = :bold
        row(0).height                  = 40
        row(0).size                    = 18
        row(1..3).size                 = 16
        row(0..3).column(0).font_style = :bold
        row(0..3).column(1).align      = :right
        column(1).width                = 150
      end
    end
  end

  def table_data
    @data = [["<color rgb='FFFFFF'>#{@account.representative.quote_year} ESTIMATED SAVINGS</color>", "<color rgb='FFFFFF'>#{percent(@account.group_rating_tier)} GROUP</color>"]]
    @data += [["Individual Premium", price(@policy_calculation.policy_total_individual_premium)]]
    @data += [["Net Premium", price(@account.group_premium)]]
    @data += [["Total Savings", price(@account.group_savings)]]
  end
end
