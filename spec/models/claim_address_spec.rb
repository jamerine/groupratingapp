# == Schema Information
#
# Table name: claim_addresses
#
#  id                    :integer          not null, primary key
#  address               :text
#  claim_number          :string
#  policy_number         :integer
#  representative_number :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'rails_helper'

RSpec.describe ClaimAddress, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
