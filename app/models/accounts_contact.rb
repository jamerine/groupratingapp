class AccountsContact < ActiveRecord::Base
  belongs_to :account
  belongs_to :contact
end
