class GenerateQuoteProcess
  include Sidekiq::Worker

  sidekiq_options queue: :generate_quote_process

  def perform(representative_id, user, account_ids)
    @representative = Representative.find(representative_id)
    current_user = user
    @current_date = Date.current

    account_ids.each do |account_id|
      GenerateQuote.perform_async(account_id)
    end
  end
end
