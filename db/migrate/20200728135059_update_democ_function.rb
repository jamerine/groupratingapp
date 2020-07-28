class UpdateDemocFunction < ActiveRecord::Migration
  def up
    connection.execute(%q{
   CREATE OR REPLACE FUNCTION public.proc_process_flat_democs()
  RETURNS void AS
$BODY$

  BEGIN
  /***************************************************************************/
  -- START OF DEMOC


  /* Detail Record Type 02 */

  INSERT INTO democ_detail_records (
    representative_number,
    representative_type,
    record_type,
    requestor_number,
    policy_type,
    policy_number,
    business_sequence_number,
    valid_policy_number,
    current_policy_status,
    current_policy_status_effective_date,
    policy_year,
    policy_year_rating_plan,
    claim_indicator,
    claim_number,
    claim_injury_date,
    claim_combined,
    combined_into_claim_number,
    claim_rating_plan_indicator,
    claim_status,
    claim_status_effective_date,
    claimant_name,
    claim_manual_number,
    claim_sub_manual_number,
    claim_type,
    claimant_date_of_birth,
    claimant_date_of_death,
    claim_activity_status,
    claim_activity_status_effective_date,
    settled_claim,
    settlement_type,
    medical_settlement_date,
    indemnity_settlement_date,
    maximum_medical_improvement_date,
    last_paid_medical_date,
    last_paid_indemnity_date,
    average_weekly_wage,
    full_weekly_wage,
    claim_handicap_percent,
    claim_handicap_percent_effective_date,
    claim_mira_ncci_injury_type,
    claim_medical_paid,
    claim_mira_medical_reserve_amount,
    claim_mira_non_reducible_indemnity_paid,
    claim_mira_reducible_indemnity_paid,
    claim_mira_indemnity_reserve_amount,
    industrial_commission_appeal_indicator,
    claim_mira_non_reducible_indemnity_paid_2,
    claim_total_subrogation_collected,
    non_at_fault,
    enhanced_care_program_indicator,
    enhanced_care_program_indicator_effective_date
  )
  (select
    cast_to_int(substring(single_rec,1,6)),   /*  representative_number  */
    cast_to_int(substring(single_rec,8,2)),   /*  representative_type  */
    cast_to_int(substring(single_rec,10,2)),   /*  record_type  */
    cast_to_int(substring(single_rec,12,3)),   /*  requestor_number  */
    CASE WHEN cast_to_int(substring(single_rec,15,1)) = 0 THEN 'private_state_fund'
         WHEN cast_to_int(substring(single_rec,15,1)) = 1 THEN 'public_state_fund'
         WHEN cast_to_int(substring(single_rec,15,1)) = 2 THEN 'private_self_insured'
         WHEN cast_to_int(substring(single_rec,15,1)) = 3 THEN 'public_app_fund'
         ELSE substring(single_rec,15,1)
         END,   /*  policy_type  */
    cast_to_int(substring(single_rec,15,1) || substring(single_rec,16,7)),   /*  policy_number  */
    cast_to_int(substring(single_rec,24,3)),   /*  business_sequence_number  */
    substring(single_rec,27,1),   /*  valid_policy_number  */
    substring(single_rec,28,5),   /*  current_policy_status  */
    case when substring(single_rec,33,8) > '00000000' THEN to_date(substring(single_rec,33,8), 'YYYYMMDD')
      else null
    end,  /*  current_policy_status_effective_date  */
    cast_to_int(substring(single_rec,41,4)),   /*  policy_year  */
    substring(single_rec,45,5),   /*  policy_year_rating_plan  */
    substring(single_rec,50,1),   /*  claim_indicator  */
    substring(single_rec,51,10),   /*  claim_number  */
    case when substring(single_rec,61,8) > '00000000' THEN to_date(substring(single_rec,61,8), 'YYYYMMDD')
      else null
    end,  /*  claim_injury_date  */
    substring(single_rec,69,1),   /*  claim_combined  */
    substring(single_rec,70,10),   /*  combined_into_claim_number  */
    substring(single_rec,80,1),   /*  claim_rating_plan_indicator  */
    substring(single_rec,81,2),   /*  claim_status  */
    case when substring(single_rec,83,8) > '00000000' THEN to_date(substring(single_rec,83,8), 'YYYYMMDD')
      else null
    end,  /*  claim_status_effective_date  */
     substring(single_rec,91,20),   /*  claimant_name  */
    cast_to_int(substring(single_rec,111,4)),   /*  claim_manual_number  */
    substring(single_rec,115,2),   /*  claim_sub_manual_number  */
    substring(single_rec,117,4),   /*  claim_type  */
     case when substring(single_rec,121,8) > '00000000' THEN to_date(substring(single_rec,121,8), 'YYYYMMDD')
      else null
     end,  /*  claimant_date_of_birth  */
    case when substring(single_rec,129,8) > '00000000' THEN to_date(substring(single_rec,129,8), 'YYYYMMDD')
      else null
    end, /*  claimant_date_of_death  */
    substring(single_rec,137,1),   /*  claim_activity_status  */
    case when substring(single_rec,138,8) > '00000000' THEN to_date(substring(single_rec,138,8), 'YYYYMMDD')
      else null
    end,  /*  claim_activity_status_effective_date  */
    substring(single_rec,146,1),   /*  settled_claim  */
    substring(single_rec,147,1),   /*  settlement_type  */
    case when substring(single_rec,148,8) > '00000000' THEN to_date(substring(single_rec,148,8), 'YYYYMMDD')
      else null
    end,   /*  medical_settlement_date  */
    case when substring(single_rec,156,8) > '00000000' THEN to_date(substring(single_rec,156,8), 'YYYYMMDD')
      else null
    end,   /*  indemnity_settlement_date  */
    case when substring(single_rec,164,8) > '00000000' THEN to_date(substring(single_rec,164,8), 'YYYYMMDD')
      else null
    end,   /*  maximum_medical_improvement_date  */
    case when substring(single_rec,172,8) > '00000000' THEN to_date(substring(single_rec,172,8), 'YYYYMMDD')
      else null
    end,   /*  last_paid_medical_date  */
    case when substring(single_rec,180,8) > '00000000' THEN to_date(substring(single_rec,180,8), 'YYYYMMDD')
      else null
    end,   /*  last_paid_indemnity_date  */
    CASE when substring(single_rec,188,8) > '0' THEN cast(substring(single_rec,188,8) as numeric)
    ELSE null
    end,  /*  average_weekly_wage  */
    CASE when substring(single_rec,196,8) > '0' THEN cast(substring(single_rec,196,8) as numeric)
    ELSE null
    end,   /*  full_weekly_wage  */
    substring(single_rec,204,3),   /*  claim_handicap_percent  */
    case when substring(single_rec,207,8) > '00000000' THEN to_date(substring(single_rec,207,8), 'YYYYMMDD')
      else null
    end,   /*  claim_handicap_percent_effective_date  */
    substring(single_rec,215,2),   /*  claim_mira_ncci_injury_type  */
    cast_to_int(substring(single_rec,217,7)), /*  claim_medical_paid  */
    cast_to_int(substring(single_rec,225,7)),   /*  claim_mira_medical_reserve_amount  */
    cast_to_int(substring(single_rec,233,7)),   /*  claim_mira_non_reducible_indemnity_paid  */
    cast_to_int(substring(single_rec,241,7)),   /*  claim_mira_reducible_indemnity_paid  */
    cast_to_int(substring(single_rec,249,7)),   /*  claim_mira_indemnity_reserve_amount  */
    substring(single_rec,257,1),   /*  industrial_commission_appeal_indicator  */
    cast_to_int(substring(single_rec,258,7)),   /*  claim_mira_non_reducible_indemnity_paid_2  */
    cast_to_int(substring(single_rec,266,7)),   /*  claim_total_subrogation_collected  */
    substring(single_rec,274,1),  /*  non_at_fault  */
    substring(single_rec,292,1),  /*  enhanced_care_program_indicator  */
    case when substring(single_rec,293,8) > '00000000' THEN to_date(substring(single_rec,293,8), 'YYYYMMDD')
      else null
    end   /*  enhanced_care_program_indicator_effective_date  */

  from democs WHERE substring(single_rec,10,2) = '02');




  end;

    $BODY$
  LANGUAGE plpgsql;

    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_process_flat_democ;
    })
  end
end
