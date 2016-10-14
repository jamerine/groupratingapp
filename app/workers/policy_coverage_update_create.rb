class PolicyCoverageUpdateCreate
  include Sidekiq::Worker

  sidekiq_options queue: :policy_coverage_update_create


  def perform(policy_calculation_id, representative_id, representative_number, policy_type, policy_number, coverage_effective_date, coverage_end_date, coverage_status, lapse_days, data_source)
    PolicyCoverageStatusHistory.where(policy_calculation_id: policy_calculation_id, policy_number: policy_number, representative_number: representative_number, coverage_effective_date: coverage_effective_date, coverage_end_date: coverage_end_date, coverage_status: coverage_status, lapse_days: lapse_days).update_or_create(
            policy_calculation_id: policy_calculation_id,
            representative_id: representative_id,
            representative_number: representative_number,
            policy_type: policy_type,
            policy_number: policy_number,
            coverage_effective_date: coverage_effective_date,
            coverage_end_date: coverage_end_date,
            coverage_status: coverage_status,
            lapse_days: lapse_days,
            data_source: data_source
        )
  end

end
