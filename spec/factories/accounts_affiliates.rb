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

FactoryGirl.define do
  factory :accounts_affiliate do
    
  end
end
