# == Schema Information
#
# Table name: accounts_contacts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#  contact_id :integer
#
# Indexes
#
#  index_accounts_contacts_on_account_id  (account_id)
#  index_accounts_contacts_on_contact_id  (contact_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (contact_id => contacts.id)
#

class AccountsContact < ActiveRecord::Base
  belongs_to :account
  belongs_to :contact
  has_many :accounts_contacts_contact_types, dependent: :destroy
  has_many :contact_types, through: :accounts_contacts_contact_types

end
