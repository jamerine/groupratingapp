# == Schema Information
#
# Table name: claim_notes
#
#  id                     :integer          not null, primary key
#  body                   :text             default("")
#  claim_number           :string
#  date                   :datetime
#  deleted_at             :datetime
#  is_pinned              :boolean          default(FALSE)
#  policy_number          :integer
#  representative_number  :integer
#  title                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  claim_calculation_id   :integer
#  claim_note_category_id :integer
#  user_id                :integer
#
# Indexes
#
#  index_claim_notes_on_deleted_at  (deleted_at)
#

class ClaimNote < ActiveRecord::Base
  acts_as_paranoid

  #belongs_to :claim_calculation
  belongs_to :claim_note_category
  belongs_to :user

  scope :by_representative, -> (rep_number) { where(representative_number: rep_number) }

  validates_presence_of :policy_number, :representative_number, :claim_number

  delegate :email, to: :user, prefix: true, allow_nil: true

  def claim_calculation
    ClaimCalculation.find_by(claim_number: claim_number, policy_number: policy_number, representative_number: representative_number) ||
      ClaimCalculation.by_rep_and_policy(representative_number, policy_number).where('claim_number LIKE ?', "%#{claim_number}%").order(created_at: :asc).first
  end
end
