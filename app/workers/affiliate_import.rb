class AffiliateImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file

  def perform(affiliate_hash)

    representative = Representative.find_by(representative_number: affiliate_hash["representative_number"])
    account = Account.find_by(representative_id: representative.id, policy_number_entered: affiliate_hash["policy_number"] )

    if account
      @affiliate = Affiliate.create!(affiliate_hash.except("representative_number", "policy_number"))
      AccountsAffiliate.create!(affiliate_id: @affiliate.id, account_id: account.id)
    end

  end
end
