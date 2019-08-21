# == Schema Information
#
# Table name: final_manual_class_four_year_payroll_and_exp_losses
#
#  id                                    :integer          not null, primary key
#  representative_number                 :integer
#  policy_type                           :string
#  policy_number                         :integer
#  manual_number                         :integer
#  manual_class_type                     :string
#  manual_class_four_year_period_payroll :float
#  manual_class_expected_loss_rate       :float
#  manual_class_base_rate                :float
#  manual_class_expected_losses          :float
#  manual_class_industry_group           :integer
#  manual_class_limited_loss_rate        :float
#  manual_class_limited_losses           :float
#  data_source                           :string
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#

class FinalManualClassFourYearPayrollAndExpLoss < ActiveRecord::Base
end
