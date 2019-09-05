# == Schema Information
#
# Table name: bwc_codes_base_rates_exp_loss_rates
#
#  id                 :integer          not null, primary key
#  class_code         :integer
#  base_rate          :float
#  expected_loss_rate :float
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class BwcCodesBaseRatesExpLossRateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
