class AccountsContact < ActiveRecord::Base
  belongs_to :account
  belongs_to :contact
  has_many :accounts_contacts_contact_types, dependent: :destroy
  has_many :contact_types, through: :accounts_contacts_contact_types

end
