class GroupRatingCalculation
  def initialize account
    @account = account
  end

  def calculate
    @account.policy_calculation.calculate_experience
    @account.policy_calculation.calculate_premium
    @account.group_rating
    @account.group_retro
  end
end