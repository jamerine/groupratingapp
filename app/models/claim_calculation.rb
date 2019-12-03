# == Schema Information
#
# Table name: claim_calculations
#
#  id                                        :integer          not null, primary key
#  representative_number                     :integer
#  policy_type                               :string
#  policy_number                             :integer
#  policy_calculation_id                     :integer
#  claim_number                              :string
#  claim_injury_date                         :date
#  claim_handicap_percent                    :float
#  claim_handicap_percent_effective_date     :date
#  claimant_date_of_death                    :date
#  claimant_date_of_birth                    :date
#  claimant_name                             :string
#  claim_manual_number                       :integer
#  claim_medical_paid                        :float
#  claim_mira_medical_reserve_amount         :float
#  claim_mira_non_reducible_indemnity_paid   :float
#  claim_mira_reducible_indemnity_paid       :float
#  claim_mira_indemnity_reserve_amount       :float
#  claim_mira_non_reducible_indemnity_paid_2 :float
#  claim_total_subrogation_collected         :float
#  claim_unlimited_limited_loss              :float
#  policy_individual_maximum_claim_value     :float
#  claim_group_multiplier                    :float
#  claim_individual_multiplier               :float
#  claim_group_reduced_amount                :float
#  claim_individual_reduced_amount           :float
#  claim_subrogation_percent                 :float
#  claim_modified_losses_group_reduced       :float
#  claim_modified_losses_individual_reduced  :float
#  data_source                               :string
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  claim_combined                            :string
#  combined_into_claim_number                :string
#  claim_rating_plan_indicator               :string
#  claim_status                              :string
#  claim_status_effective_date               :date
#  claim_type                                :string
#  claim_activity_status                     :string
#  claim_activity_status_effective_date      :date
#  settled_claim                             :string
#  settlement_type                           :string
#  medical_settlement_date                   :date
#  indemnity_settlement_date                 :date
#  maximum_medical_improvement_date          :date
#  claim_mira_ncci_injury_type               :string
#

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

  def representative_name_and_abbreviation
    representative = Representative.find_by(representative_number: self.representative_number)

    "#{representative.company_name} (#{representative.abbreviated_name})"
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
