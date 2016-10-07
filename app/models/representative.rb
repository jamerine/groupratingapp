class Representative < ActiveRecord::Base
  has_many :imports, dependent: :destroy
  has_many :group_ratings, dependent: :destroy
  has_many :payroll_calculations, dependent: :destroy
  has_many :policy_calculations, dependent: :destroy
  has_many :manual_class_calculations, :through => :policy_calculations
  has_many :accounts, dependent: :destroy



end
