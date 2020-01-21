# == Schema Information
#
# Table name: final_claim_cost_calculation_tables
#
#  id                                        :integer          not null, primary key
#  claim_activity_status                     :string
#  claim_activity_status_effective_date      :date
#  claim_combined                            :string
#  claim_group_multiplier                    :float
#  claim_group_reduced_amount                :float
#  claim_handicap_percent                    :float
#  claim_handicap_percent_effective_date     :date
#  claim_individual_multiplier               :float
#  claim_individual_reduced_amount           :float
#  claim_injury_date                         :date
#  claim_manual_number                       :integer
#  claim_medical_paid                        :float
#  claim_mira_indemnity_reserve_amount       :float
#  claim_mira_medical_reserve_amount         :float
#  claim_mira_ncci_injury_type               :string
#  claim_mira_non_reducible_indemnity_paid   :float
#  claim_mira_non_reducible_indemnity_paid_2 :float
#  claim_mira_reducible_indemnity_paid       :float
#  claim_modified_losses_group_reduced       :float
#  claim_modified_losses_individual_reduced  :float
#  claim_number                              :string
#  claim_rating_plan_indicator               :string
#  claim_status                              :string
#  claim_status_effective_date               :date
#  claim_subrogation_percent                 :float
#  claim_total_subrogation_collected         :float
#  claim_type                                :string
#  claim_unlimited_limited_loss              :float
#  claimant_date_of_birth                    :date
#  claimant_date_of_death                    :date
#  claimant_name                             :string
#  combined_into_claim_number                :string
#  data_source                               :string
#  indemnity_settlement_date                 :date
#  maximum_medical_improvement_date          :date
#  medical_settlement_date                   :date
#  policy_individual_maximum_claim_value     :float
#  policy_number                             :integer
#  policy_type                               :string
#  representative_number                     :integer
#  settled_claim                             :string
#  settlement_type                           :string
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#
# Indexes
#
#  index_cl_pol_num_and_rep  (policy_number,representative_number)
#

require 'test_helper'

class FinalClaimCostCalculationTableTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
