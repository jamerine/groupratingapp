class MatrixTestimonials < MatrixPdfReport
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

    testimonials
  end

  private

  def testimonials
    matrix_header true, true
    move_down 5
    testimonial 'Matrix provides excellent service that is very flexible and meets our needs in a timely manner. We like the process of case assignments not being separated out by medical only and lost time claims, which allows familiarity of claims for an injured employee. We also like that Matrix’s operating system focuses on Ohio workers’ compensation and that you have attorneys to attend hearings.', 'Diana Tracey, The City of Cincinnati', 'diana.tracey@cincinatti-oh.gov'
    testimonial 'On the workers’ comp side, I think the Matrix program is the best in Ohio. The claim administration has been flawless. You have been able to keep our claims under control and get people back to work or claims settled before they become a nightmare. We have also had great success with you case management. When I checked your references I asked everyone what their worst problem had been and nobody could think of anything and I can’t either. Matrix does not just process paperwork and take hearings, you are truly working with our company to improve our programs and reduce our cost and take great price in doing so. And, you are great people to work with.', 'Donna Hadley, United Dairy Farmers', 'dhadley@udfinc.com'
    testimonial 'Matrix has been a miracle worker for our injured workers and our company’s bottom line. We have been able to effectively run a light duty program that has returned our employees to safe and productive environments. And with Matrix’s aggressive, but caring claims management approach, we have reduced our reserves by more than 50 percent. Teaming with Matrix is one of the wisest and most cost effective decisions an employer can make.', 'Dorothea Martin, Rumpke', 'dorothea.martin@rumpke.com'
    testimonial 'The service with Matrix has been very good. Having one person manage our policy makes Matrix user friendly and easier on me. I would highly recommend your company to any employer.', 'Christopher Ernst, Gold Medal Popcorn', 'cernst@gmpopcorn.com'
    testimonial 'The relationship between Tigerpoly and Matrix is a true partnership—working together for what is best for Tigerpoly. Our former TPA was merely a hodge-podge of people processing our claims. No matter what service I’m using, from my customer service rep, to case management, to surveillance I always feel important and valued.', 'Michelle Gerke, Tigerpoly', 'mgerke@tigerpoly.com'

    matrix_footer
  end

  def testimonial(quote, author, email)
    text "\"#{quote}\"", style: :italic, size: 12
    move_down 2

    indent(30) do
      text author, style: :bold, size: 12
      text "<u><link href='mailto:#{email}'>#{email}</link></u>", style: :bold, size: 12, inline_format: true, color: '0563c1'
    end

    move_down 15
  end
end