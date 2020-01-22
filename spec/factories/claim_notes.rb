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

FactoryBot.define do
  factory :claim_note do
  end
end
