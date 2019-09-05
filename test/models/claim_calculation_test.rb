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

require 'test_helper'

class ClaimCalculationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
