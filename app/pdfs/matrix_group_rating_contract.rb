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
    text "<u><b>  #{@account.name.titleize}, #{@account.policy_number_entered}  </b></u>, (“Client”) for the period beginning on <u><b>  #{@account.tpa_from_date.strftime('%m/%d/%Y')}  </b></u> and ending on <u><b>  #{@account.tpa_to_date.strftime('%m/%d/%Y')}  </b></u> and to renew as stipulated in this agreement.", inline_format: true, size: 10
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
      agreement_text "Matrix Claims Management, Inc. will provide the aforementioned services for the fee of <u>  #{@group_fees}  </u> for the period stipulated at the top of this agreement. It is further understood that this agreement will renew for twelve months at the end of the initial service period and subsequent service periods, unless written notice, stating otherwise, is received, at least 90 days, prior to the end of the current service period. Fees for renewal periods will be adjusted to reflect cost inflation, Client activity and volume."
      move_down 12
      agreement_text 'Payment of the first year fees is due within 15 days of the initiation of this agreement. Subsequent years will be billed and are due as stipulated on the Matrix invoice. If payment is not received by Matrix as defined in this agreement, it is understood that all further Matrix services may be suspended and the agreement terminated at Matrix’s discretion.'
    end

    stroke do
      vertical_line current_cursor, (bounds.bottom + 185), at: half_width + (gutter_size / 2)
    end

    bounding_box([half_width + (gutter_size * 2), current_cursor], :width => half_width - gutter_size) do
      move_down 15
      agreement_text "Client, if qualified, shall be eligible to participate in the program for the plan year July 1, #{@representative.quote_year_lower_date.year} to June 30, #{@representative.quote_year_upper_date.year}. This agreement is considered accepted and will commence upon Matrix’s receipt of the completed agreement and AC-26 and will be effective through June 30 of the plan year. In the event the Client becomes ineligible for participation in the program, or the Group Sponsor and/or Matrix determines the Client is ineligible, payment received shall be applied to Client’s fee for all other administrative services as outlined in this agreement. If Client desires to withdraw from the program and requests a refund of monies paid, it is understood and accepted that the refunded amount will be prorated for services rendered less a $75 processing fee. Client may withdraw their enrollment up to the first Monday in January for that application year by submitting a written request to Matrix."
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

    # text "THIS AGREEMENT, effective, December 1, #{@account.representative.program_year} by and between #{ @account.representative.company_name} (“TPA”) and #{ @account.name.titleize} (“Client”) with BWC policy number #{ @account.policy_number_entered }, is to set forth the terms and conditions relating to certain administrative and actuarial service functions to be performed by TPA on behalf of Client.", size: 9
    # move_down 10
    # text "Section 4123.29 of the Ohio Revised Code provides for employer group plans which pool and group the experience of individual employers for rating purposes. Client intends to enroll in a workers’ compensation group rating plan and TPA is desirous of performing such services. TPA is a consulting firm of workers’ compensation programs performing related administrative, actuarial, and claim services for its customers. Therefore, Client and TPA, in consideration of the mutual promises contained herein and other good and valuable consideration, do hereby contract and agree as follows.", size: 9
    # move_down 10
    # text "DUTIES AND OBLIGATIONS OF TPA", style: :bold, size: 11
    # move_down 3
    # text "TPA agrees to act as Client’s representative in the administration of the Client’s Ohio workers’ compensation and Group Rating participation.  Such administrative services will include the following:", size: 9
    # move_down 5
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "1.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 15) do
    #   text "Actuarial services and advice considering all Ohio Bureau of Workers’ Compensation (“BWC”) relevant factors.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "2.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 15) do
    #   text "Provide Client as requested with separate reports of the Client’s workers’ compensation rates or status.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "3.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 15) do
    #   text "Continuing education and counseling regarding options available to the Client to improve workers’ compensation rates.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "4.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 25) do
    #   text "Retrospectively review the last six years of Workers’ Compensation claim data reported against the client and recommend claim cost reduction options on claims currently impacting the clients premium cost.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "5.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 35) do
    #   text "When requested, assist the client in the selection of a Workers' Compensation defense attorney and help the defense attorney investigate and prepare for any Industrial Commission of Ohio (“IC”) claim hearing. It is understood that the cost of such legal representation is not included in the fees outlined in this document.", size: 9
    # end
    # move_down 5
    # text "REPRESENTATION OF CLIENT", style: :bold, size: 11
    # move_down 5
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "1.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 15) do
    #   text "Consult with Client on any changes in procedures produced by legislative or administrative revisions that impact Client.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "2.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 25) do
    #   text "Assist Client in the management of their workers’ compensation claims and advise on methods of cost control and claim reduction when appropriate.  Management of the claim cost and work related disabilities until case closure.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "3.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 15) do
    #   text "Consult with Client on any changes in procedures produced by legislative or administrative revisions that impact Client’s program.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "4.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 32) do
    #   text "When appropriate arrange for attendance of a Hearing Representative on behalf of client at hearings before the Ohio Bureau of BWC and the IC. Representation of Client as is permissible under all applicable laws, including, without limitation, the rules and regulations of the BWC and IC shall be provided by one of the following:", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([45, current_cursor], :width => 500, :height => 15) do
    #   text "A.	 An employee of TPA may attend", size: 9
    # end
    # text "Representations in Violations of State of Ohio Specific Safety Requirements, any other federal, state or local workplace violations, Actions into the Court of Common Pleas or Mandamus Actions into the Court of Appeals or any other actions beyond the BWC and IC are specifically excluded.", size: 9
    # move_down 5
    # text "DUTIES AND OBLIGATIONS OF CLIENT", style: :bold, size: 12
    # move_down 5
    # text "Client must have active workers’ compensation coverage and be current on monies appropriately due to the BWC according to the following standards set forth by the relevant administrative rule.", size: 9
    # move_down 5
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "1.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 30) do
    #   text "These terms and conditions will automatically renew from year to year so long as the client remains eligible for Group Rating. Client will be billed the annual administration fee as quoted. Failure to pay this fee or any past monies may impact client eligibility for group rating. Participation does not guarantee Client the right to participate in the Program in any subsequent Rating Year.", size: 9
    # end
    # move_down 5
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "2.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 50) do
    #   text "Client will comply with all statutes and regulations of the State of Ohio, whether currently in force or adopted in the future, that apply to the Program, including but not limited to the BWC group rating rules (Ohio Administrative Code 4123-17-61 through 4123-17-68.)  Client accepts sole responsibility for understanding and complying with these rules. TPA and the Program shall not have any liability to Client in the event that the BWC declares that the Program or Client does not meet necessary eligibility requirements.", size: 9
    # end
    # move_down 5
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "3.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 65) do
    #   text "Client understands that the group rate must be estimated in advance of the experience period and is based upon the most recent available experience period.  The actual group rate will vary depending upon multiple factors.  Client is responsible for any assessments of premium owed to the BWC.  In no event will TPA or the Sponsoring Organization be held responsible for premiums or any additional monies owed by Client to the BWC.  Client shall distribute claim forms to employees and medical providers as necessary. Client shall submit to TPA all claim applications, supporting documentation, and follow-up correspondence it receives pertaining to a claim filed against it.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "4.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 45) do
    #   text "Client shall promptly notify of any material changes in the operation of the Employer, including, but not limited to, mergers, acquisitions or significant adjustments to Client’s payroll (such as an adjustment that results in changing the BWC manual classification under which Client was accepted into the Program). Client will notify of any pending court cases particular to any workers’ compensation claim that have not been finally adjudicated or settled as of the 9/30/#{@account.representative.program_year} survey date.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "5.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 25) do
    #   text "Client shall implement risk management programs established by Sponsor under the Program for the purpose of reducing injuries and to comply with BWC Group Rating Requirements.", size: 9
    # end
    #
    # start_new_page
    #
    # text "TERM AND TERMINATION", style: :bold, size: 11
    # move_down 5
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "1.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 120) do
    #   text "TPA MAKES NO GURANTEES, WARRANTIES, OR ASSURANCES REGARDING ANY PROJECTED FUTURE GROUP RATES ON CLIENTS’ BEHALF.  Client acknowledges and understands that due to the timing of the application process and rating plan, year of the group plans, rates may change due to factors beyond TPA and/or Client’s control.   TPA agrees to provide good faith estimates and projections concerning group rates that should provide reasonable basis for client’s decision making.  Client acknowledges and agrees that the administrative and service fee is subject to change annually and that payment of administrative fee does not guarantee participation in the Program.  In the event Client becomes ineligible for group participation, payment received shall be applied to Client’s fee for all other administrative services as outlined in this agreement.   If Client desires to withdraw from this Program and request a refund of monies paid, it is understood and accepted that the refunded amount will be prorated for services rendered and at least one-half the annual fee is non-refundable.  Client may withdraw their enrollment up to the first Monday in October for that application year by submitting a written request to #{@account.representative.abbreviated_name}, P.O. Box 880, Hilliard, Ohio  43026, including a self-addressed stamped envelope.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "2.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 35) do
    #   text "The initial term of this agreement will be from December 1, #{@account.representative.program_year} through March 31, #{@account.representative.quote_year_upper_date.strftime("%Y")}. This agreement will automatically renew for additional one (1) year terms unless either party gives the other notice at least 21 days prior to the termination date.  Either party may terminate this agreement without penalty upon providing a 21 day notice to the other party.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "3.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 15) do
    #   text "The Annual Fee is <b> #{price(@group_fees)} </b> and includes Northeast Ohio Safety Council (“NEOSC”) dues.", size: 9, inline_format: true
    # end
    # move_down 3
    # text "INDEMNIFICATION", style: :bold, size: 11
    # move_down 3
    # text "Client agrees that TPA, are the authorized agent for Workers’ Compensation claims,  and their respective members, directors, employees, agents, affiliates, subsidiaries and successors and assigns shall not be liable for any awards, lawsuit damages, penalties, costs, expenses, or any other losses related to the employer’s Workers’ Compensation claims or coverage, and Client  shall indemnify and hold harmless all such parties from and against any and all losses, claims, causes of action, actions, liabilities, damages, costs and expenses (including without limitation reasonable legal fees), whether known or unknown, arising from, in connection with, or pertaining in any way to such workers’ compensation claims or coverage.", size: 9
    # move_down 3
    # text "NOTICES", style: :bold, size: 11
    # move_down 3
    # text "All notices and communications hereunder shall be addressed to the Client and TPA at their current respective addresses or to such other addresses as either party may instruct.", size: 9
    # move_down 3
    # text "ACCURACY OF INFORMATION", style: :bold, size: 11
    # text "Client acknowledges that TPA accepts the accuracy of any information provided by Client through forms, payroll reports or other data submitted to TPA or BWC.   BWC data is under sole control of BWC and TPA has no liability and shall be held harmless for BWC inaccuracy or error, especially but not limited to the assignment of manual classification.", size: 9
    # move_down 3
    # text "WAIVER", size: 11, style: :bold
    # move_down 3
    # text "The failure of any party to this Agreement to object to, or take affirmative action with respect to, any conduct of the other which is in violation of the terms of this Agreement shall not be construed as a waiver thereof or of any future breach of subsequent wrongful conduct."
    # move_down 3
    # text "PROGRAM RULES", size: 11, style: :bold
    # move_down 3
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "1.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 40) do
    #   text "Separate Risk Identity", size: 9
    #   text "Client and all other participants in the NEOSC Workers’ Compensation Group Rating Program (the “Program”) shall retain their separate risk identity, but shall be pooled and grouped, for experience rating purposes only, in order to achieve the purposes of the Program.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "2.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 250) do
    #   text "Representations", size: 9
    #   text "Client hereby represents and warrants that:", size: 9
    #   text "It acknowledges that by being a member of NEOSC, that NEOSC will sponsor and administer the Program through which Client will obtain workers’ compensation coverage;", size: 9
    #   text "It is a member or associate member in good standing of NEOSC and has applied for enrollment in the Program for the #{@account.representative.quote_year} Rating Year;", size: 9
    #   text "It is described within an industry group for which a group is in existence or is being formed under the Program in accordance with the criteria applied by the BWC;", size: 9
    #   text "It satisfies all criteria for participation in the Program required by Ohio law, including, without limitation, the requirements that: (i) it is not a member of any other group for the purpose of obtaining workers’ compensation coverage; (ii) it is current on any and all undisputed amounts owed to the Bureau and due by the group rating application deadline, including premiums, partial payments, administrative costs, assessments, fines and any other monies otherwise due to any fund administered by the Bureau, including amounts due for retrospective rating; (iii) it does not have any unpaid audit findings or any other unpaid billings relating to workers’ compensation;(iv) it does not have cumulative lapses in workers’ compensation coverage in excess of forty (40) days within the last eighteen (18) months prior to a group rating application deadline; and (v) it is in an active status for workers’ compensation premium purposes; It has advised the administrator of any combination with another business through the purchase of assets, a merger, a consolidation or in any other manner that has occurred within the past five years;", size: 9
    #   text "It has advised NEOSC of any existing or pre-existing relationships with any employee leasing or professional employer organization (“PEO”) (as that term is defined under BWC rules or other laws or regulations that govern workers’ compensation activities in Ohio), as determined by the Program under applicable BWC rules or other relevant law or regulations within the past five years;", size: 9
    #   text "It provided claim and payroll breakdowns, as requested; and", size: 9
    #   text "It understands it must remain in compliance with any other criteria established by the Program and BWC rules and regulations in order to continue in the Program.", size: 9
    # end
    #
    # start_new_page
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "3.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 75) do
    #   text "Client Data", size: 9
    #   text "Client shall promptly notify of any material changes in the operation of the Employer, including, but not limited to, mergers, acquisitions or significant adjustments to the Client’s payroll (such as an adjustment that results in changing the National Council on Compensation Insurance (“NCCI”) classification under which Client was accepted into the Program). Client will notify of any pending court cases particular to any workers’ compensation claim that has not been finally adjudicated or settled as of the 09/30/#{@account.representative.program_year} survey date. In addition, Client shall promptly provide such other information in such form as is reasonably requested and otherwise reasonably cooperate with NEOSC in the operation, administration and furtherance of the purposes of the Program.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "4.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 110) do
    #   text "Approval", size: 9
    #   text "NEOSC, taking into account actuarial and other pertinent data, shall review each application to participate in the Program and shall determine whether to accept the applicant into the Program for the applicable Rating Year. For each Rating Year that NEOSC determines to continue the Program, the Program shall file or cause to be filed an application to the BWC for each group (“Bureau Application”) in order to obtain the necessary BWC approval for such group. All applicants that have been approved by NEOSC for participation in a group for a Rating Year shall be included in that year’s Bureau Application for such group.", size: 9
    #   text "The Program and the participating Employers are subject to acceptance and approval by the BWC. TPA, NEOSC and the Program shall not have any liability to an Employer in the event that the BWC declares that the Program, or any group proposed for inclusion in the Program or any Employer does not meet the necessary eligibility requirements of the BWC, thereby preventing an Employer from participating in the Program.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "5.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 120) do
    #   text "Program and Bureau Rules", size: 9
    #   text "The Program shall operate on a Rating Year basis (July 1 through June 30). Each Employer desiring to enter the Program must submit an application to the Program. If an Employer is accepted into the Program, thereafter such Employer’s eligibility shall be reviewed annually and participation in the Program for the current or any prior Rating Year does not guarantee Client’s right to participate in the Program in any subsequent Rating Year.", size: 9
    #   text "Client hereby: (a) adopts, accepts and agrees to be bound by all of the terms and provisions of the Program Rules; (b) agrees to abide by all of the rules and regulations of the BWC; (c) acknowledges that its participation in the Program is subject to the terms and conditions of the Program Rules and the BWC rules and regulations; and (d) acknowledges and agrees that its participation in the Program may be terminated because of Client’s failure to comply with the Program Rules or any rules or regulations of the BWC, and, that in event of any such termination, no one of the Program, the Coordinator, TPA, or NEOSC shall have any liability or further obligation whatsoever to Client.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "6.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 90) do
    #   text "Client Payments upon Certain Events", size: 9
    #   text "If (i) any representation made by Client in Section 1.2 hereof is untrue, (ii) Client combines with another business through the purchase of assets, a merger, a consolidation or in any other manner, or (iii) there are significant adjustments to the Client’s payroll that result in changing the NCCI classification under which the Client was accepted into the Program, and as a result of such misrepresentation, combination or adjustment additional premiums are imposed for any Rating Year on the other employers that are part of the same group as Client, Client will pay to a fund held by NEOSC or its designated agent an amount equal to such additional premiums. Upon receipt of such amount, NEOSC or its agent will distribute such amount on an equitable basis among those employers within the applicable group that paid such additional premiums for the applicable Rating Year.", size: 9
    # end
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 30, :height => 15) do
    #   text "7.", indent_paragraphs: 15, size: 9
    # end
    # bounding_box([30, current_cursor], :width => 520, :height => 30) do
    #   text "Accuracy of Information", size: 9
    #   text "Client acknowledges that TPA and NEOSC have no obligation to verify the accuracy of any information contained in Client’s enrollment form, payroll reports or other data submitted to the Program.", size: 9
    # end
    # move_down 5
    # text "ENTIRE AGREEMENT", size: 11, style: :bold
    # move_down 3
    # text "This Agreement and the written statements and representations made by or on behalf of the Parties in connection herewith, represent the entire agreement and understanding among the Parties, and supersede all other negotiations by and among such Parties with respect to this subject matter hereof.  The Agreement may not be amended or modified except in writing signed by all of the Parties.  The Parties specifically acknowledge that in the event Client qualifies for the Group Rating Program, a separate Group Rating Contract will be executed among the Parties as to the Group Rating Program that controls the duties of the Parties only as to that issue.  There are no other agreements or understandings among the Parties, express or implies, written or oral, that are not reduced to writing herein.", size: 9
    # move_down 5
    # current_cursor = cursor
    # bounding_box([0, current_cursor], :width => 250, :height => 200) do
    #   stroke do
    #     text_box "TPA:", :at => [0, 175], :width => 50, height: 40, style: :bold
    #     text_box "#{@account.representative.abbreviated_name}", :at => [50, 175], :width => 175, height: 40, style: :bold, align: :center
    #     horizontal_line 50, 225, :at => 160
    #     text_box "By:", :at => [0, 135], :width => 50, height: 40, style: :bold
    #     image "#{Rails.root}/app/assets/images/Doug's signature.jpg", :at => [100, 147], height: 45
    #     horizontal_line 50, 225, :at => 120
    #     text_box "Name/Title:", :at => [0, 95], :width => 275, height: 40, style: :bold
    #     text_box "Doug Maag - President", :at => [50, 95], :width => 175, height: 40, style: :bold, align: :center
    #     horizontal_line 50, 225, :at => 80
    #     text_box "Date:", :at => [0, 55], :width => 275, height: 40, style: :bold
    #     text_box "#{@current_date.strftime("%B %e, %Y")}", :at => [50, 55], :width => 175, height: 40, style: :bold, align: :center
    #     horizontal_line 50, 225, :at => 40
    #   end
    #   # text_box "/TPA", :at => [0, 175], :width => 275, height: 25, style: :bold
    #   # text_box "By:      Signature", :at => [0, 150], :width => 275, height: 25, style: :bold
    #   # text_box "Name: Doug Maag", :at => [0, 125], :width => 275, height: 25, style: :bold
    #   # text_box "Date: #{@current_date.strftime("%B %e, %Y")}", :at => [0, 100], :width => 275, height: 25, style: :bold
    # end
    # bounding_box([250, current_cursor], :width => 300, :height => 200) do
    #   stroke do
    #     text_box "Account:", :at => [0, 175], :width => 50, height: 40, style: :bold
    #     text_box "#{@account.name.titleize} - #{@account.policy_number_entered}-0", :at => [50, 175], :width => 250, height: 40, style: :bold, align: :center
    #     horizontal_line 75, 300, :at => 160
    #     text_box "Signature:", :at => [0, 135], :width => 250, height: 40, style: :bold
    #     horizontal_line 75, 300, :at => 120
    #     text_box "Name/Title:", :at => [0, 95], :width => 250, height: 40, style: :bold
    #     horizontal_line 75, 300, :at => 80
    #     text_box "Date:", :at => [0, 55], :width => 250, height: 40, style: :bold
    #     horizontal_line 75, 300, :at => 40
    #   end
    # end
  end

  def contract_table_data
    [[{ content: '<b><u>Matrix Claims Management Inc.</u><b>', colspan: 2 }, '<b><u>Company Name:</u></b>', @account.name],
     ['By:', '', 'By:', ''],
     ['Printed:', @representative.president_full_name, 'Printed:', ''],
     ['Title:', 'CEO', 'Title:', ''],
     ['Date:', @current_date.strftime('%m/%d/%Y'), 'Date:', '']]
  end
end
