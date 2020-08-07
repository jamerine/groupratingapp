class MatrixGroupRetroContract < MatrixPdfReport
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
    matrix_header true, true
    move_down 5

    text "WORKERS' COMPENSATION CLAIMS MANAGEMENT SERVICES", style: :bold, size: 11, align: :center
    text "GROUP RATING AGREEMENT", style: :bold, size: 11, align: :center
    agreement_text "Matrix Claims Management, Inc., #{@representative.full_location_address}", align: :center
    agreement_text "(“Matrix”) hereby offers workers’ Compensation consulting services to:", align: :center
    move_down 10
    agreement_text "<u><b>#{@account.name.titleize}, BWC POLICY #: #{@account.policy_number_entered}</b></u>, (“Client”) for the period beginning on <u><b>  #{@account.tpa_from_date.strftime('%m/%d/%Y')}  </b></u> and ending on <u><b>  #{@account.tpa_to_date.strftime('%m/%d/%Y')}  </b></u>. pursuant to the terms and conditions set forth in this Group Retrospective Rating Agreement (“Agreement”) for the Northeast Ohio Safety Council (“Sponsoring Organization”) Ohio Workers’ Compensation Group Retrospective Rating Program. In consideration of the mutual promises contained herein, Matrix and Client agree as follows.", inline_format: true
    move_down 10

    current_cursor = cursor
    half_width     = (bounds.width) / 2
    gutter_size    = 10

    bounding_box([-10, current_cursor], :width => (half_width + 10) - (gutter_size / 2)) do
      agreement_text 'I. Services', style: :bold
      agreement_text 'The Client understands that Matrix Claims Management, Inc. will provide the following services as part of this agreement:'

      arrowhead_list([
                       'File the completed Employer Statement for Group Retrospective Rating (BWC Form U-153)',
                       'Confer with and instruct the Client’s workers’ compensation administrator(s) regarding compliance with the Ohio BWC and Ohio Industrial Commission rules and regulations; payroll compliance, and classification and reporting procedure;',
                       'Assist Client in placement and entrance into Group Retro Program;',
                       'Review the reserves and costs associated with claims in the Client’s experience period and file any discrepancies identified for correction with BWC;',
                       'Manage your active BWC claims to control costs using various claims management strategies, including but not limited to:'
                     ]
      )

      indent(35) do
        [
          'Work as a liaison between your company and your managed care organization (MCO) in accident reporting, investigations, the filing of new claims and controlling medical costs,',
          'Assist injured employees with benefits',
          'Identify extensive treatment plans and prolonged lost time costs;'
        ].each do |item|
          text_box "•", at: [0, cursor], size: 15
          move_down 1.5
          indent(15) do
            agreement_text item
          end
        end
      end

      arrowhead_list([
                       'Identify Handicap Reimbursements on qualifying claims and present company’s position for BWC handicap hearings;',
                       'Evaluate and negotiate claim settlements on behalf of the Client with injured workers and/or their legal representatives and BWC;',
                       'Review all claims to determine if rehabilitation intervention is appropriate (costs relating to rehabilitation services must be pre-approved by the Client and shall be the responsibility of the Client);',
                       'Confer with the Client as to disputed cases and contact the injured worker, medical providers, MCO, BWC, IC as appropriate;',
                       'Provide training opportunities relative to workers’ compensation and risk management at the Client location (per Client request), as well as, periodic seminars offered to all Clients. There may be an additional fee for customized training, training provided at the Client’s location or seminar attendance;',
                       'Prepare claim file for presentation by legal representative before the Industrial Commission of Ohio and provide written documentation of proceedings to Client after hearing (See “Practice of Law” and Hearing Representation below);'
                     ])

      move_down 7
      agreement_text 'II. "Practice of Law" and Hearing Representation', style: :bold
      agreement_text 'Third Party Administrators, such as Matrix, are prohibited from providing services that would constitute the unauthorized practice of law. All services'
    end

    stroke do
      vertical_line current_cursor, (bounds.bottom + 20), at: half_width + (gutter_size / 2)
    end

    bounding_box([half_width + (gutter_size * 2) - 2.5, current_cursor], :width => half_width - gutter_size + 2.5) do
      agreement_text 'provided under this agreement shall not be in violation of rules and regulations (I.C. Resolution R-04-1-01) promulgated to govern the unauthorized practice of law.'
      move_down 10
      agreement_text "___________ <b>(Customer to initial indicating their understanding)</b> To ensure Matrix is not in conflict with I.C. Resolution R-04-1-01, Matrix prohibits employees from representing Clients at Industrial Commission hearings. However, Matrix will assist and arrange for independent legal counsel to represent the Client in Industrial Commission hearings via our network of attorneys.Said legal counsel will be directly representing and acting on behalf of the Client at Industrial Commission hearings. Fees incurred by legal representation will be the responsibility of the Client. Matrix will provide all documentation, notes, plans of action, and any other necessary information available to assigned legal counsel as preparation for the hearing;"
      move_down 10
      agreement_text 'To register legal counsel, it will be necessary for the Client employer to sign an R-1 card and file it with the Bureau of Workers’ Compensation or the Industrial Commission of Ohio. If requested by the Client, Matrix will assist in obtaining counsel, filing the R-1 card, and scheduling the attorney at I.C. hearing.  If the Client requests Matrix’s assistance in scheduling their representation, all fees related to representation will be billed separately by Matrix to Client.'
      move_down 10
      agreement_text 'III. Client Obligations', style: :bold
      move_down 5
      agreement_text 'Client hereby warrants and represents that (1) it has current, active workers’ compensation coverage pursuant to BWC standards; (2) it has completed its U-153 Group Retrospective Rating application designating Sponsoring Organization for enrollment purposes; and (3) it has not grossly misrepresented information on its U-153 application.  Furthermore:'
      move_down 2
      indent(15) do
        [
          'Client agrees that it is not a Professional Employer Organization/Leasing Company (PEO) not has a relationship with a PEO, and will refrain from acting as, or entering into a relationship with, a PEO during the term of this agreement.',
          'Client shall comply with all statutes, rules and regulations of the State of Ohio and accepts sole responsibility for understanding and complying with same',
          'Client shall not participate in programs prohibited by the BWC for the Group Retro Program',
          'Client shall not participate in the 100% EM Cap Program',
          'Client shall be a governing member of the Sponsoring Organization',
          'Client shall comply with any and all safety requirements set forth by the Sponsoring Organization and applicable O.A.C. regulations. Employer acknowledges that additional fees may be charged for certain safety services provided to Employer'
        ].each do |item|
          text_box "•", at: [0, cursor], size: 15
          move_down 1
          indent(15) do
            agreement_text item
          end
        end
      end
    end

    matrix_footer

    start_new_page

    matrix_header true, true
    current_cursor = cursor

    bounding_box([0, current_cursor], :width => half_width - (gutter_size / 2)) do
      [
        'Client is not a member of more than one Retro Group, or Retro or non-retro group rating plan',
        'Client shall provide to BWC and/or Sponsoring Organization any information required by the BWC to rule on the Group Retro application, and comply with the Sponsoring Organization’s Retro Group program policies and guidelines',
        'Client is responsible for making timely premium payments to the Ohio Bureau of Worker’s Compensation;',
        'Upon receipt, Client shall promptly forward all claim and policy related information to Matrix that pertains to Client’s workers’ compensation matters; including first reports of injury, supporting documentation, and any follow-up information it receives pertaining to a claim filed against it',
        'The Sponsoring Organization is authorized to elect a maximum premium ratio for the Retro Group Program.',
        'Client has no pending or completed merger, acquisition, or business reorganization which has not been communicated to Matrix prior to the signing of this agreement. Further the Client agrees to give Matrix written notice of any future mergers, acquisitions or reorganizations occurring during the course of this agreement. Actions of this nature could affect the Terms section of this agreement.'
      ].each do |item|
        text_box "•", at: [0, cursor], size: 15
        move_down 1
        indent(15) do
          agreement_text item
        end
      end
      move_down 5
      agreement_text 'In the event that Client does not comply with the preceding Client Obligations, the Client may be terminated by the Sponsoring Organization from the Group Retro Program, with BWC’s consent.'

      move_down 10
      agreement_text 'IV. Indemnification', style: :bold
      agreement_text 'Matrix agrees that services outlined in this agreement will be provided in a professional manner and that reasonable diligence will be employed in the performance of all of its contractual obligations. Matrix will not be liable to the Client for any damages caused by negligence or errors in the performance of its duties hereunder in excess of the amount of service fees paid by the Client. The Client agrees to indemnify and hold harmless Matrix and its successors, members, directors, employees, assigns, officials, and subsidiaries against any and all losses, damages, and expenses, including court costs and attorneys’ fees, resulting from or arising out of claims, demands or lawsuits, whether known or unknown, arising out of the terms and services of this Agreement.  Furthermore, Client agrees to be jointly and severally liable to Matrix and the Retro Group for premium payments and anyassessments related to the Retro Policy Year that is subject of this Agreement, even if such assessments are made by the BWC after the conclusion of the Retro Policy Year, and the Client is no longer a member of the Retro Group for which such assessments were made.'
    end

    stroke do
      vertical_line current_cursor, (bounds.bottom + 185), at: half_width + (gutter_size / 2)
    end

    bounding_box([half_width + (gutter_size * 2), current_cursor], :width => half_width - gutter_size) do
      agreement_text 'V. Terms', style: :bold
      move_down 5
      agreement_text "Matrix Claims Management, Inc. will provide the aforementioned services for the fee of <u>  #{price(@group_fees)}  </u> for the period stipulated at the top of this agreement. It is further understood that this agreement will renew for twelve months at the end of the initial service period and subsequent service periods, unless written notice, stating otherwise, is received, at least 90 days, prior to the end of the current service period. Fees for renewal periods will be adjusted to reflect cost inflation, Client activity and volume."
      move_down 10
      agreement_text 'Payment of the first year fees is due within 15 days of the initiation of this agreement. Subsequent years will be billed and are due as stipulated on the Matrix invoice. If payment is not received by Matrix as defined in this agreement, it is understood that all further Matrix services may be suspended and the agreement terminated at Matrix’s discretion.'
      move_down 10
      agreement_text "Client, if qualified, shall be eligible to participate in the program for the plan year #{@account.representative.quote_year_lower_date.strftime("%B%e, %Y")} to #{@account.representative.quote_year_upper_date.strftime("%B %e, %Y")}. This agreement is considered accepted and will commence upon Matrix’s receipt of the completed agreement and U-153 and will be effective through June 30 of the plan year. In the event the Client becomes ineligible for participation in the program, or the Group Sponsor and/or Matrix determines the Client is ineligible, payment received shall be applied to Client’s fee for all other administrative services as outlined in this agreement. If Client desires to withdraw from the program and requests a refund of monies paid, it is understood and accepted that the refunded amount will be prorated for services rendered less a $75 processing fee. Client may withdraw their enrollment up to the first Monday in January for that application year by submitting a written request to Matrix."
      move_down 10
      agreement_text 'In the event the Client becomes ineligible to participate in subsequent Group Retro Rating Program years, the aforementioned enumerated services will continue to be performed until such time as former Client renders written notice to the contrary at least 90 days prior to the expiration date of this agreement.'
      move_down 10
      agreement_text 'VI. Agreement Summation', style: :bold
      agreement_text 'This agreement constitutes the entire understanding between the parties concerning its subject matter and shall be governed by and construed in accordance with the laws of the State of Ohio. This agreement supersedes all prior written or oral agreements entered into by the parties. There are no other agreements or understandings between the parties, expressed or implied, written or oral, that is not reduced to writing herein.'
    end

    move_down 10
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
    require "open-uri"

    image_data = if @representative.signature.present?
                   { image: "#{Rails.env.development? ? "public/#{@representative.signature&.url}" : open(@representative.signature&.url)}", image_height: 15 }
                 else
                   ''
                 end

    [[{ content: '<b><u>Matrix Claims Management Inc.</u><b>', colspan: 2 }, '<b><u>Company Name:</u></b>', @account.name.titleize],
     ['By:', image_data, 'By:', ''],
     ['Printed:', @representative.president_full_name, 'Printed:', ''],
     ['Title:', 'CEO', 'Title:', ''],
     ['Date:', @current_date.strftime('%m/%d/%Y'), 'Date:', '']]
  end
end
