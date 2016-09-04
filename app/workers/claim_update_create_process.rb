class ClaimUpdateCreateProcess
  include Sidekiq::Worker

  sidekiq_options queue: :claim_update_create_process

  def perform(group_rating_id)
    FinalClaimCostCalculationTable.find_each do |claim|
        @policy_calculation= PolicyCalculation.find_by(policy_number: claim.policy_number, representative_number: claim.representative_number)
        unless @policy_calculation.nil?
            ClaimUpdateCreate.perform_async(
              claim.representative_number,
              claim.policy_type,
              claim.policy_number,
              @policy_calculation.id,
              claim.claim_number,
              claim.claim_injury_date,
              claim.claim_handicap_percent,
              claim.claim_handicap_percent_effective_date,
              claim.claim_manual_number,
              claim.claim_medical_paid,
              claim.claim_mira_medical_reserve_amount,
              claim.claim_mira_non_reducible_indemnity_paid,
              claim.claim_mira_reducible_indemnity_paid,
              claim.claim_mira_indemnity_reserve_amount,
              claim.claim_mira_non_reducible_indemnity_paid_2,
              claim.claim_total_subrogation_collected,
              claim.claim_unlimited_limited_loss,
              claim.policy_individual_maximum_claim_value,
              claim.claim_group_multiplier,
              claim.claim_individual_multiplier,
              claim.claim_group_reduced_amount,
              claim.claim_individual_reduced_amount,
              claim.claim_subrogation_percent,
              claim.claim_modified_losses_group_reduced,
              claim.claim_modified_losses_individual_reduced,
              claim.data_source
            )
        end
    end
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Claims Completed"
    @group_rating.save
  end
end
