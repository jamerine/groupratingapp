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
  belongs_to :representative

  validates_presence_of :role, :first_name, :last_name

  enum role: [:accountant, :association, :company_code, :crm, :examiner, :account_examiner, :member, :sales, :referral]
  enum internal_external: [:external, :internal]

  default_scope -> { order(first_name: :asc, last_name: :asc) }

  scope :by_representative, -> (representative_id) { where(representative_id: representative_id) }
end
