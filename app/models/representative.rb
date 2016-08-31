class Representative < ActiveRecord::Base
  has_many :imports
  has_many :group_ratings
  has_many :payroll_calculations

end
