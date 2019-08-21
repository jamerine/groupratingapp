# == Schema Information
#
# Table name: process_payroll_all_transactions_breakdown_by_manual_classes
#
#  id                           :integer          not null, primary key
#  representative_number        :integer
#  policy_type                  :string
#  policy_number                :integer
#  policy_status_effective_date :date
#  policy_status                :string
#  manual_number                :integer
#  manual_class_type            :string
#  manual_class_description     :string
#  bwc_customer_id              :integer
#  reporting_period_start_date  :date
#  reporting_period_end_date    :date
#  manual_class_rate            :float
#  manual_class_payroll         :float
#  reporting_type               :string
#  number_of_employees          :integer
#  policy_transferred           :integer
#  transfer_creation_date       :date
#  payroll_origin               :string
#  data_source                  :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  manual_class_transferred     :integer
#

require 'test_helper'

class ProcessPayrollAllTransactionsBreakdownByManualClassTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
