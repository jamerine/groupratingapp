class GenerateQuoteProcess
  include Sidekiq::Worker

  sidekiq_options queue: :generate_quote_process

  def perform(representative_id, user)
    @representative = Representative.find(representative_id)
    current_user = user
    @accounts = @representative.accounts.all
    @current_date = Date.current

    @accounts.each do |account|
      GenerateQuote.perform_async(account.id)
    end
  end
end
