# == Schema Information
#
# Table name: bwc_annual_manual_class_changes
#
#  id                :integer          not null, primary key
#  manual_class_from :integer
#  manual_class_to   :integer
#  policy_year       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe BwcAnnualManualClassChange, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
