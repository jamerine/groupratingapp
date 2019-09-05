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

require 'rails_helper'

RSpec.describe AccountsAffiliate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
