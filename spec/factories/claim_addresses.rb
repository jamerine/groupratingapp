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

FactoryBot.define do
  factory :claim_address do
    claim_number { "MyString" }
    policy_number { 1 }
    representative_number { 1 }
    address { "MyText" }
  end
end
