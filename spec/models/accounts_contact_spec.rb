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

require 'rails_helper'

RSpec.describe AccountsContact, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
