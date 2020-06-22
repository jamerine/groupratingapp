class ImportMiraFilesProcess
  include Sidekiq::Worker
  sidekiq_options queue: :import_mira_files_process, retry: 3

  def perform(representative_number, representative_abbreviated_name)
    Mira.by_representative(representative_number).delete_all
    WeeklyMira.by_representative(representative_number).delete_all

    import_file("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/MIRA2FILE", 'miras')
    import_file("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/MIRA2FILW", 'weekly_miras')

    Mira.by_representative(representative_number).by_record_type.find_each do |mira|
      record = MiraDetailRecord.find_or_create_by({ representative_number:    mira.representative_number,
                                                    record_type:              mira.record_type,
                                                    requestor_number:         mira.requestor_number,
                                                    claim_number:             mira.claim_number,
                                                    policy_number:            mira.policy_number,
                                                    business_sequence_number: mira.business_sequence_number
                                                  })
      record.update_attributes(gather_attributes(mira))
    end

    WeeklyMira.by_representative(representative_number).by_record_type.find_each do |mira|
      record = WeeklyMiraDetailRecord.find_or_create_by({ representative_number:    mira.representative_number,
                                                          record_type:              mira.record_type,
                                                          claim_number:             mira.claim_number,
                                                          requestor_number:         mira.requestor_number,
                                                          policy_number:            mira.policy_number,
                                                          business_sequence_number: mira.business_sequence_number
                                                        })
      record.update_attributes(gather_attributes(mira))
    end
  end

  def import_file(url, table_name)
    require 'open-uri'

    begin
      puts "Start Time: " + Time.new.inspect
      conn = ActiveRecord::Base.connection
      rc   = conn.raw_connection
      rc.exec("COPY " + table_name + " (single_rec) FROM STDIN WITH DELIMITER AS '|'")

      file = open(url)

      until file.eof?
        # Add row to copy data
        line = file.readline
        if line[40, 4] == "0000"
          #puts "incorrect characters"
        else
          puts 'Reading....'
          rc.put_copy_data(line)
        end
      end

      # We are done adding copy data
      rc.put_copy_end
      # Display any error messages
      while (res = rc.get_result)
        if e_message = res.error_message
          p e_message
        end
      end

    rescue OpenURI::HTTPError => e
      rc.put_copy_end unless rc.nil?

      puts "Skipped File..."
    end

    puts "End Time: " + Time.new.inspect
  end

  def gather_attributes(mira)
    { valid_policy_number:                                    mira.valid_policy_number,
      claim_indicator:                                        mira.claim_indicator,
      claim_injury_date:                                      mira.claim_injury_date,
      claim_filing_date:                                      mira.claim_filing_date,
      claim_hire_date:                                        mira.claim_hire_date,
      gender:                                                 mira.gender,
      marital_status:                                         mira.marital_status,
      injured_worked_represented:                             mira.injured_worked_represented,
      claim_status:                                           mira.claim_status,
      claim_status_effective_date:                            mira.claim_status_effective_date,
      claimant_name:                                          mira.claimant_name,
      claim_manual_number:                                    mira.claim_manual_number,
      claim_sub_manual_number:                                mira.claim_sub_manual_number,
      industry_code:                                          mira.industry_code,
      claim_type:                                             mira.claim_type,
      claimant_date_of_birth:                                 mira.claimant_date_of_birth,
      claimant_age_at_injury:                                 mira.claimant_age_at_injury,
      claimant_date_of_death:                                 mira.claimant_date_of_death,
      claim_activity_status:                                  mira.claim_activity_status,
      claim_activity_status_effective_date:                   mira.claim_activity_status_effective_date,
      prediction_status:                                      mira.prediction_status,
      prediction_close_status_effective_date:                 mira.prediction_close_status_effective_date,
      claimant_zip_code:                                      mira.claimant_zip_code,
      catastrophic_claim:                                     mira.catastrophic_claim,
      icd1_code:                                              mira.icd1_code,
      icd1_code_type:                                         mira.icd1_code_type,
      icd2_code:                                              mira.icd2_code,
      icd2_code_type:                                         mira.icd2_code_type,
      icd3_code:                                              mira.icd3_code,
      icd3_code_type:                                         mira.icd3_code_type,
      average_weekly_wage:                                    mira.average_weekly_wage,
      claim_handicap_percent:                                 mira.claim_handicap_percent,
      claim_handicap_percent_effective_date:                  mira.claim_handicap_percent_effective_date,
      chiropractor:                                           mira.chiropractor,
      physical_therapy:                                       mira.physical_therapy,
      salary_continuation:                                    mira.salary_continuation,
      last_date_worked:                                       mira.last_date_worked,
      estimated_return_to_work_date:                          mira.estimated_return_to_work_date,
      return_to_work_date:                                    mira.return_to_work_date,
      mmi_date:                                               mira.mmi_date,
      last_medical_date_of_service:                           mira.last_medical_date_of_service,
      last_indemnity_period_end_date:                         mira.last_indemnity_period_end_date,
      injury_or_litigation_type:                              mira.injury_or_litigation_type,
      medical_ambulance_payments:                             mira.medical_ambulance_payments,
      medical_clinic_or_nursing_home_payments:                mira.medical_clinic_or_nursing_home_payments,
      medical_court_cost_payments:                            mira.medical_court_cost_payments,
      medical_doctors_payments:                               mira.medical_doctors_payments,
      medical_drug_and_pharmacy_payments:                     mira.medical_drug_and_pharmacy_payments,
      medical_emergency_room_payments:                        mira.medical_emergency_room_payments,
      medical_funeral_payments:                               mira.medical_funeral_payments,
      medical_hospital_payments:                              mira.medical_hospital_payments,
      medical_medical_device_payments:                        mira.medical_medical_device_payments,
      medical_misc_payments:                                  mira.medical_misc_payments,
      medical_nursing_services_payments:                      mira.medical_nursing_services_payments,
      medical_prostheses_device_payments:                     mira.medical_prostheses_device_payments,
      medical_prostheses_exam_payments:                       mira.medical_prostheses_exam_payments,
      medical_travel_payments:                                mira.medical_travel_payments,
      medical_x_rays_and_radiology_payments:                  mira.medical_x_rays_and_radiology_payments,
      total_medical_paid:                                     mira.total_medical_paid,
      medical_reserve_prediction:                             mira.medical_reserve_prediction,
      total_medical_reserve_amount:                           mira.total_medical_reserve_amount,
      indemnity_change_of_occupation_payments:                mira.indemnity_change_of_occupation_payments,
      indemnity_change_of_occupation_reserve_prediction:      mira.indemnity_change_of_occupation_reserve_prediction,
      indemnity_change_of_occupation_reserve_amount:          mira.indemnity_change_of_occupation_reserve_amount,
      indemnity_death_benefit_payments:                       mira.indemnity_death_benefit_payments,
      indemnity_death_benefit_reserve_prediction:             mira.indemnity_death_benefit_reserve_prediction,
      indemnity_death_benefit_reserve_amount:                 mira.indemnity_death_benefit_reserve_amount,
      indemnity_facial_disfigurement_payments:                mira.indemnity_facial_disfigurement_payments,
      indemnity_facial_disfigurement_reserve_prediction:      mira.indemnity_facial_disfigurement_reserve_prediction,
      indemnity_facial_disfigurement_reserve_amount:          mira.indemnity_facial_disfigurement_reserve_amount,
      indemnity_living_maintenance_payments:                  mira.indemnity_living_maintenance_payments,
      indemnity_living_maintenance_wage_loss_payments:        mira.indemnity_living_maintenance_wage_loss_payments,
      indemnity_living_maintenance_reserve_prediction:        mira.indemnity_living_maintenance_reserve_prediction,
      indemnity_living_maintenance_reserve_amount:            mira.indemnity_living_maintenance_reserve_amount,
      indemnity_permanent_partial_payments:                   mira.indemnity_permanent_partial_payments,
      indemnity_percent_permanent_partial_payments:           mira.indemnity_percent_permanent_partial_payments,
      indemnity_percent_permanent_partial_reserve_prediction: mira.indemnity_percent_permanent_partial_reserve_prediction,
      indemnity_percent_permanent_partial_reserve_amount:     mira.indemnity_percent_permanent_partial_reserve_amount,
      indemnity_ptd_payments:                                 mira.indemnity_ptd_payments,
      indemnity_ptd_reserve_prediction:                       mira.indemnity_ptd_reserve_prediction,
      indemnity_ptd_reserve_amount:                           mira.indemnity_ptd_reserve_amount,
      temporary_total_payments:                               mira.temporary_total_payments,
      temporary_partial_payments:                             mira.temporary_partial_payments,
      wage_loss_payments:                                     mira.wage_loss_payments,
      indemnity_temporary_total_reserve_prediction:           mira.indemnity_temporary_total_reserve_prediction,
      indemnity_temporary_total_reserve_amount:               mira.indemnity_temporary_total_reserve_amount,
      indemnity_lump_sum_settlement_payments:                 mira.indemnity_lump_sum_settlement_payments,
      indemnity_attorney_fee_payments:                        mira.indemnity_attorney_fee_payments,
      indemnity_other_benefit_payments:                       mira.indemnity_other_benefit_payments,
      total_indemnity_paid_amount:                            mira.total_indemnity_paid_amount,
      total_indemnity_reserve_amount:                         mira.total_indemnity_reserve_amount,
      total_original_reserve_amount:                          mira.total_original_reserve_amount,
      reduction_amount:                                       mira.reduction_amount,
      total_reserve_amount_for_rates:                         mira.total_reserve_amount_for_rates,
      reduction_reason:                                       mira.reduction_reason }
  end
end
