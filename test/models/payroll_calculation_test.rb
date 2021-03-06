# == Schema Information
#
# Table name: payroll_calculations
#
#  id                                                            :integer          not null, primary key
#  data_source                                                   :string
#  manual_class_payroll                                          :float
#  manual_class_rate                                             :float
#  manual_class_transferred                                      :integer
#  manual_class_type                                             :string
#  manual_number                                                 :integer
#  number_of_employees                                           :integer
#  payroll_origin                                                :string
#  policy_number                                                 :integer
#  policy_transferred                                            :integer
#  policy_type                                                   :string
#  recently_updated                                              :boolean          default(FALSE)
#  reporting_period_end_date                                     :date
#  reporting_period_start_date                                   :date
#  reporting_type                                                :string
#  representative_number                                         :integer
#  transfer_creation_date                                        :date
#  created_at                                                    :datetime         not null
#  updated_at                                                    :datetime         not null
#  manual_class_calculation_id                                   :integer
#  process_payroll_all_transactions_breakdown_by_manual_class_id :integer
#
# Indexes
#
#  index_payroll_calc_on_pol_num_and_man_num                  (policy_number,manual_number)
#  index_payroll_calculations_on_manual_class_calculation_id  (manual_class_calculation_id)
#
# Foreign Keys
#
#  fk_rails_...  (manual_class_calculation_id => manual_class_calculations.id)
#

require 'test_helper'

class PayrollCalculationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
