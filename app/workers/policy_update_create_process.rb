class PolicyUpdateCreateProcess
  include Sidekiq::Worker

  sidekiq_options queue: :policy_update_create_process


  def perform(group_rating_id)
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Policies Updating"
    @group_rating.save
    FinalPolicyExperienceCalculation.order("policy_number asc").find_each do |policy_exp|
        policy_proj_id = FinalPolicyGroupRatingAndPremiumProjection.find_by(policy_number: policy_exp.policy_number, representative_number: policy_exp.representative_number).id
        policy_demographic_id = FinalEmployerDemographicsInformation.find_by(policy_number: policy_exp.policy_number, representative_number: policy_exp.representative_number).id
        representative_id = Representative.find_by(representative_number: policy_exp.representative_number).id
        PolicyUpdateCreate.perform_async(policy_exp.id, policy_proj_id, policy_demographic_id, representative_id)
    end

    ManualClassUpdateCreateProcess.perform_async(group_rating_id)

  end

end
