class MatrixGroupRatingIntro < MatrixPdfReport
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

    intro_page
  end

  private

  def intro_page
    matrix_header

    inline_text "Dear Group Rated Employer: #{@account.name}"
    move_down 15
    inline_text "Thank you for your continued loyalty to The Matrix Companies."
    move_down 15
    inline_text "We are excited to offer you admittance into our top notch #{@account.representative.quote_year} Group Rating plan. Enclosed you will find an explanation of the premium savings and services that are included in your enrollment. In the event you are considering multiple program enrollment options, please contact us for further discussion and analysis."
    move_down 15
    inline_text "Enrollment is simple. Just complete the enclosed pages and submit to Matrix. If you have any questions or feedback, give us a call."
    move_down 15
    inline_text "As an additional benefit to our group rating program enrollees, Matrix is offering our premier services at a reduced rate this year. These services allow our clients to reduce claims and maximize savings. Please email Jessica Esterkamp at <a href='mailto:jessica@matrixpa.com'>jessica@matrixpa.com</a> if you are interested in a safety assessment and recommendations."
    move_down 45

    current_cursor = cursor

    # box_shadow: '10px 7px 15px 5px rgba(0,0,0,0.25);'

    bounding_box([0, current_cursor], width: 85, height: 165) do
      if Rails.env.development?
        image open('public/' + @representative.president.url), height: 165
      else
        image open(@representative.president.url), height: 175
      end
    end

    bounding_box([145, current_cursor - 10], :width => 150, :height => 300) do
      signature
      transparent(0) { stroke_bounds }
    end

    matrix_footer
  end

  def signature
    inline_text "Sincerely,"
    move_down 5

    signature_image

    move_down 5
    inline_text @representative.president_full_name
    inline_text "President/CEO"
    inline_text "The Matrix Companies"
  end
end
