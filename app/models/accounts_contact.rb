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

class AccountsContact < ActiveRecord::Base
  belongs_to :account
  belongs_to :contact
  has_many :accounts_contacts_contact_types, dependent: :destroy
  has_many :contact_types, through: :accounts_contacts_contact_types

end
