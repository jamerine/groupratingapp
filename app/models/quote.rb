class Quote < ActiveRecord::Base
  belongs_to :account

  enum program_type: [:deductible,  :em_capping, :fifteen_k, :group_rating, :group_retro, :independent_retro, :one_claim]

  enum status: [:quoted, :sent, :accepted]

end
