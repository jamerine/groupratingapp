class ClaimUpdateCreateProcess
  include Sidekiq::Worker

  sidekiq_options queue: :claim_update_create_process

  def perform(group_rating_id)
    FinalClaimCostCalculationTable.find_each do |claim|
        @policy_calculation = PolicyCalculation.find_by(policy_number: claim.policy_number, representative_number: claim.representative_number)
        unless @policy_calculation.nil?
            ClaimUpdateCreate.perform_async(claim.id, @policy_calculation.id)
        end
    end
  end
end
