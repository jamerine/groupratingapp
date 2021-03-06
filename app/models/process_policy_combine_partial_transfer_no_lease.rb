# == Schema Information
#
# Table name: process_policy_combine_partial_transfer_no_leases
#
#  id                                  :integer          not null, primary key
#  representative_number               :integer
#  valid_policy_number                 :string
#  policy_combinations                 :string
#  predecessor_policy_type             :string
#  predecessor_policy_number           :integer
#  successor_policy_type               :string
#  successor_policy_number             :integer
#  transfer_type                       :string
#  transfer_effective_date             :date
#  transfer_creation_date              :date
#  partial_transfer_due_to_labor_lease :string
#  labor_lease_type                    :string
#  partial_transfer_payroll_movement   :string
#  ncci_manual_number                  :integer
#  manual_coverage_type                :string
#  payroll_reporting_period_from_date  :date
#  payroll_reporting_period_to_date    :date
#  manual_payroll                      :float
#  payroll_origin                      :string
#  data_source                         :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#

class ProcessPolicyCombinePartialTransferNoLease < ActiveRecord::Base
end
