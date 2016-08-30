class ClaimUpdateCreate
  @queue = :claim_update_create

  def self.perform(group_rating_id)
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Claims Updating"
    @group_rating.save
    FinalClaimCostCalculationTable.find_each do |claim|
        @policy_calculation = PolicyCalculation.find_by(policy_number: claim.policy_number, representative_number: claim.representative_number)
        unless @policy_calculation.nil?
          ClaimCalculation.where(
          policy_number: claim.policy_number,
          claim_number: claim.claim_number,
          representative_number: claim.representative_number).update_or_create(
              representative_number: claim.representative_number,
              policy_type: claim.policy_type,
              policy_number: claim.policy_number,
              policy_calculation_id: @policy_calculation.id,
              claim_number: claim.claim_number,
              claim_injury_date: claim.claim_injury_date,
              claim_handicap_percent: claim.claim_handicap_percent,
              claim_handicap_percent_effective_date: claim.claim_handicap_percent_effective_date,
              claim_manual_number: claim.claim_manual_number,
              claim_medical_paid: claim.claim_medical_paid,
              claim_mira_medical_reserve_amount: claim.claim_mira_medical_reserve_amount,
              claim_mira_non_reducible_indemnity_paid: claim.claim_mira_non_reducible_indemnity_paid,
              claim_mira_reducible_indemnity_paid: claim.claim_mira_reducible_indemnity_paid,
              claim_mira_indemnity_reserve_amount: claim.claim_mira_indemnity_reserve_amount,
              claim_mira_non_reducible_indemnity_paid_2: claim.claim_mira_non_reducible_indemnity_paid_2,
              claim_total_subrogation_collected: claim.claim_total_subrogation_collected,
              claim_unlimited_limited_loss: claim.claim_unlimited_limited_loss,
              policy_individual_maximum_claim_value: claim.policy_individual_maximum_claim_value,
              claim_group_multiplier: claim.claim_group_multiplier,
              claim_individual_multiplier: claim.claim_individual_multiplier,
              claim_group_reduced_amount: claim.claim_group_reduced_amount,
              claim_individual_reduced_amount: claim.claim_individual_reduced_amount,
              claim_subrogation_percent: claim.claim_subrogation_percent,
              claim_modified_losses_group_reduced: claim.claim_modified_losses_group_reduced,
              claim_modified_losses_individual_reduced: claim.claim_modified_losses_individual_reduced,
              data_source: claim.data_source
              )
            end

          end
          @group_rating = GroupRating.find_by(id: group_rating_id)
          @group_rating.status = "Completed"
          @group_rating.save
  end
end
