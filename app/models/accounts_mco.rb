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

class AccountsMco < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :account
  belongs_to :mco

  validates_presence_of :relationship_start_date
end
