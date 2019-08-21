# == Schema Information
#
# Table name: accounts_contacts_contact_types
#
#  id                  :integer          not null, primary key
#  accounts_contact_id :integer
#  contact_type_id     :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class AccountsContactsContactType < ActiveRecord::Base
  belongs_to :accounts_contact
  belongs_to :contact_type
end
