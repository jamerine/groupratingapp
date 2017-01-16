class GroupRatingMarkComplete
  include Sidekiq::Worker

  sidekiq_options queue: :group_rating_mark_complete

  def perform(group_rating_id)
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Completed"
    @group_rating.save
  end

end
