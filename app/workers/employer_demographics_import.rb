class EmployerDemographicsImport
  include Sidekiq::Worker

  sidekiq_options queue: :employer_demographics_import, retry: 5

  def perform(data_hash)
    data_hash = data_hash.with_indifferent_access

    if data_hash.present?
      @demo_data = EmployerDemographic.find_or_initialize_by(employer_state:    'OH',
                                                             policy_number:     data_hash[:policy_number])

      @demo_data.assign_attributes(data_hash.except(:"15k_program_indicator",
                                                    :policy_original_effective_date,
                                                    :policy_period_beginning_date,
                                                    :policy_period_ending_date,
                                                    :mco_relationship_beginning_date,
                                                    :status_reason_effective_date))

      @demo_data.fifteen_program_indicator       = data_hash[:"15k_program_indicator"]
      @demo_data.policy_original_effective_date  = DateTime.strptime(data_hash[:policy_original_effective_date], '%m/%d/%Y') if data_hash[:policy_original_effective_date].present?
      @demo_data.policy_period_beginning_date    = DateTime.strptime(data_hash[:policy_period_beginning_date], '%m/%d/%Y') if data_hash[:policy_period_beginning_date].present?
      @demo_data.policy_period_ending_date       = DateTime.strptime(data_hash[:policy_period_ending_date], '%m/%d/%Y') if data_hash[:policy_period_ending_date].present?
      @demo_data.status_reason_effective_date    = DateTime.strptime(data_hash[:status_reason_effective_date], '%m/%d/%Y') if data_hash[:status_reason_effective_date].present?
      @demo_data.mco_relationship_beginning_date = DateTime.strptime(data_hash[:mco_relationship_beginning_date], '%m/%d/%Y') if data_hash[:mco_relationship_beginning_date].present?

      @demo_data.save!
    end
  end
end
