# == Schema Information
#
# Table name: claim_note_categories
#
#  id         :integer          not null, primary key
#  note       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :claim_note_category do
  end
end
