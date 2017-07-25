class ArmGroupRetroContract < PdfReport
  def initialize(quote=[],account=[],policy_calculation=[],view)
    super()
    @quote = quote
    @account = account
    @policy_calculation = policy_calculation
    @view = view


    @group_fees =
      if @quote.fees.nil?
        0
      else
        @quote.fees
      end
   @current_date = DateTime.now.to_date
   contract

  end

  private

  def contract
    move_down 10
    text "OHIO WORKERS' COMPENSATION GROUP RETRO AGREEMENT", style: :bold, size: 10, align: :center
    move_down 10
    text "THIS AGREEMENT, effective, January 1, #{@account.representative.quote_year} by and between #{ @account.representative.company_name} (“TPA”) and #{ @account.name.titleize} (“Client”) with BWC policy number #{ @account.policy_number_entered }, is to set forth the terms and conditions relating to certain administrative and actuarial service functions to be performed by TPA on behalf of Client.", size: 9
    move_down 10
    text "Section 4123-17-23 of the Ohio Revised Code provides for employer group plans which pool and group the claims and premiums of individual employers for adjustment purposes. Client intends to enroll in a workers’ compensation group retro plan and #{@account.representative.company_name.upcase} is desirous of performing such services. #{@account.representative.company_name.upcase} is a consulting firm of workers’ compensation programs performing related administrative, actuarial, and claim services for its customers. Therefore Client and #{@account.representative.company_name.upcase}, in consideration of the mutual promises contained herein and other good and valuable consideration, do hereby contract and agree as follows.", size: 9
    move_down 10
    text "DUTIES AND OBLIGATIONS OF #{@account.representative.company_name.upcase}", style: :bold, size: 11
    move_down 3
    text "#{@account.representative.company_name.upcase} agrees to act as Client’s representative in the administration of the Client’s Group Retro participation. Such administrative services will include the following:", size: 9
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "1.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 15) do
      text "Actuarial services and advice considering all Ohio Bureau of Workers’ Compensation (“BWC”) relevant factors.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "2.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 15) do
      text "Provide Client as requested with separate reports of the Client’s workers’ compensation rates or status.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "3.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 15) do
      text "Continuing education and counseling regarding options available to the Client to improve workers’ compensation rates.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "4.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 25) do
      text "Retrospectively review the last six years of workers’ compensation claim data reported against the client and recommend claim cost reduction options on claims currently impacting the client's premium cost.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "5.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 35) do
      text "When requested, assist Client in the selection of a workers' compensation defense attorney and help the defense attorney investigate and prepare for any Industrial Commission of Ohio (“IC”) claim hearing. It is understood that the cost of such legal representation is not included in the fees outlined in this document.", size: 9
    end
    move_down 5
    text "REPRESENTATION OF CLIENT STANDARD SERVICES", style: :bold, size: 11
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "1.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 25) do
      text "#{@account.representative.company_name.upcase} shall assist the Client in the management of their workers’ compensation claims and advise on methods of cost control and claim reduction when appropriate.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "2.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 25) do
      text "#{@account.representative.company_name.upcase} shall consult with the Client on any changes in procedures produced by legislative or administrative revisions that impact the Client’s program.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "3.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 50) do
      text "When appropriate #{@account.representative.company_name.upcase} will arrange for attendance of a hearing representative on behalf of the Client for DHO hearings. #{@account.representative.company_name.upcase} will consult with the Client on all SHO hearings regarding hearing representation. Representation of the Client as is permissible under all applicable laws, including, without limitation, the rules and regulations of the Ohio Bureau of Workers’ Compensation (“BWC”) and the Industrial Commission of Ohio (“IC”) shall be provided by one of the following:", size: 9
    end
    current_cursor = cursor
    bounding_box([45, current_cursor], :width => 500, :height => 32) do
      text "A.	 An employee of #{@account.representative.company_name.upcase} may attend.", size: 9
      text "B.	 An Attorney chosen by #{@account.representative.company_name.upcase} may attend.", size: 9
      text "C.	 An Attorney chosen by the Client may attend at the client's option and cost.", size: 9
    end
    move_down 5
    text "Representations in Violations of State of Ohio Specific Safety Requirements, any other federal, state or local workplace violations, Actions into the Court of Common Pleas or Mandamus Actions into the Court of Appeals or any other actions beyond the BWC and IC are specifically excluded. ", size: 9
    move_down 5
    text "DUTIES AND OBLIGATIONS OF CLIENT", style: :bold, size: 12
    move_down 5
    text "Client must have active workers’ compensation coverage and be current on monies appropriately due to the BWC according to the following standards set forth by the relevant administrative rule.", size: 9
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "1.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 30) do
      text "These terms and conditions will automatically renew from year to year based on Client’s eligibility for Group Retro. The client will be billed the annual administration fee as quoted. Failure to pay this fee or any past monies may impact client eligibility for Group Retro.  Participation does not guarantee the Client the right to participate in the program in any subsequent Rating Year.", size: 9
    end
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "2.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 30) do
      text "The Client will comply with all statutes and regulations of the State of Ohio, whether currently in force or adopted in the future, that apply to the program, including but not limited to the Ohio BWC Group Retro rules (Ohio Administrative Code 4123-17-63). The Client accepts sole responsibility for understanding and complying with these rules.", size: 9
    end
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "3.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 45) do
      text "The Client understands that the group rate must be estimated in advance of the experience period and is based upon the most recent available experience period. The actual group rate will vary depending upon multiple factors. The Client is responsible for any assessments of premium owed to the Ohio BWC. In no event will #{@account.representative.company_name.upcase} or the Sponsoring Organization be held responsible for premiums or any additional monies owed by the Client to the Ohio BWC.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "4.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 15) do
      text "The Client shall distribute claim forms to employees and medical providers as necessary.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "5.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 25) do
      text "The Client shall submit to #{@account.representative.company_name.upcase} all claim applications, supporting documentation, and follow-up correspondence it receives pertaining to a claim filed against it.", size: 9
    end

    start_new_page

    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "6.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 53) do
      text "The Client shall promptly notify of any material changes in the operation of the Client , including, but not limited to, mergers, acquisitions or significant adjustments to the Client’s payroll (such as an adjustment that results in changing the program on Compensation Insurance (“NCCI”) classification under which the Client was accepted into the program). The Client will notify of any pending court cases particular to any workers’ compensation claim that has not been finally adjudicated or settled as of the 9/30/2017 survey date.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "7.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 25) do
      text "The Client shall implement risk management programs established by Trade Association under the Program for the purpose of reducing injuries and to comply with BWC rating requirements.", size: 9
    end
    current_cursor = cursor
    bounding_box([45, current_cursor], :width => 500, :height => 50) do
      text "A.	 All IC hearings will have legal counsel representation on behalf of the Client.", size: 9
      text "B.	 Client will be required to complete specific safety requirements such as salary continuation and/or transitional work for a minimum of 8 weeks.", size: 9
      text "C.	 All members must have a minimum of $5,000.00 in premium paid to the BWC.", size: 9
    end


    text "TERM AND TERMINATION", style: :bold, size: 11
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "1.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 125) do
      text "#{@account.representative.company_name.upcase} MAKES NO GUARANTEES, WARRANTIES, OR ASSURANCES REGARDING ANY PROJECTED FUTURE GROUP RATES ON CLIENTS’ BEHALF. Client acknowledges and understands that due to the timing of the application process, rating plan and year of the group plans, rates may change due to factors beyond #{@account.representative.company_name.upcase} and/or Client’s control. #{@account.representative.company_name.upcase} agrees to provide good faith estimates and projections concerning group rates that should provide reasonable basis for the Client’s decision making. Client acknowledges and agrees that the administrative and service fee is subject to change annually and that payment of administrative fee does not guarantee participation in the program. In the event Client becomes ineligible for group participation, payment received shall be applied to Client’s fee for all other administrative services as outlined in this agreement.  If Client desires to withdraw from this program and request a refund of monies paid, it is understood and accepted that the refunded amount will be prorated for services rendered plus a $75.00 processing fee. Client may withdraw their enrollment up to the first Monday in December  for that application year by submitting a written request to #{@account.representative.company_name.upcase}, #{@account.representative.mailing_address_1}, #{@account.representative.mailing_city}, #{@account.representative.mailing_state} #{@account.representative.mailing_zip_code}, including a self-addressed stamped envelope.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "2.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 35) do
      text "The initial term of this agreement will be for one year beginning on January 1, #{@account.representative.quote_year}. This agreement will automatically renew for additional one (1) year terms unless either party gives a 60 day notice prior to the termination date. Either party may terminate this agreement without penalty upon providing a 60 day notice to the other party.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "3.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 15) do
      text "The Fee is set at <b> #{price(@group_fees)} </b> and includes association dues.", size: 9, inline_format: true
    end
    move_down 3
    text "<b>Indemnification:</b> The Client agrees that #{@account.representative.company_name.upcase}, as the authorized agent for workers’ compensation claims, and their respective members, directors, employees, agents, affiliates, subsidiaries and successors and assigns shall not be liable for any awards, lawsuit damages, penalties, costs, expenses, or any other losses related to the Client’s workers’ compensation claims or coverage, and the Client shall indemnify and hold #{@account.representative.abbreviated_name.upcase} harmless on all such parties from and against any and all losses, claims, causes of action, actions, liabilities, damages, costs and expenses (including without limitation reasonable legal fees), whether known or unknown, arising from, in connection with, or pertaining in any way to such workers’ compensation claims or coverage. ", size: 9, inline_format: true
    move_down 10
    text "<b>Notices:</b> All notices and communications hereunder shall be addressed to the Client and #{@account.representative.abbreviated_name.upcase} at their current respective addresses or to such other addresses as either party may instruct.", size: 9, inline_format: true
    move_down 10
    text "<b>Accuracy of Information:</b> The Client acknowledges that #{@account.representative.abbreviated_name.upcase} accepts the accuracy of any information provided by Client through forms, payroll reports or other data submitted to #{@account.representative.abbreviated_name.upcase} or Ohio BWC.  Ohio BWC data is under sole control of Ohio BWC and #{@account.representative.abbreviated_name.upcase} has no liability and shall be held harmless for BWC inaccuracy or error.", size: 9, inline_format: true
    move_down 10
    text "<b>Waiver: </b> The failure of any party to this Agreement to object to, or take affirmative action with respect to, any conduct of the other which is in violation of the terms of this Agreement shall not be construed as a waiver thereof or of any future breach of subsequent wrongful conduct.", size: 9, inline_format: true
    move_down 10
    text "PROGRAM RULES", size: 11, style: :bold
    move_down 3
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "1.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 40) do
      text "Separate Risk Identity", size: 9
      text "Client and all other participants in the NEOSC Workers’ Compensation Group Retro Program (the “Program”) shall retain their separate risk identity, but shall be pooled and grouped, for RETROSPECTIVE rating purposes only, in order to achieve the purposes of the Program.", size: 9
    end
    move_down 3
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "2.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 500) do
      text "Representations", size: 9
      text "Client hereby represents and warrants that:", size: 9
      text "(a) Client acknowledges that by being a member of NEOSC, that NEOSC will sponsor and administer the Program through which Client will obtain workers’ compensation coverage;", size: 9
      text "(b) Client is a member or associate member in good standing of NEOSC and has applied for enrollment in the Program for the #{@account.representative.program_year} Rating Year;", size: 9
      text "(c) Client described within an industry group for which a group is in existence or is being formed under the Program in accordance with the criteria applied by the BWC;", size: 9
      text "(d) Client satisfies all criteria for participation in the Program required by Ohio law, including, without limitation, the requirements that: (i) it is not a member of any other group for the purpose of obtaining workers’ compensation coverage; (ii) it is current on any and all undisputed amounts owed to the BWC and due by the group retro application deadline, including premiums, partial payments, administrative costs, assessments, fines and any other monies otherwise due to any fund administered by the BWC, including amounts due for retrospective rating; (iii) it does not have any unpaid audit findings or any other unpaid billings relating to workers’ compensation;(iv) it does not have cumulative lapses in workers’ compensation coverage in excess of forty (40) days within the last twelve (12) months prior to group application deadline; and (v) it has active Ohio workers’ compensation coverage;", size: 9
    end
    start_new_page
    current_cursor = cursor
    bounding_box([30, current_cursor], :width => 520, :height => 100) do
      text "(e) Client has advised the administrator of any combination with another business through the purchase of assets, a merger, a consolidation or in any other manner that has occurred within the past five years;", size: 9
      text "(f) It has advised #{@account.representative.abbreviated_name.upcase} of any existing or pre-existing relationships with any employee leasing or professional employer organization (“PEO”) (as that term is defined under the BWC rules or other laws or regulations that govern workers’ compensation activities in Ohio), as determined by the Program under applicable BWC rules or other relevant law or regulations within the past five years;", size: 9
      text "(g) Client provided claim and payroll breakdowns, as requested; and", size: 9
      text "(h) Client understands it must remain in compliance with any other criteria established by the Program and the BWC rules and regulations in order to continue in the Program.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "3.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 50) do
      text "Claims Management", size: 9
      text "(a) Client shall provide either wage continuation or transitional work for a minimum of 8 weeks for any lost time claim.", size: 9
      text "(b) Client may be required to agree to independent medical exams for the benefit of the Program", size: 9
      text "(c) Client shall agree to any BWC Lump Sum Settlement of a claim that is deemed to be of benefit to the Program.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "4.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 25) do
      text "Safety Program", size: 9
      text "Client either has or intends to have a safety program compliant with program questionnaire.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "5.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 40) do
      text "Program restrictions", size: 9
      text "No employer may leave the Program once accepted and approved. Restriction applies to any voluntary withdrawal, leasing or contracting with a PEO. ", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "6.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 90) do
      text "Employer Data", size: 9
      text "The Client shall promptly notify of any material changes in the operation of the Client, including, but not limited to, mergers, acquisitions or significant adjustments to the Client’s payroll (such as an adjustment that results in changing the National Council on Compensation Insurance (“NCCI”) classification under which the Client was accepted into the Program). The Client will notify of any pending court cases particular to any workers’ compensation claim that has not been finally adjudicated or settled as of the 9/30/2017 survey date. In addition, the Client shall promptly provide other information in such form as is reasonably requested and otherwise reasonably cooperate with #{@account.representative.abbreviated_name.upcase} and NEOSC in the operation, administration and furtherance of the purposes of the Program.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "7.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 130) do
      text "Approval", size: 9
      text "#{@account.representative.abbreviated_name.upcase} taking into account actuarial and other pertinent data, shall review each application to participate in the Program and shall determine whether to accept the applicant into the Program for the applicable rating year. For each rating year that NEOSC and #{@account.representative.abbreviated_name.upcase} determine to continue the Program, the Program shall file or cause to be filed an application to the BWC for each group (“Bureau Application”) in order to obtain the necessary Bureau approval for such group. All applicants that have been approved by NEOSC for participation in a group for a Rating Year shall be included in that year’s BWC Application for such group.
  		The Program and the participating employers are subject to acceptance and approval by the BWC. NEOSC nor #{@account.representative.abbreviated_name.upcase} and the Program shall not have any liability to Client in the event that the BWC declares that the Program, or any group proposed for inclusion in the Program or any client does not meet the necessary eligibility requirements of the BWC, thereby preventing Client from participating in the Program.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "8.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 130) do
      text "Program and Bureau Rules", size: 9
      text "The Program shall operate on a rating year basis (July 1 through June 30). Each client desiring to enter the Program must submit an application to the Program. If a client is accepted into the Program, thereafter such client’s eligibility shall be reviewed annually and participation in the Program for the current or any prior rating year does not guarantee the Client the right to participate in the Program in any subsequent Rating Year.
  		The Client hereby: (a) adopts, accepts and agrees to be bound by all of the terms and provisions of the Program rules; (b) agrees to abide by all of the rules and regulations of the BWC; (c) acknowledges that its participation in the Program is subject to the terms and conditions of the Program Rules and the BWC rules and regulations; and (d) acknowledges and agrees that its participation in the Program may be terminated because of Client’s failure to comply with the Program Rules or any rules or regulations of the BWC and that in event of any such termination, no one of the Program, the Coordinator, or NEOSC shall have any liability or further obligation whatsoever to Client.", size: 9
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 30, :height => 15) do
      text "9.", indent_paragraphs: 15, size: 9
    end
    bounding_box([30, current_cursor], :width => 520, :height => 30) do
      text "Accuracy of Information", size: 9
      text "The Client acknowledges that #{@account.representative.abbreviated_name.upcase} and NEOSC have no obligation to verify the accuracy of any information contained in the Client’s enrollment form, payroll reports or other data submitted to the Program.", size: 9
    end
    move_down 5
    start_new_page
    text "ENTIRE AGREEMENT", size: 11, style: :bold
    move_down 3
    text "This agreement and the written statements and representations made by or on behalf of the parties in connection herewith, represent the entire agreement and understanding among the parties, and supersede all other negotiations by and among such parties with respect to this subject matter hereof. The agreement may not be amended or modified except in writing signed by all of the parties. The parties specifically acknowledge that in the event the Client qualifies for the Group Retro Program a separate Group Retro contract will be executed among the parties as to the Group Retro Program that controls the duties of the parties only as to that issue. There are no other agreements or understandings among the parties, expressed or implied, written or oral, that are not reduced to writing herein.", size: 9
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 250, :height => 200) do
      stroke do
        text_box "TPA:", :at => [0, 175], :width => 50, height: 40, style: :bold
        text_box "#{@account.representative.company_name}", :at => [50, 175], :width => 175, height: 40, style: :bold, align: :center
        horizontal_line 50, 225, :at => 160
        text_box "By:", :at => [0, 135], :width => 50, height: 40, style: :bold
        image "#{Rails.root}/app/assets/images/Doug's signature.jpg", :at => [100, 147], height: 45
        horizontal_line 50, 225, :at => 120
        text_box "Name/Title:", :at => [0, 95], :width => 275, height: 40, style: :bold
        text_box "Doug Maag - President", :at => [50, 95], :width => 175, height: 40, style: :bold, align: :center
        horizontal_line 50, 225, :at => 80
        text_box "Date:", :at => [0, 55], :width => 275, height: 40, style: :bold
        text_box "#{@current_date.strftime("%B %e, %Y")}", :at => [50, 55], :width => 175, height: 40, style: :bold, align: :center
        horizontal_line 50, 225, :at => 40
      end
      # text_box "/TPA", :at => [0, 175], :width => 275, height: 25, style: :bold
      # text_box "By:      Signature", :at => [0, 150], :width => 275, height: 25, style: :bold
      # text_box "Name: Doug Maag", :at => [0, 125], :width => 275, height: 25, style: :bold
      # text_box "Date: #{@current_date.strftime("%B %e, %Y")}", :at => [0, 100], :width => 275, height: 25, style: :bold
    end
    bounding_box([250, current_cursor], :width => 300, :height => 200) do
      stroke do
        text_box "Account:", :at => [0, 175], :width => 50, height: 40, style: :bold
        text_box "#{@account.name.titleize} - #{@account.policy_number_entered}-0", :at => [50, 175], :width => 250, height: 40, style: :bold, align: :center
        horizontal_line 75, 300, :at => 160
        text_box "Signature:", :at => [0, 135], :width => 250, height: 40, style: :bold
        horizontal_line 75, 300, :at => 120
        text_box "Name/Title:", :at => [0, 95], :width => 250, height: 40, style: :bold
        horizontal_line 75, 300, :at => 80
        text_box "Date:", :at => [0, 55], :width => 250, height: 40, style: :bold
        horizontal_line 75, 300, :at => 40
      end
    end



  end

end
