# == Schema Information
#
# Table name: bwc_codes_group_retro_tiers
#
#  id             :integer          not null, primary key
#  industry_group :integer
#  discount_tier  :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class BwcCodesGroupRetroTier < ActiveRecord::Base
end
