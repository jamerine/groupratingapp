# == Schema Information
#
# Table name: group_rating_exceptions
#
#  id                :integer          not null, primary key
#  exception_reason  :string
#  resolved          :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :integer
#  representative_id :integer
#
# Indexes
#
#  index_group_rating_exceptions_on_account_id         (account_id)
#  index_group_rating_exceptions_on_representative_id  (representative_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (representative_id => representatives.id)
#

class GroupRatingException < ActiveRecord::Base
  belongs_to :account
  belongs_to :representative

  def self.search(exception_reason)
    where("exception_reason = ?", "#{exception_reason}")
  end


end
