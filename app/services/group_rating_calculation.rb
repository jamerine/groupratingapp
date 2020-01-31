class GroupRatingCalculation
  def initialize account, options={}
    @account = account
    @policy_calculation = account.policy_calculation
    @manual_class_calculations = @policy_calculation&.manual_class_calculations
  end

  def calculate
    @policy_calculation&.calculate_experience
    @policy_calculation&.calculate_premium
    @account&.group_rating
    @account&.group_retro
  end

end