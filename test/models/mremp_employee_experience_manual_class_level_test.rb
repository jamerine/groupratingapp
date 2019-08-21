# == Schema Information
#
# Table name: mremp_employee_experience_manual_class_levels
#
#  id                              :integer          not null, primary key
#  representative_number           :integer
#  representative_type             :integer
#  policy_type                     :string
#  policy_number                   :integer
#  business_sequence_number        :integer
#  record_type                     :integer
#  manual_number                   :integer
#  sub_manual_number               :string
#  claim_reserve_code              :string
#  claim_number                    :string
#  experience_period_payroll       :integer
#  manual_class_base_rate          :float
#  manual_class_expected_loss_rate :float
#  manual_class_expected_losses    :integer
#  merit_rated_flag                :string
#  policy_manual_status            :string
#  limited_loss_ratio              :float
#  limited_losses                  :integer
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#

require 'test_helper'

class MrempEmployeeExperienceManualClassLevelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
