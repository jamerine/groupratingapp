# == Schema Information
#
# Table name: accounts_affiliates
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :integer
#  affiliate_id :integer
#
# Indexes
#
#  index_accounts_affiliates_on_account_id    (account_id)
#  index_accounts_affiliates_on_affiliate_id  (affiliate_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (affiliate_id => affiliates.id)
#

class AccountsAffiliate < ActiveRecord::Base
  belongs_to :account
  belongs_to :affiliate

  accepts_nested_attributes_for :affiliate
end
