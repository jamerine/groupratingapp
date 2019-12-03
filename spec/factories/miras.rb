# == Schema Information
#
# Table name: miras
#
#  id         :integer          not null, primary key
#  single_rec :string
#

FactoryGirl.define do
  factory :mira do
    single_rec "MyString"
  end
end
