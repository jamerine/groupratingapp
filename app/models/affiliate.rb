class Affiliate < ActiveRecord::Base
  has_many :accounts_affiliates, dependent: :destroy
  has_many :accounts, through: :accounts_affiliates

  # before_save {self.first_name = first_name.downcase.titleize}
  # before_save {self.last_name = last_name.downcase.titleize}
  # before_save {self.email_address = email_address.downcase}

  enum role: [:accountant, :association, :company_code, :crm, :examiner, :member, :sales, :referral]
  enum internal_external: [:external, :internal]

  private
end
