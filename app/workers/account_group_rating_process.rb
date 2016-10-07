class AccountGroupRatingProcess
  include Sidekiq::Worker

  sidekiq_options queue: :account_group_rating_process

  def perform(group_rating_id)
    @group_rating = GroupRating.find(group_rating_id)
    representative_id = Representative.find(@group_rating.representative_id).id
    accounts = Account.where("representative_id = :representative_id", representative_id: representative_id)

    accounts.each do |account|
      AccountGroupRatingCalc.perform_async(account.id)
    end

    ClaimUpdateCreateProcess.perform_async(group_rating_id)
  end

end
