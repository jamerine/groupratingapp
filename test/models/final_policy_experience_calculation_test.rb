# == Schema Information
#
# Table name: final_policy_experience_calculations
#
#  id                                              :integer          not null, primary key
#  data_source                                     :string
#  policy_credibility_group                        :integer
#  policy_credibility_percent                      :float
#  policy_group_number                             :string
#  policy_group_ratio                              :float
#  policy_individual_experience_modified_rate      :float
#  policy_individual_total_modifier                :float
#  policy_maximum_claim_value                      :integer
#  policy_number                                   :integer
#  policy_status                                   :string
#  policy_total_claims_count                       :integer
#  policy_total_expected_losses                    :float
#  policy_total_four_year_payroll                  :float
#  policy_total_limited_losses                     :float
#  policy_total_modified_losses_group_reduced      :float
#  policy_total_modified_losses_individual_reduced :float
#  policy_type                                     :string
#  representative_number                           :integer
#  valid_policy_number                             :string
#  created_at                                      :datetime         not null
#  updated_at                                      :datetime         not null
#
# Indexes
#
#  index_pol_exp_pol_num_and_man_num_rep  (policy_number,representative_number)
#

require 'test_helper'

class FinalPolicyExperienceCalculationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
