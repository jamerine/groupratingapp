class GenerateQuote
  include Sidekiq::Worker

  sidekiq_options queue: :generate_quote

  def perform(account_id)
    @account = Account.find(account_id)

    view_context = ActionView::Base.new()
    view_context.view_paths = ActionController::Base.view_paths
    view_context.class_eval do
      include Rails.application.routes.url_helpers
      include ApplicationHelper
    end
    if @account.group_rating_qualification == 'accept'
      @quote = Quote.new(account_id: @account.id, program_type: 'group_rating', fees: @account.group_fees, group_code: @account.group_rating_group_number, quote_tier: @account.group_rating_tier, quote_date: Date.current, effective_start_date: '2016-07-01', effective_end_date: '2017-06-30', status: 'quoted')
      @quote.save
      policy_year = @quote.effective_end_date.strftime("%Y")
      s = "#{@account.policy_number_entered}-#{policy_year}-#{@quote.id}"
      @quote.assign_attributes(invoice_number: s)
      pdf = GroupRatingQuote.new(@quote, @account, @account.policy_calculation, view_context)
      uploader = QuoteUploader.new
      tmpfile = Tempfile.new(["#{ @account.policy_number_entered }_quote_#{ @quote.id }", '.pdf'])
      tmpfile.binmode
      tmpfile.write (pdf.render)
      @quote.quote_generated = tmpfile
      tmpfile.close
      tmpfile.unlink
      @quote.save!
    end
    
    if @account.group_retro_qualification == 'accept'
      @quote = Quote.new(account_id: @account.id, program_type: 'group_retro', fees: @account.group_fees, group_code: @account.group_retro_group_number, quote_tier: @account.group_retro_tier, quote_date: Date.current, effective_start_date: '2016-07-01', effective_end_date: '2017-06-30', status: 'quoted')
      @quote.save
      policy_year = @quote.effective_end_date.strftime("%Y")
      s = "#{@account.policy_number_entered}-#{policy_year}-#{@quote.id}"
      @quote.assign_attributes(invoice_number: s)
      ###### CREATE A GROUP RETRO QUOTE ######
      # pdf = GroupRatingQuote.new(@quote, @account, @account.policy_calculation, view_context)
      # uploader = QuoteUploader.new
      # tmpfile = Tempfile.new(["#{ @account.policy_number_entered }_quote_#{ @quote.id }", '.pdf'])
      # tmpfile.binmode
      # tmpfile.write (pdf.render)
      # @quote.quote_generated = tmpfile
      # tmpfile.close
      # tmpfile.unlink
      @quote.save!
    end


  end
end
