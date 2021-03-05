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

class Mco < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  has_many :accounts_mcos, dependent: :destroy
  has_many :accounts, through: :accounts_mcos

  validates :bwc_mco_id, uniqueness: true, presence: true
end
