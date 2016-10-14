class ClaimCalculation < ActiveRecord::Base
  belongs_to :policy_calculation

  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

  def recalculate_experience
    @policy_calculation = PolicyCalculation.find(self.policy_calculation_id)

    policy_individual_maximum_claim_value = @policy_calculation.policy_maximum_claim_value

    claim_individual_multiplier =
      if policy_individual_maximum_claim_value.nil? || self.claim_unlimited_limited_loss.nil? || self.policy_individual_maximum_claim_value > self.claim_unlimited_limited_loss || policy_individual_maximum_claim_value == 0
        1
      else
        policy_individual_maximum_claim_value / self.claim_unlimited_limited_loss
      end

    claim_individual_reduced_amount =
    (((self.claim_mira_non_reducible_indemnity_paid +
      self.claim_mira_non_reducible_indemnity_paid_2) * claim_individual_multiplier) +
    (
    (self.claim_medical_paid +
    self.claim_mira_medical_reserve_amount +
    self.claim_mira_reducible_indemnity_paid +
    self.claim_mira_indemnity_reserve_amount) * claim_individual_multiplier * ( 1 - self.claim_handicap_percent )))

    claim_modified_losses_individual_reduced = (claim_individual_reduced_amount * (1 - self.claim_subrogation_percent))

    update_attributes(policy_individual_maximum_claim_value: policy_individual_maximum_claim_value, claim_individual_multiplier: claim_individual_multiplier, claim_individual_reduced_amount: claim_individual_reduced_amount, claim_modified_losses_individual_reduced: claim_modified_losses_individual_reduced)
  end
end
