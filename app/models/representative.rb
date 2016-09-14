class Representative < ActiveRecord::Base
  has_many :imports, dependent: :destroy
  has_many :group_ratings, dependent: :destroy
  has_many :payroll_calculations, dependent: :destroy
  has_many :policy_calculations, dependent: :destroy
  has_many :manual_class_calculations, :through => :policy_calculations



  # def fee_calculation(policy_calculation_id)
  #   @policy_calculation = PolicyCalculation.find(policy_calculation_id)
  #
  #     if @policy_calculation.policy_total_individual_premium.nil? || @policy_calculation.policy_total_group_savings.nil?
  #       return nil
  #     end
  #
  #     if @policy_calculation.group_rating_tier.nil?
  #       return (@policy_calculation.policy_total_individual_premium * 0.035)
  #     elsif @policy_calculation.group_rating_tier < -0.35
  #       return (@policy_calculation.policy_total_group_savings * 0.0415)
  #     else
  #       return (@policy_calculation.policy_total_individual_premium * 0.0275)
  #     end
  # end


  

end
