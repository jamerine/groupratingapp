class AccountGroupRatingProcess
  include Sidekiq::Worker

  sidekiq_options queue: :account_group_rating_process

  def perform(group_rating_id)
    @group_rating = GroupRating.find(group_rating_id)
    @group_rating.update_attributes(status: "Account Group Rating Calculating")
    representative_id = Representative.find(@group_rating.representative_id).id
    accounts = Account.where("representative_id = :representative_id", representative_id: representative_id)

    accounts.each do |account|
      account.group_rating
    end

    @group_rating.update_attributes(status: "Completed")
  end

end
