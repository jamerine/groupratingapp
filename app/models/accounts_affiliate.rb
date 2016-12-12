class AccountsAffiliate < ActiveRecord::Base
  belongs_to :account
  belongs_to :affiliate
end
