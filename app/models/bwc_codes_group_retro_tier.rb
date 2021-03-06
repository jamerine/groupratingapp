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

class BwcCodesGroupRetroTier < ActiveRecord::Base

  scope :industry_groups, ->(public_only) { where(public_employer_only: public_only).pluck(:industry_group) }
  scope :by_public_employer, ->(public_employer) { where(public_employer_only: public_employer) }

  def self.find_for_account(account)
    find_by(industry_group: account.industry_group, public_employer_only: account.public_employer?)
  end
end
