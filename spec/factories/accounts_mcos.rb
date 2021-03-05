# == Schema Information
#
# Table name: accounts_mcos
#
#  id                      :integer          not null, primary key
#  deleted_at              :datetime
#  relationship_start_date :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  account_id              :integer
#  mco_id                  :integer
#
# Indexes
#
#  index_accounts_mcos_on_deleted_at  (deleted_at)
#

FactoryBot.define do
  factory :accounts_mco do
    account_id { 1 }
    mco_id { 1 }
    relationship_start_date { "2021-02-23 13:44:54" }
  end
end
