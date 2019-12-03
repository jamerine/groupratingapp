# == Schema Information
#
# Table name: miras
#
#  id         :integer          not null, primary key
#  single_rec :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :mira do
    single_rec "MyString"
  end
end
