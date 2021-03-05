# == Schema Information
#
# Table name: mcos
#
#  id         :integer          not null, primary key
#  deleted_at :datetime
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bwc_mco_id :integer
#
# Indexes
#
#  index_mcos_on_deleted_at  (deleted_at)
#

FactoryBot.define do
  factory :mco do
    mco_id { 1 }
    name { "MyString" }
  end
end
