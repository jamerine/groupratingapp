# == Schema Information
#
# Table name: final_policy_group_rating_and_premium_projections
#
#  id                              :integer          not null, primary key
#  representative_number           :integer
#  policy_type                     :string
#  policy_number                   :integer
#  policy_industry_group           :integer
#  policy_status                   :string
#  group_rating_qualification      :string
#  group_rating_tier               :float
#  group_rating_group_number       :integer
#  policy_total_current_payroll    :float
#  policy_total_standard_premium   :float
#  policy_total_individual_premium :float
#  policy_total_group_premium      :float
#  policy_total_group_savings      :float
#  policy_group_fees               :float
#  policy_group_dues               :float
#  policy_total_costs              :float
#  data_source                     :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#

require 'test_helper'

class FinalPolicyGroupRatingAndPremiumProjectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
