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

class ClaimNoteCategory < ActiveRecord::Base
  has_many :claim_notes

  validates_presence_of :title
end
