class AccountProgram < ActiveRecord::Base
  belongs_to :account

  enum program_type: [:group_rating, :group_retro, :retainer]

end
