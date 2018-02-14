class ContactType < ActiveRecord::Base
  has_many :accounts_contacts_contact_types, dependent: :destroy
  has_many :accounts_contacts, through: :accounts_contacts_contact_types

  def display_name
    name.humanize
  end
end
