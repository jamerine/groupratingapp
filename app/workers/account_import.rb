class AccountImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file

  def perform(hash)

    @representative = Representative.find_by(representative_number: hash["representative_number"])
    @account = Account.find_by(representative_id: @representative.id, policy_number_entered: hash["policy_number"] )

    if @account
      @account.update_attributes(hash.except("representative_number", "policy_number"))
    else
      @account = Account.new(representative_id: @representative.id, policy_number_entered: hash["policy_number"])
      @account.assign_attributes(hash.except("representative_number", "policy_number"))
      @account.save
      @policy_calculation = PolicyCalculation.where(account_id: @account.id).update_or_create(
          representative_number: @representative.representative_number,
          policy_number: @account.policy_number_entered,
          representative_id: @account.representative_id,
          account_id: @account.id
          )
    end

  end
end
