class GroupRating < ActiveRecord::Base
  belongs_to :representive
  has_one :import, dependent: :destroy

end
