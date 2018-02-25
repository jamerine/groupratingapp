class AccountProgram < ActiveRecord::Base
  belongs_to :account
  has_one :representative, through: :account

  enum program_type: [:group_rating, :group_retro, :retainer, :grow_ohio, :one_claim_program, :em_cap]

  enum status: [:accepted, :rejected, :void, :withdraw]

  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

end
