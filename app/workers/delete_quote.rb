class DeleteQuote
  include Sidekiq::Worker

  sidekiq_options queue: :delete_quote

  def perform(quote_id)
    @quote = Quote.find(quote_id)
    @quote.remove_quote_generated!
    @quote.destroy
  end
end
