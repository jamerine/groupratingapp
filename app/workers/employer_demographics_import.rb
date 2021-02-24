class EmployerDemographicsImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file, retry: 5

  def perform(data_hash, representative_id)
    data_hash = data_hash.with_indifferent_access

    if representative_id.present? && data_hash.present?
      begin
        @demo_data = EmployerDemographic.find_or_initialize_by(representative_id: representative_id,
                                                               employer_state:    data_hash[:state_code],
                                                               policy_number:     data_hash[:policy_number])

        @demo_data.assign_attributes(data_hash.except(:"15k_program_indicator",
                                                      :policy_original_effective_date,
                                                      :policy_period_beginning_date,
                                                      :policy_period_ending_date,
                                                      :mco_relationship_beginning_date,
                                                      :status_reason_effective_date))

        @demo_data.fifteen_program_indicator       = data_hash[:"15k_program_indicator"]
        @demo_data.policy_original_effective_date  = DateTime.strptime(data_hash[:policy_original_effective_date], '%m/%d/%Y')
        @demo_data.policy_period_beginning_date    = DateTime.strptime(data_hash[:policy_period_beginning_date], '%m/%d/%Y')
        @demo_data.policy_period_ending_date       = DateTime.strptime(data_hash[:policy_period_ending_date], '%m/%d/%Y')
        @demo_data.status_reason_effective_date    = DateTime.strptime(data_hash[:status_reason_effective_date], '%m/%d/%Y')
        @demo_data.mco_relationship_beginning_date = DateTime.strptime(data_hash[:mco_relationship_beginning_date], '%m/%d/%Y')

        @demo_data.save!
      rescue => e
        binding.pry
      end
    end
  end
end
