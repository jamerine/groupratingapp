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

require 'rails_helper'

RSpec.describe BwcCodesGroupRetroTier, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
