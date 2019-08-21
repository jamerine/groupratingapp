# == Schema Information
#
# Table name: process_policy_coverage_status_histories
#
#  id                      :integer          not null, primary key
#  representative_number   :integer
#  policy_type             :string
#  policy_number           :integer
#  coverage_effective_date :date
#  coverage_end_date       :date
#  coverage_status         :string
#  lapse_days              :integer
#  data_source             :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'test_helper'

class ProcessPolicyCoverageStatusHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
