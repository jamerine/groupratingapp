# == Schema Information
#
# Table name: bwc_codes_policy_effective_dates
#
#  id                             :integer          not null, primary key
#  policy_number                  :integer
#  policy_original_effective_date :date
#  created_at                     :datetime
#  updated_at                     :datetime
#
# Indexes
#
#  index_bwc_codes_policy_effective_dates_on_policy_number  (policy_number)
#

require 'test_helper'

class BwcCodesPolicyEffectiveDateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
