# == Schema Information
#
# Table name: representatives_users
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  representative_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :representatives_user do
    
  end
end
