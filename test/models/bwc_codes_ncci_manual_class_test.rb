# == Schema Information
#
# Table name: bwc_codes_ncci_manual_classes
#
#  id                         :integer          not null, primary key
#  industry_group             :integer
#  ncci_manual_classification :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#

require 'test_helper'

class BwcCodesNcciManualClassTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
