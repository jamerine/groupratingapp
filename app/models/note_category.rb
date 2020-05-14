# == Schema Information
#
# Table name: note_categories
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NoteCategory < ActiveRecord::Base
  has_many :notes
  
  validates :title, presence: true, uniqueness: true
end
