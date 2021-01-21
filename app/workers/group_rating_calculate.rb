class GroupRatingCalculate
  require 'progress_bar/core_ext/enumerable_with_progress'
  include Sidekiq::Worker

  sidekiq_options queue: :group_rating_calculate, retry: 5

  def perform(account_id)
    Account.includes(policy_calculation: [:claim_calculations, :manual_class_calculations, :payroll_calculations, :representative]).find_by(id: account_id)&.calculate
  end
end
