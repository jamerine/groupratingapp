class Quote < ActiveRecord::Base
  belongs_to :account

  enum program_type: [:deductible,  :em_capping, :fifteen_k, :group_rating, :group_retro, :independent_retro, :one_claim]

  enum status: [:quoted, :sent, :accepted]

  def generate_invoice_number
    policy_year = self.effective_end_date.strftime("%Y")
    s = "#{self.account.representative.representative_number}-#{self.account.policy_number_entered}-#{policy_year}-#{self.id}"
    update_attributes(invoice_number: s)
  end

end
