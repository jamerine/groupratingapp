# == Schema Information
#
# Table name: group_rating_rejections
#
#  id                :integer          not null, primary key
#  hide              :boolean
#  program_type      :string
#  reject_reason     :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :integer
#  representative_id :integer
#
# Indexes
#
#  index_group_rating_rejections_on_account_id         (account_id)
#  index_group_rating_rejections_on_representative_id  (representative_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (representative_id => representatives.id)
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
