class AccountImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file

  def perform(hash)

    @representative = Representative.find_by(representative_number: hash["representative_number"])
    @account = Account.find_by(representative_id: @representative.id, policy_number_entered: hash["policy_number"] )

    if @account
      @account.update_attributes(hash.except("representative_number", "policy_number"))
    end

  end
end
