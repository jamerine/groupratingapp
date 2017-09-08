class GroupRatingRejection < ActiveRecord::Base
  belongs_to :account
  belongs_to :representative

  def self.reject_reason(reject_reason)
    where("reject_reason = ?", "#{reject_reason}")
  end

  def self.program_type(program_type)
    where("program_type = ?", "#{program_type}")
  end

end
