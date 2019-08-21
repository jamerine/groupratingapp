# == Schema Information
#
# Table name: process_policy_combine_full_transfers
#
#  id                          :integer          not null, primary key
#  representative_number       :integer
#  policy_type                 :string
#  manual_number               :integer
#  manual_class_type           :string
#  reporting_period_start_date :date
#  reporting_period_end_date   :date
#  manual_class_rate           :float
#  manual_class_payroll        :float
#  manual_class_premium        :float
#  predecessor_policy_type     :string
#  predecessor_policy_number   :integer
#  successor_policy_type       :string
#  successor_policy_number     :integer
#  transfer_type               :string
#  transfer_effective_date     :date
#  transfer_creation_date      :date
#  payroll_origin              :string
#  data_source                 :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

class ProcessPolicyCombineFullTransfer < ActiveRecord::Base
end
