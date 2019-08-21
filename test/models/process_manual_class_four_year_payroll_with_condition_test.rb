# == Schema Information
#
# Table name: process_manual_class_four_year_payroll_with_conditions
#
#  id                                    :integer          not null, primary key
#  representative_number                 :integer
#  policy_type                           :string
#  policy_number                         :integer
#  manual_number                         :integer
#  manual_class_type                     :string
#  manual_class_four_year_period_payroll :float
#  data_source                           :string
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#

require 'test_helper'

class ProcessManualClassFourYearPayrollWithConditionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
