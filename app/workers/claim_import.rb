class ClaimImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file

  def perform(claim_hash)

    representative = Representative.find_by(representative_number: claim_hash["representative_number"])
    account        = Account.find_by(representative_id: representative.id, policy_number_entered: claim_hash["policy_number"])

    if account
      policy_calculation = PolicyCalculation.find_by(account_id: account.id)

      if policy_calculation
        @claim_calculation = ClaimCalculation.where(representative_number: representative.representative_number, policy_number: policy_calculation.policy_number, policy_calculation_id: policy_calculation.id, data_source: 'user', claim_number: "#{claim_hash['claim_number'] }").update_or_create(claim_hash.except("representative_number", "policy_number", "claim_number"))
        @claim_calculation.calculate_unlimited_limited_loss
        @claim_calculation.recalculate_experience(policy_calculation.policy_maximum_claim_value) if @claim_calculation.save!
      end
    end
  end
end
