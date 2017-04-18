class Quote < ActiveRecord::Base
  belongs_to :account

  enum program_type: [:group_rating, :group_retro, :retainer]

  enum status: [:accepted, :quoted, :sent, :void, :withdraw]

  mount_uploader :quote_generated, QuoteUploader

  def generate_invoice_number
    policy_year = self.quote_year
    s = "#{self.account.policy_number_entered}-#{policy_year}-#{self.id}"
    update_attributes(invoice_number: s)
  end

end
