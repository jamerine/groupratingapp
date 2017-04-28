class GenerateQuote
  include Sidekiq::Worker

  sidekiq_options queue: :generate_quote

  def perform(account_id, ac_2, ac_26, contract, intro, invoice, questionnaire, quote)
    @account = Account.find(account_id)
    @representative = @account.representative
    @group_rating = @representative.group_ratings.last

    view_context = ActionView::Base.new()
    view_context.view_paths = ActionController::Base.view_paths
    view_context.class_eval do
      include Rails.application.routes.url_helpers
      include ApplicationHelper
    end

    if @account.group_rating_qualification == 'accept'
      @quote = Quote.new(account_id: @account.id, program_type: 'group_rating', (@account.fee_override.nil? ? @account.group_fees : @account.fee_override), group_code: @account.group_rating_group_number, quote_tier: @account.group_rating_tier, quote_date: Date.current, quote_sent_date: Date.current, experience_period_lower_date: @group_rating.experience_period_lower_date, experience_period_upper_date: @group_rating.experience_period_upper_date, current_payroll_period_lower_date: @group_rating.current_payroll_period_lower_date, current_payroll_period_upper_date: @group_rating.current_payroll_period_upper_date, current_payroll_year: @group_rating.current_payroll_year, program_year_lower_date: @group_rating.program_year_lower_date, program_year_upper_date: @group_rating.program_year_upper_date, program_year: @group_rating.program_year, quote_year_lower_date: @group_rating.quote_year_lower_date, quote_year_upper_date: @group_rating.quote_year_upper_date, quote_year: @group_rating.quote_year, status: 'quoted')
      @quote.save
      policy_year = @quote.quote_year
      s = "#{@account.policy_number_entered}-#{policy_year}-#{@quote.id}"
      @quote.assign_attributes(invoice_number: s)
      @policy_calculation = @account.policy_calculation

      combine_pdf = CombinePDF.new

      if intro == "1"
        intro_pdf = ArmIntro.new(@quote, @account, @policy_calculation, view_context)
        intro_pdf_render = intro_pdf.render
        combine_pdf << CombinePDF.parse(intro_pdf_render)
      end

      if quote == "1"
        quote_pdf = GroupRatingQuote.new(@quote, @account, @policy_calculation, view_context)
        quote_pdf_render = quote_pdf.render
        combine_pdf << CombinePDF.parse(quote_pdf_render)
      end

      if ac_26 == "1"
        ac_26_pdf = Ac26.new(@quote, @account, @policy_calculation, view_context)
        ac_26_pdf_render = ac_26_pdf.render
        combine_pdf << CombinePDF.parse(ac_26_pdf_render)
      end

      if ac_2 == "1"
        ac_2_pdf = Ac2.new(@quote, @account, @policy_calculation, view_context)
        ac_2_pdf_render = ac_2_pdf.render
        combine_pdf << CombinePDF.parse(ac_2_pdf_render)
      end

      if contract == "1"
        contract_pdf = ArmContract.new(@quote, @account, @policy_calculation, view_context)
        contract_pdf_render = contract_pdf.render
        combine_pdf << CombinePDF.parse(contract_pdf_render)
      end

      if questionnaire == "1"
        questionnaire_pdf = ArmQuestionnaire.new(@quote, @account, @policy_calculation, view_context)
        questionnaire_pdf_render = questionnaire_pdf.render
        combine_pdf << CombinePDF.parse(questionnaire_pdf_render)
      end

      if invoice == "1"
        invoice_pdf = ArmInvoice.new(@quote, @account, @policy_calculation, view_context)
        invoice_pdf_render = invoice_pdf.render
        combine_pdf << CombinePDF.parse(invoice_pdf_render)
      end

      # uploader = QuoteUploader.new
      tmpfile = Tempfile.new(["#{ @account.policy_number_entered }_quote_#{ @quote.id }", '.pdf'])
      tmpfile.binmode
      tmpfile.write(combine_pdf.to_pdf)
      @quote.quote_generated = tmpfile
      tmpfile.close
      tmpfile.unlink
      @quote.save!

    end

    # if @account.group_retro_qualification == 'accept'
    #   @quote = Quote.new(account_id: @account.id, program_type: 'group_retro', fees: @account.group_fees, group_code: @account.group_retro_group_number, quote_tier: @account.group_retro_tier, quote_date: Date.current, effective_start_date: '2016-07-01', effective_end_date: '2017-06-30', status: 'quoted')
    #   @quote.save
    #   policy_year = @quote.effective_end_date.strftime("%Y")
    #   s = "#{@account.policy_number_entered}-#{policy_year}-#{@quote.id}"
    #   @quote.assign_attributes(invoice_number: s)
    #   ###### CREATE A GROUP RETRO QUOTE ######
    #   # pdf = GroupRatingQuote.new(@quote, @account, @account.policy_calculation, view_context)
    #   # uploader = QuoteUploader.new
    #   # tmpfile = Tempfile.new(["#{ @account.policy_number_entered }_quote_#{ @quote.id }", '.pdf'])
    #   # tmpfile.binmode
    #   # tmpfile.write (pdf.render)
    #   # @quote.quote_generated = tmpfile
    #   # tmpfile.close
    #   # tmpfile.unlink
    #   @quote.save!
    # end


  end
end
