# == Schema Information
#
# Table name: bwc_codes_constant_values
#
#  id             :integer          not null, primary key
#  completed_date :date
#  employer_type  :integer          default(0)
#  name           :string
#  rate           :float
#  start_date     :date
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class BwcCodesConstantValueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
