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

require 'rails_helper'

RSpec.describe ClaimNoteCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
