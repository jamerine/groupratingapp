class RepresentativeAllAccountRating
  require 'progress_bar/core_ext/enumerable_with_progress'
  include Sidekiq::Worker

  sidekiq_options queue: :representative_all_account_rating, retry: 0

  def perform(representative_id)
    representative = Representative.find_by(id: representative_id)

    representative.accounts.pluck(:id).each_with_progress do |account_id|
      GroupRatingCalculate.perform_async(account_id)
    end
  end
end