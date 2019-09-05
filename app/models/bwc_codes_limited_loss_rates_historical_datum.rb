# == Schema Information
#
# Table name: bwc_codes_limited_loss_rates_historical_data
#
#  id                 :integer          not null, primary key
#  year               :integer
#  industry_group     :integer
#  credibility_group  :integer
#  limited_loss_ratio :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class BwcCodesLimitedLossRatesHistoricalDatum < ActiveRecord::Base
  scope :by_year, ->(year) { where(year: year) }

  AVAILABLE_YEARS = all.pluck(:year).uniq
end
