class GenerateQuoteProcess
  include Sidekiq::Worker

  sidekiq_options queue: :generate_quote_process

  def perform(account_collection, user_id)
    @accounts = Account.find()
  end
end
