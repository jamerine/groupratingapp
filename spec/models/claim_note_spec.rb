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

require 'rails_helper'

RSpec.describe ClaimNote, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
