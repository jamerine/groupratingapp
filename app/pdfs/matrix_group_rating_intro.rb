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
    inline_text "Dear Group Rated Employer: #{@account.name.titleize}"
    move_down 15

    if @quote.client_packet?
      inline_text "Thank you for your continued loyalty to The Matrix Companies."
      move_down 15
      inline_text "We are excited to offer you admittance into our top notch #{@representative.quote_year} Group Rating plan. Enclosed you will find an explanation of the premium savings and services that are included in your enrollment. In the event you are considering multiple program enrollment options, please contact us for further discussion and analysis."
      move_down 15
      inline_text "Enrollment is simple. Just complete the enclosed pages and submit to Matrix. If you have any questions or feedback, give us a call."
      move_down 15
      inline_text "As an additional benefit to our group rating program enrollees, Matrix is offering our premier services at a reduced rate this year. These services allow our clients to reduce claims and maximize savings. Please email Jessica Esterkamp at <link href='mailto:jessica@matrixtpa.com'>jessica@matrixtpa.com</link> if you are interested in a safety assessment and recommendations."
    else
      inline_text "Thank you for the opportunity to provide a #{@representative.quote_year} Group Rating program enrollment quote. We are confident that you will find our program and service offerings to be proactive and unique."
      move_down 15
      inline_text "Although comparing fees and percentage are an important part of selecting a partner, it is even more important that you evaluate the quality of the claims management in order to receive future savings. Here are a few reasons 98% of our clients remain loyal every year:"
      move_down 15
      bullet_list([
                    'Matrix provides one point of management to handle claims from start to finish rather than having to talk to multiple people about one issue.',
                    'Our group rating enrollment fee is all-inclusive, there are no additional membership or association dues to pay.',
                    'Matrix takes a holistic approach to reducing your risk by offering in-house safety solutions, case management, and investigative services to reduce the frequency and severity of claims by an average of 22% for our clients.',
                    'Matrix leads the industry in the highest number of handicaps and settlements per client which offers significant cost savings to our clients.',
                    'Matrix provides attorney representation at hearings rather than hearing reps for the best chance of successful outcomes.',
                    'Matrix provides our employees with a top workplace environment because we believe that happy employees result in satisfied clients. Our low turnover and smaller caseloads are felt by our clients.'
                  ])
      move_down 15
      inline_text 'Matrix has experienced rapid growth and recognition because of our model which makes every client feel important. As the founder and owner of Matrix, I stand behind what we promise and am confident you will be impressed.'
    end

    move_down 40

    current_cursor = cursor

    bounding_box([0, current_cursor], width: 100) do
      if Rails.env.development?
        image open('public/' + @representative.president.url), width: 100
      else
        image open(@representative.president.url), width: 100
      end
    end

    bounding_box([125, current_cursor - 10], :width => 150, :height => 300) do
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
