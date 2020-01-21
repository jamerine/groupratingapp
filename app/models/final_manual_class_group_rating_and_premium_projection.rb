# == Schema Information
#
# Table name: final_manual_class_group_rating_and_premium_projections
#
#  id                                             :integer          not null, primary key
#  data_source                                    :string
#  manual_class_base_rate                         :float
#  manual_class_current_estimated_payroll         :float
#  manual_class_estimated_group_premium           :float
#  manual_class_estimated_individual_premium      :float
#  manual_class_group_total_rate                  :float
#  manual_class_individual_total_rate             :float
#  manual_class_industry_group                    :integer
#  manual_class_industry_group_premium_percentage :float
#  manual_class_industry_group_premium_total      :float
#  manual_class_modification_rate                 :float
#  manual_class_standard_premium                  :float
#  manual_class_type                              :string
#  manual_number                                  :integer
#  policy_number                                  :integer
#  policy_type                                    :string
#  representative_number                          :integer
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#
# Indexes
#
#  index_fin_man_pr_pol_num_and_man_num_rep  (policy_number,manual_number,representative_number)
#

class FinalManualClassGroupRatingAndPremiumProjection < ActiveRecord::Base
end
