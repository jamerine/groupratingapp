# == Schema Information
#
# Table name: accounts_contacts
#
#  id         :integer          not null, primary key
#  account_id :integer
#  contact_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :accounts_contact do
    
  end
end
