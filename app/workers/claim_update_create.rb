class ClaimUpdateCreate
  include Sidekiq::Worker

  sidekiq_options queue: :claim_update_create

  def perform(representative_number,
              policy_type,
              policy_number,
              policy_calculation_id,
              claim_number,
              claim_injury_date,
              claim_handicap_percent,
              claim_handicap_percent_effective_date,
              claim_manual_number,
              claim_medical_paid,
              claim_mira_medical_reserve_amount,
              claim_mira_non_reducible_indemnity_paid,
              claim_mira_reducible_indemnity_paid,
              claim_mira_indemnity_reserve_amount,
              claim_mira_non_reducible_indemnity_paid_2,
              claim_total_subrogation_collected,
              claim_unlimited_limited_loss,
              policy_individual_maximum_claim_value,
              claim_group_multiplier,
              claim_individual_multiplier,
              claim_group_reduced_amount,
              claim_individual_reduced_amount,
              claim_subrogation_percent,
              claim_modified_losses_group_reduced,
              claim_modified_losses_individual_reduced,
              data_source)
    ClaimCalculation.where(
        policy_number: policy_number,
        claim_number: claim_number,
        representative_number: representative_number).update_or_create(
            representative_number: representative_number,
            policy_type: policy_type,
            policy_number: policy_number,
            policy_calculation_id: policy_calculation_id,
            claim_number: claim_number,
            claim_injury_date: claim_injury_date,
            claim_handicap_percent: claim_handicap_percent,
            claim_handicap_percent_effective_date: claim_handicap_percent_effective_date,
            claim_manual_number: claim_manual_number,
            claim_medical_paid: claim_medical_paid,
            claim_mira_medical_reserve_amount: claim_mira_medical_reserve_amount,
            claim_mira_non_reducible_indemnity_paid: claim_mira_non_reducible_indemnity_paid,
            claim_mira_reducible_indemnity_paid: claim_mira_reducible_indemnity_paid,
            claim_mira_indemnity_reserve_amount: claim_mira_indemnity_reserve_amount,
            claim_mira_non_reducible_indemnity_paid_2: claim_mira_non_reducible_indemnity_paid_2,
            claim_total_subrogation_collected: claim_total_subrogation_collected,
            claim_unlimited_limited_loss: claim_unlimited_limited_loss,
            policy_individual_maximum_claim_value: policy_individual_maximum_claim_value,
            claim_group_multiplier: claim_group_multiplier,
            claim_individual_multiplier: claim_individual_multiplier,
            claim_group_reduced_amount: claim_group_reduced_amount,
            claim_individual_reduced_amount: claim_individual_reduced_amount,
            claim_subrogation_percent: claim_subrogation_percent,
            claim_modified_losses_group_reduced: claim_modified_losses_group_reduced,
            claim_modified_losses_individual_reduced: claim_modified_losses_individual_reduced,
            data_source: data_source
        )
  end
end
