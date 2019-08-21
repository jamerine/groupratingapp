# == Schema Information
#
# Table name: affiliates
#
#  id                :integer          not null, primary key
#  first_name        :string
#  last_name         :string
#  role              :integer          default(0)
#  email_address     :string
#  salesforce_id     :string
#  representative_id :integer
#  internal_external :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  external_id       :string
#  company_name      :string
#

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
