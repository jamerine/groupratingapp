# == Schema Information
#
# Table name: claim_calculations
#
#  id                                        :integer          not null, primary key
#  claim_activity_status                     :string
#  claim_activity_status_effective_date      :date
#  claim_combined                            :string
#  claim_group_multiplier                    :float
#  claim_group_reduced_amount                :float
#  claim_handicap_percent                    :float            default(0.0)
#  claim_handicap_percent_effective_date     :date
#  claim_individual_multiplier               :float
#  claim_individual_reduced_amount           :float
#  claim_injury_date                         :date
#  claim_manual_number                       :integer
#  claim_medical_paid                        :float            default(0.0)
#  claim_mira_indemnity_reserve_amount       :float            default(0.0)
#  claim_mira_medical_reserve_amount         :float            default(0.0)
#  claim_mira_ncci_injury_type               :string
#  claim_mira_non_reducible_indemnity_paid   :float            default(0.0)
#  claim_mira_non_reducible_indemnity_paid_2 :float            default(0.0)
#  claim_mira_reducible_indemnity_paid       :float            default(0.0)
#  claim_modified_losses_group_reduced       :float
#  claim_modified_losses_individual_reduced  :float
#  claim_number                              :string
#  claim_rating_plan_indicator               :string
#  claim_status                              :string
#  claim_status_effective_date               :date
#  claim_subrogation_percent                 :float            default(0.0)
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
#  policy_calculation_id                     :integer
#
# Indexes
#
#  index_claim_calc_on_pol_num_and_claim_num          (policy_number,claim_number)
#  index_claim_calculations_on_policy_calculation_id  (policy_calculation_id)
#
# Foreign Keys
#
#  fk_rails_...  (policy_calculation_id => policy_calculations.id)
#

require 'test_helper'

class ClaimCalculationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
