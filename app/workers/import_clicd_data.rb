class ImportClicdData
  require 'progress_bar/core_ext/enumerable_with_progress'
  include Sidekiq::Worker
  sidekiq_options queue: :import_clicd_data, retry: 3

  def perform(clicd_attributes)
    clicd = Clicd.new(clicd_attributes)
    ClicdDetailRecord.where({ representative_number:    clicd.representative_number,
                                          record_type:              clicd.record_type,
                                          requestor_number:         clicd.requestor_number,
                                          business_sequence_number: clicd.business_sequence_number,
                                          policy_number:            clicd.policy_number,
                                          claim_number:             clicd.claim_number,
                                          icd_code:                 clicd.icd_code
                                        }).update_or_create(gather_attributes(clicd))
  end

  def gather_attributes(clicd)
    { valid_policy_number:                  clicd.valid_policy_number,
      current_policy_status:                clicd.current_policy_status,
      current_policy_status_effective_date: clicd.current_policy_status_effective_date,
      policy_year:                          clicd.policy_year,
      policy_year_rating_plan:              clicd.policy_year_rating_plan,
      claim_indicator:                      clicd.claim_indicator,
      icd_codes_assigned:                   clicd.icd_codes_assigned,
      icd_status:                           clicd.icd_status,
      icd_status_effective_date:            clicd.icd_status_effective_date,
      icd_injury_location_code:             clicd.icd_injury_location_code,
      icd_digit_tooth_number:               clicd.icd_digit_tooth_number,
      primary_icd:                          clicd.primary_icd }
  end
end
