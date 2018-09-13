class RepresentativeAllAccountRating
  include Sidekiq::Worker

  sidekiq_options queue: :group_rating_all_create, retry: 0

  def perform(representative_id)
    representative = Representative.find_by(id: representative_id)

    representative.accounts.each do |account|
      GroupRatingCalculation.new(account).calculate
    end
  end

end