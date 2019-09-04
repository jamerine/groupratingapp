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

FactoryGirl.define do
  factory :bwc_codes_base_rates_historical_datum do
    year 1
    class_code 1
    base_rate ""
    expected_loss_rate ""
  end
end
