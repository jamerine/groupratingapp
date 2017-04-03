class DeleteQuoteProcess
  include Sidekiq::Worker

  sidekiq_options queue: :generate_quote_process

  def perform(representative_id)
    @representative = Representative.find(representative_id)
    @representative.accounts.find_each do |account|
      account.quotes.each do |quote|
        DeleteQuote.perform_async(quote.id)
      end
    end
  end
end
