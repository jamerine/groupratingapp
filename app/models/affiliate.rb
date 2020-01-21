# == Schema Information
#
# Table name: affiliates
#
#  id                :integer          not null, primary key
#  company_name      :string
#  email_address     :string
#  first_name        :string
#  internal_external :integer          default(0)
#  last_name         :string
#  role              :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  external_id       :string
#  representative_id :integer
#  salesforce_id     :string
#
# Indexes
#
#  index_affiliates_on_representative_id  (representative_id)
#
# Foreign Keys
#
#  fk_rails_...  (representative_id => representatives.id)
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
