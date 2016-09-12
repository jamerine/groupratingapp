class Import < ActiveRecord::Base
  belongs_to :representative
  belongs_to :group_rating

end
