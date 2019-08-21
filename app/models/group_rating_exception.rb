# == Schema Information
#
# Table name: group_rating_exceptions
#
#  id                :integer          not null, primary key
#  account_id        :integer
#  representative_id :integer
#  exception_reason  :string
#  resolved          :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class GroupRatingException < ActiveRecord::Base
  belongs_to :account
  belongs_to :representative

  def self.search(exception_reason)
    where("exception_reason = ?", "#{exception_reason}")
  end


end
