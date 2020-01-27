# == Schema Information
#
# Table name: mremp_employee_experience_manual_class_levels
#
#  id                              :integer          not null, primary key
#  business_sequence_number        :integer
#  claim_number                    :string
#  claim_reserve_code              :string
#  experience_period_payroll       :bigint(8)
#  limited_loss_ratio              :float
#  limited_losses                  :integer
#  manual_class_base_rate          :float
#  manual_class_expected_loss_rate :float
#  manual_class_expected_losses    :integer
#  manual_number                   :integer
#  merit_rated_flag                :string
#  policy_manual_status            :string
#  policy_number                   :integer
#  policy_type                     :string
#  record_type                     :integer
#  representative_number           :integer
#  representative_type             :integer
#  sub_manual_number               :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#

class MrempEmployeeExperienceManualClassLevel < ActiveRecord::Base
end
