# == Schema Information
#
# Table name: bwc_codes_credibility_max_losses
#
#  id                  :integer          not null, primary key
#  credibility_group   :integer
#  expected_losses     :integer
#  credibility_percent :float
#  group_maximum_value :integer
#  created_at          :datetime
#  updated_at          :datetime
#

require 'test_helper'

class BwcCodesCredibilityMaxLossTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
