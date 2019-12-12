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
  validates_presence_of :manual_class_from, :manual_class_to, :policy_year
  validates_numericality_of :manual_class_from, :manual_class_to, :policy_year
  validates :policy_year, length: { maximum: 4 }
  validates_uniqueness_of :manual_class_from, message: 'can only be changed once!'
end
