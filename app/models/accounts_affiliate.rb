# == Schema Information
#
# Table name: accounts_affiliates
#
#  id           :integer          not null, primary key
#  account_id   :integer
#  affiliate_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class AccountsAffiliate < ActiveRecord::Base
  belongs_to :account
  belongs_to :affiliate
end
