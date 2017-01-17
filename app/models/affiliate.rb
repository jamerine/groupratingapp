class Affiliate < ActiveRecord::Base
  has_many :accounts_affiliates
  has_many :accounts, through: :accounts_affiliates

  before_save {self.first_name = first_name.downcase.titleize}
  before_save {self.last_name = last_name.downcase.titleize}
  before_save {self.email_address = email_address.downcase}

  enum role: [:crm, :examiner, :sales, :referral, :cose_id]
  enum internal_external: [:external, :internal]

  private
end
