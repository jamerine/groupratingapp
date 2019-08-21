# == Schema Information
#
# Table name: group_rating_rejections
#
#  id                :integer          not null, primary key
#  account_id        :integer
#  representative_id :integer
#  reject_reason     :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  program_type      :string
#  hide              :boolean
#

class GroupRatingRejection < ActiveRecord::Base
  belongs_to :account
  belongs_to :representative

  def self.reject_reason(reject_reason)
    where("reject_reason = ?", "#{reject_reason}")
  end

  def self.program_type(program_type)
    where("program_type = ?", "#{program_type}")
  end

  scope :with_active_policy, -> { joins(:account).merge(Account.active_policy) }

end
