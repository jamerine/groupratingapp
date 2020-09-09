class GroupRatingCalculate
  require 'progress_bar/core_ext/enumerable_with_progress'
  include Sidekiq::Worker

  sidekiq_options queue: :group_rating_calculate, retry: 3

  def perform(account_id)
    account = Account.includes(:policy_calculation).find_by(id: account_id)

    return unless account.present? && account.policy_calculation.present?

    account.policy_calculation.calculate_experience
    account.policy_calculation.calculate_premium
    account.group_rating
    account.group_retro
  end
end
