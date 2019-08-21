# == Schema Information
#
# Table name: notes
#
#  id          :integer          not null, primary key
#  description :text
#  category    :integer
#  title       :string
#  attachment  :string
#  account_id  :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :note do
    
  end
end
