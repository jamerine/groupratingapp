# == Schema Information
#
# Table name: contact_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContactType < ActiveRecord::Base
  has_many :accounts_contacts_contact_types, dependent: :destroy
  has_many :accounts_contacts, through: :accounts_contacts_contact_types

  def display_name
    name.humanize
  end
end
