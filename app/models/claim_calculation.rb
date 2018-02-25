class ClaimCalculation < ActiveRecord::Base
  belongs_to :policy_calculation

  attr_accessor :comp_awarded, :medical_paid, :mira_reserve

  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

  def comp_awarded
   (((claim_mira_reducible_indemnity_paid + claim_mira_non_reducible_indemnity_paid )*( 1 - claim_subrogation_percent )-(claim_mira_non_reducible_indemnity_paid))*(1 - claim_handicap_percent)+( claim_mira_non_reducible_indemnity_paid)
    ) * claim_group_multiplier
  end

  def medical_paid
    (((claim_medical_paid + claim_mira_non_reducible_indemnity_paid_2)*(1 - claim_subrogation_percent) - claim_mira_non_reducible_indemnity_paid_2) *( 1 - claim_handicap_percent) + claim_mira_non_reducible_indemnity_paid_2) * claim_group_multiplier
  end

  def mira_reserve
    ((1 - claim_handicap_percent) * ( claim_mira_medical_reserve_amount + (claim_mira_indemnity_reserve_amount)) * claim_group_multiplier * (1 - claim_subrogation_percent))
  end


  def recalculate_experience(group_maximum_value)

    #WHEN I COME IN TO FIX CLAIMS FOR STEVE, ADD SI TOTAL ON CLAIM CALCUALTIONS MODEL THEN FIX IN REPORT
    #### 3/14/2017 ####

    @policy_calculation = self.policy_calculation

    @claim_group_multiplier =
        if self.claim_unlimited_limited_loss < 250000
          1
        else
          (250000 / self.claim_unlimited_limited_loss)
        end

    @claim_individual_multiplier =
      if (group_maximum_value.nil? || self.claim_unlimited_limited_loss.nil? || group_maximum_value > self.claim_unlimited_limited_loss || group_maximum_value == 0 || self.claim_unlimited_limited_loss == 0)
        1
      else
        group_maximum_value / self.claim_unlimited_limited_loss
      end

     @claim_group_reduced_amount =
      (((self.claim_mira_non_reducible_indemnity_paid + self.claim_mira_non_reducible_indemnity_paid_2 ) * @claim_group_multiplier ) + ((self.claim_medical_paid + self.claim_mira_medical_reserve_amount + self.claim_mira_reducible_indemnity_paid + self.claim_mira_indemnity_reserve_amount) * @claim_group_multiplier * (1 - self.claim_handicap_percent)))

    @claim_individual_reduced_amount =
    (((self.claim_mira_non_reducible_indemnity_paid +
      self.claim_mira_non_reducible_indemnity_paid_2) * @claim_individual_multiplier) +
    (
    (self.claim_medical_paid +
    self.claim_mira_medical_reserve_amount +
    self.claim_mira_reducible_indemnity_paid +
    self.claim_mira_indemnity_reserve_amount) * @claim_individual_multiplier * ( 1 - self.claim_handicap_percent )))

    @claim_subrogation_percent =
      if self.claim_total_subrogation_collected == 0.0
        0
      elsif self.claim_total_subrogation_collected > self.claim_unlimited_limited_loss
        1
      else
        self.claim_total_subrogation_collected / self.claim_unlimited_limited_loss
      end

    @claim_modified_losses_group_reduced = @claim_group_reduced_amount * (1 - @claim_subrogation_percent)


    @claim_modified_losses_individual_reduced = (@claim_individual_reduced_amount * (1 - @claim_subrogation_percent))

    update_attributes(policy_individual_maximum_claim_value: group_maximum_value, claim_individual_multiplier: @claim_individual_multiplier, claim_group_reduced_amount: @claim_group_reduced_amount, claim_individual_reduced_amount: @claim_individual_reduced_amount, claim_modified_losses_individual_reduced: @claim_modified_losses_individual_reduced, claim_group_multiplier: @claim_group_multiplier, claim_subrogation_percent: @claim_subrogation_percent, claim_modified_losses_group_reduced: @claim_modified_losses_group_reduced)

  end
end
