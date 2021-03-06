# == Schema Information
#
# Table name: final_policy_group_rating_and_premium_projections
#
#  id                              :integer          not null, primary key
#  data_source                     :string
#  group_rating_group_number       :integer
#  group_rating_qualification      :string
#  group_rating_tier               :float
#  policy_group_dues               :float
#  policy_group_fees               :float
#  policy_industry_group           :integer
#  policy_number                   :integer
#  policy_status                   :string
#  policy_total_costs              :float
#  policy_total_current_payroll    :float
#  policy_total_group_premium      :float
#  policy_total_group_savings      :float
#  policy_total_individual_premium :float
#  policy_total_standard_premium   :float
#  policy_type                     :string
#  representative_number           :integer
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_pol_prem_pol_num_and_rep  (policy_number,representative_number)
#

require 'test_helper'

class FinalPolicyGroupRatingAndPremiumProjectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
