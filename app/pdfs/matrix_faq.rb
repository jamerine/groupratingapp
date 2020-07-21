class MatrixFAQ < MatrixPdfReport
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

    faq
  end

  private

  def faq
    matrix_header
    faq_text 'FREQUENTLY ASKED QUESTIONS ABOUT GROUP RATING', style: :bold
    move_down 15

    faq_question('What is group rating?', 'Group rating is an alternative rating program offered by the BWC to reduce premiums paid by Ohio employers. Group rating allows employers of a similar industry to join together through a sponsoring association to be rated as a group and pay a much lower premium than they would pay on an individual basis. This is an UPFRONT discount.')
    faq_question('When do my discounted group rates become effective?', "Group rates will become effective #{@account.tpa_from_date.strftime("%B %e, %Y")}.")
    faq_question('When are group rating applications due to BWC?', "The BWC deadline for our office to file enrollment applications for #{@representative.quote_year} group rating is #{@representative.bwc_quote_completion_date.strftime('%B %e, %Y')}. However, to ensure that all paperwork is submitted on time and accurately, our internal deadline is #{@representative.internal_quote_completion_date.strftime('%B %e, %Y')}.")
    faq_question('Why do I have to sign up for group rating so far in advance of the start of the rating year?', "The enrollment deadline is a BWC requirement. It gives the BWC an opportunity to review all employers who apply for group rating to ensure they meet eligibility requirements. Final approval to receive group discounts will be made by the BWC. Matrix enrolls its clients early so that the process doesn’t become a burden to the client while they are focusing on other aspects of their operations.")
    faq_text 'What are the criteria to participate in group rating?', color: MATRIX_COLOR, style: :bold
    bullet_list([
                  'Be current on all undisputed premiums, administrative costs, assessments, fines or monies otherwise due to BWC;',
                  'More specifically, you must be current, not more than 45 days past the due date on any balance greater than $200 due to BWC, by the group-rating application deadline. The only exceptions are when a policy is placed into an appealed status or a BWC-approved payment plan is in place.',
                  'Be current on the payment schedule for any scheduled part-pay agreement you\'ve entered into to pay premiums or assessments otherwise due BWC as of the application deadline;',
                  'Employers cannot have cumulative lapses in workers\' compensation coverage in excess of 40 days in the past twelve months preceding the application deadline.',
                  'Not be a member of more than one group. If you apply for more than one group on a valid group-experience-rating application, BWC will reject you for all groups.',
                  'Third-party administrators must submit a list of employers who are members of each group to BWC by the required application deadline.',
                  'The employers within the group must be businesses that are substantially similar.',
                  'Each sponsoring organization’s group program must substantially improve accident prevention and claims handling. The sponsoring organization must document improvement.',
                  'The group must consist of at least 100 individual employers, or the combined premiums of the employers must exceed $150,000.'
                ], true)
    move_down 10
    faq_question("What is the largest possible discount for #{@representative.quote_year} group rating?", "The maximum possible discount a group-rated employer may receive is 53%.")
    faq_question("With which sponsoring association do Matrix clients get placed for group rating?", "Matrix, in partnership with Trident Risk Advisors, places its clients under the NE Ohio Safety County. The NEOSC accommodates the various industry classes for group rating. The NEOSC is the umbrella for various group rating plans.")
    faq_question("What payroll is used in calculating projected savings?", "Trident is currently using the most recent reported payroll to the BWC.")

    matrix_footer
  end

  def faq_question(text, answer)
    faq_text text, color: MATRIX_COLOR, style: :bold
    faq_text answer
    move_down 10
  end
end
