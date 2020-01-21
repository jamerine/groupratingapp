# == Schema Information
#
# Table name: final_manual_class_four_year_payroll_and_exp_losses
#
#  id                                    :integer          not null, primary key
#  data_source                           :string
#  manual_class_base_rate                :float
#  manual_class_expected_loss_rate       :float
#  manual_class_expected_losses          :float
#  manual_class_four_year_period_payroll :float
#  manual_class_industry_group           :integer
#  manual_class_limited_loss_rate        :float
#  manual_class_limited_losses           :float
#  manual_class_type                     :string
#  manual_number                         :integer
#  policy_number                         :integer
#  policy_type                           :string
#  representative_number                 :integer
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#
# Indexes
#
#  index_man_pr_pol_num_and_man_num_rep  (policy_number,manual_number,representative_number)
#

class FinalManualClassFourYearPayrollAndExpLoss < ActiveRecord::Base
end
