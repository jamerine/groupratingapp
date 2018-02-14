class AccountsContactsContactType < ActiveRecord::Base
  belongs_to :accounts_contact
  belongs_to :contact_type
end
