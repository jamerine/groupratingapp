class Affiliate < ActiveRecord::Base
  has_many :accounts_affiliates
  has_many :accounts, through: :accounts_affiliates

  enum role: [:crm, :examiner, :sales, :referral]
  enum internal_external: [:external, :internal]

end
