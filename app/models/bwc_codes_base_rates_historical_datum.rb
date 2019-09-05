# == Schema Information
#
# Table name: bwc_codes_base_rates_historical_data
#
#  id                 :integer          not null, primary key
#  year               :integer
#  class_code         :integer
#  industry_group     :integer
#  base_rate          :float
#  expected_loss_rate :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class BwcCodesBaseRatesHistoricalDatum < ActiveRecord::Base
  scope :by_year, ->(year) { where(year: year) }

  AVAILABLE_YEARS = all.pluck(:year).uniq
end
