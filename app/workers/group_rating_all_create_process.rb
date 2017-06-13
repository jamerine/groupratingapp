class GroupRatingAllCreateProcess
  include Sidekiq::Worker

  sidekiq_options queue: :group_rating_all_create_process, retry: 1

  def perform(group_rating_id, all_process=nil)
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Combined Updated Process"
    @group_rating.save
    FinalEmployerDemographicsInformation.order("policy_number asc").find_each do |policy_demographic|
      GroupRatingAllCreate.perform_async(@group_rating.id, @group_rating.experience_period_lower_date, @group_rating.process_representative, @group_rating.representative_id, policy_demographic.policy_number)
    end
    GroupRatingMarkComplete.perform_async(@group_rating.id, all_process)
  end

end
