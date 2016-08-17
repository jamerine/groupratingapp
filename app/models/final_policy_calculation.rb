class FinalPolicyCalculation < ActiveRecord::Base

  has_many :final_manual_class_calculations, dependent: :destroy
  
end
