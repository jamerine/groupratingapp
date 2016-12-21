class GroupRatingException < ActiveRecord::Base
  belongs_to :account
  belongs_to :representative

  def self.search(exception_reason)
    where("exception_reason = ?", "#{exception_reason}")
  end


end
