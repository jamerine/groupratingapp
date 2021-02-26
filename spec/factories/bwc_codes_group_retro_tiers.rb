# == Schema Information
#
# Table name: bwc_codes_group_retro_tiers
#
#  id                   :integer          not null, primary key
#  discount_tier        :float
#  industry_group       :integer
#  public_employer_only :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryBot.define do
  factory :bwc_codes_group_retro_tier do
    
  end
end
