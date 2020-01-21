# == Schema Information
#
# Table name: process_payroll_all_transactions_breakdown_by_manual_classes
#
#  id                           :integer          not null, primary key
#  data_source                  :string
#  manual_class_description     :string
#  manual_class_payroll         :float
#  manual_class_rate            :float
#  manual_class_transferred     :integer
#  manual_class_type            :string
#  manual_number                :integer
#  number_of_employees          :integer
#  payroll_origin               :string
#  policy_number                :integer
#  policy_status                :string
#  policy_status_effective_date :date
#  policy_transferred           :integer
#  policy_type                  :string
#  reporting_period_end_date    :date
#  reporting_period_start_date  :date
#  reporting_type               :string
#  representative_number        :integer
#  transfer_creation_date       :date
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  bwc_customer_id              :integer
#
# Indexes
#
#  index_pr_pol_num_and_man_num_rep  (policy_number,manual_number,representative_number)
#

require 'test_helper'

class ProcessPayrollAllTransactionsBreakdownByManualClassTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
