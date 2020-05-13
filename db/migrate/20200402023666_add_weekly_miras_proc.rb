class AddWeeklyMirasProc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_process_flat_weekly_miras()
       RETURNS void AS
      $BODY$

      BEGIN
      /***************************************************************************/
      -- START OF weekly_mira
      /* Detail Record Type 02 */
      INSERT INTO weekly_mira_detail_records (
        representative_number,
        record_type,
        requestor_number,
        policy_number,
        business_sequence_number,
        valid_policy_number,
        claim_indicator,
        claim_number,
        claim_injury_date,
        claim_filing_date,
        claim_hire_date,
        gender,
        marital_status,
        injured_worked_represented,
        claim_status,
        claim_status_effective_date,
        claimant_name,
        claim_manual_number,
        claim_sub_manual_number,
        industry_code,
        claim_type,
        claimant_date_of_birth,
        claimant_age_at_injury,
        claimant_date_of_death,
        claim_activity_status,
        claim_activity_status_effective_date,
        prediction_status,
        prediction_close_status_effective_date,
        claimant_zip_code,
        catastrophic_claim,
        icd1_code,
        icd1_code_type,
        icd2_code,
        icd2_code_type,
        icd3_code,
        icd3_code_type,
        average_weekly_wage,
        claim_handicap_percent,
        claim_handicap_percent_effective_date,
        chiropractor,
        physical_therapy,
        salary_continuation,
        last_date_worked,
        estimated_return_to_work_date,
        return_to_work_date,
        mmi_date,
        last_medical_date_of_service,
        last_indemnity_period_end_date,
        injury_or_litigation_type,
        medical_ambulance_payments,
        medical_clinic_or_nursing_home_payments,
        medical_court_cost_payments,
        medical_doctors_payments,
        medical_drug_and_pharmacy_payments,
        medical_emergency_room_payments,
        medical_funeral_payments,
        medical_hospital_payments,
        medical_medical_device_payments,
        medical_misc_payments,
        medical_nursing_services_payments,
        medical_prostheses_device_payments,
        medical_prostheses_exam_payments,
        medical_travel_payments,
        medical_x_rays_and_radiology_payments,
        total_medical_paid,
        medical_reserve_prediction,
        total_medical_reserve_amount,
        indemnity_change_of_occupation_payments,
        indemnity_change_of_occupation_reserve_prediction,
        indemnity_change_of_occupation_reserve_amount,
        indemnity_death_benefit_payments,
        indemnity_death_benefit_reserve_prediction,
        indemnity_death_benefit_reserve_amount,
        indemnity_facial_disfigurement_payments,
        indemnity_facial_disfigurement_reserve_prediction,
        indemnity_facial_disfigurement_reserve_amount,
        indemnity_living_maintenance_payments,
        indemnity_living_maintenance_wage_loss_payments,
        indemnity_living_maintenance_reserve_prediction,
        indemnity_living_maintenance_reserve_amount,
        indemnity_permanent_partial_payments,
        indemnity_percent_permanent_partial_payments,
        indemnity_percent_permanent_partial_reserve_prediction,
        indemnity_percent_permanent_partial_reserve_amount,
        indemnity_ptd_payments,
        indemnity_ptd_reserve_prediction,
        indemnity_ptd_reserve_amount,
        temporary_total_payments,
        temporary_partial_payments,
        wage_loss_payments,
        indemnity_temporary_total_reserve_prediction,
        indemnity_temporary_total_reserve_amount,
        indemnity_lump_sum_settlement_payments,
        indemnity_attorney_fee_payments,
        indemnity_other_benefit_payments,
        total_indemnity_paid_amount,
        total_indemnity_reserve_amount,
        total_original_reserve_amount,
        reduction_amount,
        total_reserve_amount_for_rates,
        reduction_reason,
        created_at,
        updated_at
      )
      (
      SELECT
        cast_to_int(substring(single_rec,1,6)) /* representative_number */,
        cast_to_int(substring(single_rec,10,2)) /* record_type */,
        cast_to_int(substring(single_rec,12,3)) /* requestor_number */,
        cast_to_int(substring(single_rec,15,1) || substring(single_rec,16,7)) /* policy_number */,
        cast_to_int(substring(single_rec,24,3)) /* business_sequence_number */,
        substring(single_rec,27,1) /* valid_policy_number */,
        substring(single_rec,28,1) /* claim_indicator */,
        substring(single_rec,29,10) /* claim_number */,
        CASE WHEN substring(single_rec,39,8) > '00000000' THEN to_date(substring(single_rec,39,8), 'YYYYMMDD')
            ELSE null
        END /* claim_injury_date */,
        CASE WHEN substring(single_rec,47,8) > '00000000' THEN to_date(substring(single_rec,47,8), 'YYYYMMDD')
            ELSE null
        END /* claim_filing_date */,
        CASE WHEN substring(single_rec,55,8) > '00000000' THEN to_date(substring(single_rec,55,8), 'YYYYMMDD')
            ELSE null
        END /* claim_hire_date */,
        substring(single_rec,63,1) /* gender */,
        substring(single_rec,64,1) /* marital_status */,
        substring(single_rec,65,1) /* injured_worked_represented */,
        substring(single_rec,66,2) /* claim_status */,
        CASE WHEN substring(single_rec,68,8) > '00000000' THEN to_date(substring(single_rec,68,8), 'YYYYMMDD')
            ELSE null
        END /* claim_status_effective_date */,
        substring(single_rec,76,20) /* claimant_name */,
        cast_to_int(substring(single_rec,96,4)) /* claim_manual_number */,
        cast_to_int(substring(single_rec,100,2)) /* claim_sub_manual_number */,
        cast_to_int(substring(single_rec,102,2)) /* industry_code */,
        cast_to_int(substring(single_rec,104,4)) /* claim_type */,
        CASE WHEN substring(single_rec,108,8) > '00000000' THEN to_date(substring(single_rec,108,8), 'YYYYMMDD')
            ELSE null
        END /* claimant_date_of_birth */,
        substring(single_rec,116,2) /* claimant_age_at_injury */,
        CASE WHEN substring(single_rec,118,8) > '00000000' THEN to_date(substring(single_rec,118,8), 'YYYYMMDD')
            ELSE null
        END /* claimant_date_of_death */,
        substring(single_rec,126,1) /* claim_activity_status */,
        CASE WHEN substring(single_rec,127,8) > '00000000' THEN to_date(substring(single_rec,127,8), 'YYYYMMDD')
            ELSE null
        END /* claim_activity_status_effective_date */,
        substring(single_rec,135,1) /* prediction_status */,
        CASE WHEN substring(single_rec,136,8) > '00000000' THEN to_date(substring(single_rec,136,8), 'YYYYMMDD')
            ELSE null
        END /* prediction_close_status_effective_date */,
        substring(single_rec,144,5) /* claimant_zip_code */,
        substring(single_rec,149,1) /* catastrophic_claim */,
        cast_to_numeric(substring(single_rec,150,8)) /* icd1_code */,
        substring(single_rec,158,1) /* icd1_code_type */,
        cast_to_numeric(substring(single_rec,159,8)) /* icd2_code */,
        substring(single_rec,167,1) /* icd2_code_type */,
        cast_to_numeric(substring(single_rec,168,8)) /* icd3_code */,
        substring(single_rec,176,1) /* icd3_code_type */,
        CASE WHEN substring(single_rec,177,8) > '0' THEN cast(substring(single_rec,177,8) as numeric)
          ELSE null
        END /* average_weekly_wage */,
        substring(single_rec,185,3)::numeric/100 /* claim_handicap_percent */,
        CASE WHEN substring(single_rec,188,8) > '00000000' THEN to_date(substring(single_rec,188,8), 'YYYYMMDD')
            ELSE null
        END /* claim_handicap_percent_effective_date */,
        substring(single_rec,196,1) /* chiropractor */,
        substring(single_rec,197,1) /* physical_therapy */,
        substring(single_rec,198,1) /* salary_continuation */,
        CASE WHEN substring(single_rec,199,8) > '00000000' THEN to_date(substring(single_rec,199,8), 'YYYYMMDD')
            ELSE null
        END /* last_date_worked */,
        CASE WHEN substring(single_rec,207,8) > '00000000' THEN to_date(substring(single_rec,207,8), 'YYYYMMDD')
            ELSE null
        END /* estimated_return_to_work_date */,
        CASE WHEN substring(single_rec,215,8) > '00000000' THEN to_date(substring(single_rec,215,8), 'YYYYMMDD')
            ELSE null
        END /* return_to_work_date */,
        CASE WHEN substring(single_rec,223,8) > '00000000' THEN to_date(substring(single_rec,223,8), 'YYYYMMDD')
            ELSE null
        END /* mmi_date */,
        CASE WHEN substring(single_rec,231,8) > '00000000' THEN to_date(substring(single_rec,231,8), 'YYYYMMDD')
            ELSE null
        END /* last_medical_date_of_service */,
        CASE WHEN substring(single_rec,239,8) > '00000000' THEN to_date(substring(single_rec,239,8), 'YYYYMMDD')
            ELSE null
        END /* last_indemnity_period_end_date */,
        substring(single_rec,247,2) /* injury_or_litigation_type */,
        cast_to_numeric(substring(single_rec,249,12)) /* medical_ambulance_payments */,
        cast_to_numeric(substring(single_rec,261,12)) /* medical_clinic_or_nursing_home_payments */,
        cast_to_numeric(substring(single_rec,273,12)) /* medical_court_cost_payments */,
        cast_to_numeric(substring(single_rec,285,12)) /* medical_doctors_payments */,
        cast_to_numeric(substring(single_rec,297,12)) /* medical_drug_and_pharmacy_payments */,
        cast_to_numeric(substring(single_rec,309,12)) /* medical_emergency_room_payments */,
        cast_to_numeric(substring(single_rec,321,12)) /* medical_funeral_payments */,
        cast_to_numeric(substring(single_rec,333,12)) /* medical_hospital_payments */,
        cast_to_numeric(substring(single_rec,345,12)) /* medical_medical_device_payments */,
        cast_to_numeric(substring(single_rec,357,12)) /* medical_misc_payments */,
        cast_to_numeric(substring(single_rec,369,12)) /* medical_nursing_services_payments */,
        cast_to_numeric(substring(single_rec,381,12)) /* medical_prostheses_device_payments */,
        cast_to_numeric(substring(single_rec,393,12)) /* medical_prostheses_exam_payments */,
        cast_to_numeric(substring(single_rec,405,12)) /* medical_travel_payments */,
        cast_to_numeric(substring(single_rec,417,12)) /* medical_x_rays_and_radiology_payments */,
        cast_to_numeric(substring(single_rec,429,12)) /* total_medical_paid */,
        substring(single_rec,441,1) /* medical_reserve_prediction */,
        cast_to_numeric(substring(single_rec,442,12)) /* total_medical_reserve_amount */,
        cast_to_numeric(substring(single_rec,454,12)) /* indemnity_change_of_occupation_payments */,
        substring(single_rec,466,1) /* indemnity_change_of_occupation_reserve_prediction */,
        cast_to_numeric(substring(single_rec,467,12)) /* indemnity_change_of_occupation_reserve_amount */,
        cast_to_numeric(substring(single_rec,479,12)) /* indemnity_death_benefit_payments */,
        substring(single_rec,491,1) /* indemnity_death_benefit_reserve_prediction */,
        cast_to_numeric(substring(single_rec,492,12)) /* indemnity_death_benefit_reserve_amount */,
        cast_to_numeric(substring(single_rec,504,12)) /* indemnity_facial_disfigurement_payments */,
        substring(single_rec,516,1) /* indemnity_facial_disfigurement_reserve_prediction */,
        cast_to_numeric(substring(single_rec,517,12)) /* indemnity_facial_disfigurement_reserve_amount */,
        cast_to_numeric(substring(single_rec,529,12)) /* indemnity_living_maintenance_payments */,
        cast_to_numeric(substring(single_rec,541,12)) /* indemnity_living_maintenance_wage_loss_payments */,
        substring(single_rec,553,1) /* indemnity_living_maintenance_reserve_prediction */,
        cast_to_numeric(substring(single_rec,554,12)) /* indemnity_living_maintenance_reserve_amount */,
        cast_to_numeric(substring(single_rec,566,12)) /* indemnity_permanent_partial_payments */,
        cast_to_numeric(substring(single_rec,578,12)) /* indemnity_percent_permanent_partial_payments */,
        substring(single_rec,590,1) /* indemnity_percent_permanent_partial_reserve_prediction */,
        cast_to_numeric(substring(single_rec,591,12)) /* indemnity_percent_permanent_partial_reserve_amount */,
        cast_to_numeric(substring(single_rec,603,12)) /* indemnity_ptd_payments */,
        substring(single_rec,615,1) /* indemnity_ptd_reserve_prediction */,
        cast_to_numeric(substring(single_rec,616,12)) /* indemnity_ptd_reserve_amount */,
        cast_to_numeric(substring(single_rec,628,12)) /* temporary_total_payments */,
        cast_to_numeric(substring(single_rec,640,12)) /* temporary_partial_payments */,
        cast_to_numeric(substring(single_rec,652,12)) /* wage_loss_payments */,
        substring(single_rec,664,1) /* indemnity_temporary_total_reserve_prediction */,
        cast_to_numeric(substring(single_rec,665,12)) /* indemnity_temporary_total_reserve_amount */,
        cast_to_numeric(substring(single_rec,677,12)) /* indemnity_lump_sum_settlement_payments */,
        cast_to_numeric(substring(single_rec,689,12)) /* indemnity_attorney_fee_payments */,
        cast_to_numeric(substring(single_rec,701,12)) /* indemnity_other_benefit_payments */,
        cast_to_numeric(substring(single_rec,713,12)) /* total_indemnity_paid_amount */,
        cast_to_numeric(substring(single_rec,725,12)) /* total_indemnity_reserve_amount */,
        cast_to_numeric(substring(single_rec,737,12)) /* total_original_reserve_amount */,
        cast_to_numeric(substring(single_rec,737,12)) /* reduction_amount */,
        cast_to_numeric(substring(single_rec,761,12)) /* total_reserve_amount_for_rates */,
        substring(single_rec,773,11) /* reduction_reason */,
        current_timestamp::timestamp as created_at,
        current_timestamp::timestamp as updated_at

       FROM weekly_miras WHERE substring(single_rec,10,2) = '02');

       end;

         $BODY$
       LANGUAGE plpgsql;
    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_process_flat_weekly_miras();
    })
  end
end
