class PolicyCoverageUpdateCreateProcess
  include Sidekiq::Worker

  sidekiq_options queue: :policy_coverage_update_create_process


  def perform(group_rating_id)
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Policies Coverage Updating"
    @group_rating.save
    ProcessPolicyCoverageStatusHistory.where(representative_number: @group_rating.process_representative).order("policy_number asc").find_each do |policy_coverage|
        @policy_calculation = PolicyCalculation.find_by(policy_number: policy_coverage.policy_number, representative_number: policy_coverage.representative_number)
        PolicyCoverageUpdateCreate.perform_async(
          @policy_calculation.id,
          @policy_calculation.representative_id,
          @policy_calculation.representative_number,
          @policy_calculation.policy_type,
          @policy_calculation.policy_number,
          policy_coverage.coverage_effective_date,
          policy_coverage.coverage_end_date,
          policy_coverage.coverage_status,
          policy_coverage.lapse_days,
          policy_coverage.data_source
        )
    end


    ManualClassUpdateCreateProcess.perform_async(group_rating_id, @group_rating.representative_id)

  end

end
