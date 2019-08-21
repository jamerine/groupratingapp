# == Schema Information
#
# Table name: bwc_codes_limited_loss_ratios
#
#  id                 :integer          not null, primary key
#  industry_group     :integer
#  credibility_group  :integer
#  limited_loss_ratio :float
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class BwcCodesLimitedLossRatioTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
