# == Schema Information
#
# Table name: note_categories
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe NoteCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
