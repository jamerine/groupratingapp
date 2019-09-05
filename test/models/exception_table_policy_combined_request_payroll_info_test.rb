# == Schema Information
#
# Table name: exception_table_policy_combined_request_payroll_infos
#
#  id                        :integer          not null, primary key
#  representative_number     :string
#  predecessor_policy_type   :string
#  predecessor_policy_number :integer
#  successor_policy_type     :string
#  successor_policy_number   :integer
#  transfer_type             :string
#  transfer_effective_date   :date
#  transfer_creation_date    :date
#  payroll_origin            :string
#  data_source               :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

require 'test_helper'

class ExceptionTablePolicyCombinedRequestPayrollInfoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
