# == Schema Information
#
# Table name: final_manual_class_group_rating_and_premium_projections
#
#  id                                             :integer          not null, primary key
#  representative_number                          :integer
#  policy_type                                    :string
#  policy_number                                  :integer
#  manual_number                                  :integer
#  manual_class_type                              :string
#  manual_class_industry_group                    :integer
#  manual_class_industry_group_premium_total      :float
#  manual_class_current_estimated_payroll         :float
#  manual_class_base_rate                         :float
#  manual_class_industry_group_premium_percentage :float
#  manual_class_modification_rate                 :float
#  manual_class_individual_total_rate             :float
#  manual_class_group_total_rate                  :float
#  manual_class_standard_premium                  :float
#  manual_class_estimated_group_premium           :float
#  manual_class_estimated_individual_premium      :float
#  data_source                                    :string
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#

require 'test_helper'

class FinalManualClassGroupRatingAndPremiumProjectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
