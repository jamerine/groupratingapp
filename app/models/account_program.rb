class AccountProgram < ActiveRecord::Base
  belongs_to :account

  enum program_type: [:group_rating, :group_retro, :retainer, :grow_ohio, :one_claim_program, :em_cap]

  enum status: [:accepted, :rejected, :void, :withdraw]
end
