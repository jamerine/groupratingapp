class QuoteImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file, retry: 1

  def perform(quote_hash)

    @representative = Representative.find_by(representative_number: quote_hash["representative_number"])
    @account = Account.find_by(representative_id: @representative.id, policy_number_entered: quote_hash["policy_number"] )

    if @account
      @quote = Quote.new(quote_hash.except("representative_number", "policy_number"))
      @quote.assign_attributes(account_id: @account.id)
      @quote.save
    end

  end
end
