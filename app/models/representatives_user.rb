class RepresentativesUser < ActiveRecord::Base
  belongs_to :representative
  belongs_to :user

end
