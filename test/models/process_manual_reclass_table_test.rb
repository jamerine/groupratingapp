# == Schema Information
#
# Table name: process_manual_reclass_tables
#
#  id                                 :integer          not null, primary key
#  representative_number              :integer
#  policy_type                        :string
#  policy_number                      :integer
#  re_classed_from_manual_number      :integer
#  re_classed_to_manual_number        :integer
#  reclass_manual_coverage_type       :string
#  reclass_creation_date              :date
#  payroll_reporting_period_from_date :date
#  payroll_reporting_period_to_date   :date
#  re_classed_to_manual_payroll_total :float
#  payroll_origin                     :string
#  data_source                        :string
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#

require 'test_helper'

class ProcessManualReclassTableTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
