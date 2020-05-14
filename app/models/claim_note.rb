# == Schema Information
#
# Table name: claim_notes
#
#  id                     :integer          not null, primary key
#  body                   :text
#  claim_number           :string
#  policy_number          :integer
#  representative_number  :integer
#  title                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  claim_calculation_id   :integer
#  claim_note_category_id :integer
#

class ClaimNote < ActiveRecord::Base
  #belongs_to :claim_calculation
  belongs_to :claim_note_category

  validates_presence_of :title, :body, :policy_number, :representative_number, :claim_number

  def claim_calculation
    ClaimCalculation.find_by(claim_number: claim_number, policy_number: policy_number, representative_number: representative_number) ||
      ClaimCalculation.find_by(claim_number: "#{claim_number} ", policy_number: policy_number, representative_number: representative_number)
  end
end
