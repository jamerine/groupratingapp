# == Schema Information
#
# Table name: payroll_calculations
#
#  id                                                            :integer          not null, primary key
#  representative_number                                         :integer
#  policy_type                                                   :string
#  policy_number                                                 :integer
#  manual_class_type                                             :string
#  manual_number                                                 :integer
#  manual_class_calculation_id                                   :integer
#  reporting_period_start_date                                   :date
#  reporting_period_end_date                                     :date
#  manual_class_payroll                                          :float
#  reporting_type                                                :string
#  number_of_employees                                           :integer
#  policy_transferred                                            :integer
#  transfer_creation_date                                        :date
#  process_payroll_all_transactions_breakdown_by_manual_class_id :integer
#  payroll_origin                                                :string
#  data_source                                                   :string
#  created_at                                                    :datetime         not null
#  updated_at                                                    :datetime         not null
#  manual_class_rate                                             :float
#  manual_class_transferred                                      :integer
#

require 'test_helper'

class PayrollCalculationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
