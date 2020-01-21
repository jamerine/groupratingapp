# == Schema Information
#
# Table name: accounts_contacts_contact_types
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  accounts_contact_id :integer
#  contact_type_id     :integer
#
# Indexes
#
#  index_accounts_contacts_contact_types_on_accounts_contact_id  (accounts_contact_id)
#  index_accounts_contacts_contact_types_on_contact_type_id      (contact_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (accounts_contact_id => accounts_contacts.id)
#  fk_rails_...  (contact_type_id => contact_types.id)
#

FactoryBot.define do
  factory :accounts_contacts_contact_type do
    
  end
end
