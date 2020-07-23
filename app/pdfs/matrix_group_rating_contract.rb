class MatrixGroupRatingContract < MatrixPdfReport
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

    contract
  end

  private

  def contract
    matrix_header
    move_down 10

    text "WORKERS' COMPENSATION CLAIMS MANAGEMENT SERVICES", style: :bold, size: 11, align: :center
    text "GROUP RATING AGREEMENT", style: :bold, size: 11, align: :center
    agreement_text "Matrix Claims Management, Inc., #{@representative.full_location_address}", align: :center
    agreement_text "(“Matrix”) hereby offers workers’ Compensation consulting services to:", align: :center
    move_down 15
    text "<u><b>#{@account.name.titleize}, BWC POLICY #: #{@account.policy_number_entered}</b></u>, (“Client”) for the period beginning on <u><b>  #{@account.tpa_from_date.strftime('%m/%d/%Y')}  </b></u> and ending on <u><b>  #{@account.tpa_to_date.strftime('%m/%d/%Y')}  </b></u> and to renew as stipulated in this agreement.", inline_format: true, size: 10
    move_down 15

    current_cursor = cursor
    half_width     = (bounds.right - bounds.left) / 2
    gutter_size    = 12

    bounding_box([0, current_cursor], :width => half_width - (gutter_size / 2)) do
      agreement_text 'I. Services', style: :bold
      move_down 5
      agreement_text 'The Client understands that Matrix Claims Management, Inc. will provide the following services as part of this agreement:'
      move_down 10

      arrowhead_list([
                       'File the completed Employer Statement for Group Experience Rating (BWC Form AC-26)',
                       'Confer with and instruct the Client’s workers’ compensation administrator(s) regarding compliance with the Ohio Bureau of Workers’ Compensation (hereafter referred to as BWC) and Ohio Industrial Commission rules and regulations; payroll compliance, and classification and reporting procedure;',
                       'Aggressively manage your active BWC claims to control costs using various claims management strategies, including but not limited to:'
                     ]
      )

      indent(35) do
        [
          'Work as a liaison between your company and your managed care organization (MCO) in accident reporting, investigations, the filing of new claims and controlling medical costs,',
          'Assist injured employees with benefits',
          'Identify extensive treatment plans and prolonged lost time costs;'
        ].each do |item|
          text_box "•", at: [0, cursor], size: 15
          move_down 2.5
          indent(15) do
            agreement_text item
          end
        end
      end

      arrowhead_list([
                       'Apply for Handicap Reimbursements on qualifying claims and present company’s position before the BWC at handicap hearings;',
                       'Evaluate and negotiate claim settlements on behalf of the Client with injured workers and/or their legal representatives and BWC;',
                       'Review all claims to determine if rehabilitation intervention is appropriate (costs relating to rehabilitation services must be pre-approved by the Client and shall be the responsibility of the Client);',
                       'Confer with the Client as to disputed cases and contact the injured worker, medical providers, MCO, BWC, IC as appropriate;',
                       'Review and advise Client on premium reduction opportunities including, but not limited to; Drug Free Workplace Program, Retrospective Rating, Self-insurance, Safety Services, Transitional Work Programs, and Safety Grants',
                       'Provide training opportunities relative to workers’ compensation and risk management at the Client location (per Client request), as well as, periodic seminars offered to all Clients. There may be an additional fee for customized training, training provided at the Client’s location or seminar attendance;',
                       'Prepare claim file for presentation by legal representative before the Industrial Commission of Ohio and provide written documentation of proceedings to Client after hearing'
                     ])
    end

    stroke do
      vertical_line current_cursor, (bounds.bottom + 25), at: half_width + (gutter_size / 2)
    end

    bounding_box([half_width + (gutter_size * 2), current_cursor], :width => half_width - gutter_size) do
      move_down 15
      agreement_text 'II. Group Rating', style: :bold
      move_down 5
      agreement_text 'Submit Client information for group rating determination and assist Client with group rating enrollment process; Provide consulting services with regard to competitive group rating quotes;'
      move_down 15
      agreement_text 'III. "Practice of Law" and Hearing Representation', style: :bold
      move_down 5
      agreement_text 'Third Party Administrators, such as Matrix, are prohibited from providing services that would constitute the unauthorized practice of law. All services provided under this agreement shall not be in violation of rules and regulations (I.C. Resolution R-04-1-01) promulgated to govern the unauthorized practice of law. Pursuant to current and future rules and regulations, Matrix shall not provide any services that are construed to constitute the unauthorized practice of law;'
      move_down 12
      agreement_text 'To ensure Matrix is not in conflict with I.C. Resolution R-04-1-01, Matrix prohibits employees from representing Clients at Industrial Commission hearings. However, Matrix will assist and arrange for independent legal counsel to represent the Client in Industrial Commission hearings via our network of attorneys. Said legal counsel will be directly representing and acting on behalf of the Client at Industrial Commission hearings. Fees incurred by legal representation will be the responsibility of the Client. Matrix will provide all documentation, notes, plans of action, and any other necessary information available to assigned legal counsel as preparation for the hearing;'
      move_down 12
      agreement_text 'To register legal counsel, it will be necessary for the Client employer to sign an R-1 card and file it with the Bureau of Workers’ Compensation or the Industrial Commission of Ohio. Matrix will assist in obtaining counsel, filing the R-1 card, and scheduling the attorney at I.C. hearing. If the Client requests Matrix’s assistance in scheduling their representation, all fees related to representation will be billed separately by Matrix to Client.'
      move_down 20
      agreement_text 'IV. Client Obligations', style: :bold
      move_down 5
      agreement_text 'The Client shall comply with all statutes, rules and regulations of the State of Ohio and accepts sole responsibility for understanding and complying with same;'
      move_down 12
      agreement_text 'The Client is responsible for making timely premium payments to the Ohio Bureau of Worker’s Compensation;'
    end

    matrix_footer

    start_new_page

    matrix_header
    current_cursor = cursor

    bounding_box([0, current_cursor], :width => half_width - (gutter_size / 2)) do
      agreement_text 'The Client shall submit to Matrix all first reports of injury, supporting documentation, and any follow-up information it receives pertaining to a claim filed against it;'
      move_down 12
      agreement_text 'Client agrees that it is not a Professional Employer Organization/Leasing Company (PEO) not has a relationship with a PEO, and will refrain from acting as, or entering into a relationship with, a PEO during the term of this agreement.'
      move_down 15
      agreement_text 'V. Indemnification', style: :bold
      move_down 5
      agreement_text 'Matrix agrees that services outlined in this agreement will be provided in a professional manner and that reasonable diligence will be employed in the performance of all of its contractual obligations. Matrix will not be liable to the Client for any damages caused by negligence or errors in the performance of its duties hereunder in excess of the amount of service fees paid by the Client. The Client agrees to hold harmless Matrix and their successors, members, directors, employees, assigns, officials, and subsidiaries against any and all losses, damages, and expenses, including court costs and attorneys’ fees, resulting from or arising out of claims, demands or lawsuits, whether known or unknown, arising out of the terms and services of this agreement;'
      move_down 15
      agreement_text 'VI. Terms', style: :bold
      move_down 5
      agreement_text "Matrix Claims Management, Inc. will provide the aforementioned services for the fee of <u>  #{price(@group_fees)}  </u> for the period stipulated at the top of this agreement. It is further understood that this agreement will renew for twelve months at the end of the initial service period and subsequent service periods, unless written notice, stating otherwise, is received, at least 90 days, prior to the end of the current service period. Fees for renewal periods will be adjusted to reflect cost inflation, Client activity and volume."
      move_down 12
      agreement_text 'Payment of the first year fees is due within 15 days of the initiation of this agreement. Subsequent years will be billed and are due as stipulated on the Matrix invoice. If payment is not received by Matrix as defined in this agreement, it is understood that all further Matrix services may be suspended and the agreement terminated at Matrix’s discretion.'
    end

    stroke do
      vertical_line current_cursor, (bounds.bottom + 185), at: half_width + (gutter_size / 2)
    end

    bounding_box([half_width + (gutter_size * 2), current_cursor], :width => half_width - gutter_size) do
      move_down 15
      agreement_text "Client, if qualified, shall be eligible to participate in the program for the plan year #{@account.representative.quote_year_lower_date.strftime("%B %e, %Y")} to #{@account.representative.quote_year_upper_date.strftime("%B %e, %Y")}. This agreement is considered accepted and will commence upon Matrix’s receipt of the completed agreement and AC-26 and will be effective through June 30 of the plan year. In the event the Client becomes ineligible for participation in the program, or the Group Sponsor and/or Matrix determines the Client is ineligible, payment received shall be applied to Client’s fee for all other administrative services as outlined in this agreement. If Client desires to withdraw from the program and requests a refund of monies paid, it is understood and accepted that the refunded amount will be prorated for services rendered less a $75 processing fee. Client may withdraw their enrollment up to the first Monday in January for that application year by submitting a written request to Matrix."
      move_down 15
      agreement_text 'In the event the Client becomes ineligible to participate in subsequent Group Rating Program years, the aforementioned enumerated services will continue to be performed until such time as former Client renders written notice to the contrary at least 90 days prior to the expiration date of this agreement.'
      move_down 15
      agreement_text 'VII. Termination', style: :bold
      move_down 5
      agreement_text 'This agreement may be terminated at any time by the mutual written consent of the parties hereto. In addition, the agreement may be terminated without cause, by either party upon ninety (90) days advance written notice to the other party, or immediately by Matrix upon failure of the other party to comply with the material terms of this agreement. If Client is enrolled in a group rating program and then wishes to terminate this agreement before expiration, Client will not be entitled to a refund of any of the fees paid.'
      move_down 15
      agreement_text 'VIII. Agreement Summation', style: :bold
      move_down 5
      agreement_text 'This agreement constitutes the entire understanding between the parties concerning its subject matter. All prior negotiations and agreements of the parties with respect to any of the duties and responsibilities set forth in this agreement are merged into this agreement. There are no other agreements or understandings between the parties, expressed or implied, written or oral, that is not reduced to writing herein.'
    end

    move_down 25
    stroke_horizontal_rule
    move_down 5
    agreement_text 'In witness whereof, the parties have executed this agreement:'
    move_down 10

    table contract_table_data do
      self.width              = 490
      self.position           = :center
      self.cells.border_width = 0
      self.cell_style         = { padding: [10, 0, 0, 3], inline_format: true, size: 10 }

      row(1..4).column(2).padding = [10, 0, 0, 10]
      row(1..4).column(1).padding = [10, 0, 0, 5]
      row(0).padding              = [0, 0, 0, 3]
      row(0).column(2).padding    = [0, 0, 0, 10]
      row(0).column(3).padding    = [0, 0, 0, 5]

      [*1..4].each do |row|
        self.cells[row, 1].border_bottom_width = 0.5
        self.cells[row, 3].border_bottom_width = 0.5
      end

      self.cells[0, 3].border_bottom_width = 0.5
      column(0).width                      = 50
      column(2).width                      = 100
    end

    matrix_footer
  end

  def contract_table_data
    [[{ content: '<b><u>Matrix Claims Management Inc.</u><b>', colspan: 2 }, '<b><u>Company Name:</u></b>', @account.name.titleize],
     ['By:', { image: "#{Rails.env.development? ? 'public/' : '' }#{@representative.signature.url}", image_height: 15 }, 'By:', ''],
     ['Printed:', @representative.president_full_name, 'Printed:', ''],
     ['Title:', 'CEO', 'Title:', ''],
     ['Date:', @current_date.strftime('%m/%d/%Y'), 'Date:', '']]
  end
end
