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

require 'rails_helper'

RSpec.describe AccountsAffiliate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
