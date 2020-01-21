# == Schema Information
#
# Table name: claim_notes
#
#  id                     :integer          not null, primary key
#  body                   :text
#  title                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  claim_id               :integer
#  claim_note_category_id :integer
#

class ClaimNote < ActiveRecord::Base
end
