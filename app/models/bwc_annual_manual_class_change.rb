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

class BwcAnnualManualClassChange < ActiveRecord::Base
  
end
