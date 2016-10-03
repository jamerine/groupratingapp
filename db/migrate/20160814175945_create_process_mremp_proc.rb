class CreateProcessMrempProc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_process_flat_mremps()
        RETURNS void AS
      $BODY$

      BEGIN

      /* Insert Data MREMP of all three tables */
      /* First pass through to grab the Policy Lines (Record_Type 10) */
      INSERT INTO mremp_employee_experience_policy_levels ( representative_number,
                representative_type,
                policy_type,
                policy_number,
                business_sequence_number,
                record_type,
                manual_number,
                sub_manual_number,
                claim_reserve_code,
                claim_number,
                federal_id,
                grand_total_modified_losses,
                grand_total_expected_losses,
                grand_total_limited_losses,
                policy_maximum_claim_size,
                policy_credibility,
                policy_experience_modifier_percent,
                employer_name,
                doing_business_as_name,
                referral_name,
                address,
                city,
                state,
                zip_code,
                print_code,
                policy_year,
                extract_date,
                policy_year_exp_period_beginning_date,
                policy_year_exp_period_ending_date,
                green_year,
                reserves_used_in_the_published_em,
                risk_group_number,
                em_capped_flag,
                capped_em_percentage,
                ocp_flag,
                construction_cap_flag,
                published_em_percentage,
                created_at,
                updated_at
      )
      (select
        cast_to_int(substring(single_rec,1,6)),  /* representative_number */
                cast_to_int(substring(single_rec,8,2)),  /* representative_type */
                CASE WHEN cast_to_int(substring(single_rec,10,1)) = 0 THEN 'private_state_fund'
                     WHEN cast_to_int(substring(single_rec,10,1)) = 1 THEN 'public_state_fund'
                     WHEN cast_to_int(substring(single_rec,10,1)) = 2 THEN 'private_self_insured'
                     WHEN cast_to_int(substring(single_rec,10,1)) = 3 THEN 'public_app_fund'
                     ELSE substring(single_rec,10,1)
                     END,   /*  policy_type  */
                cast_to_int(substring(single_rec,10,1) || substring(single_rec,11,7)),   /*  policy_number  */
                cast_to_int(substring(single_rec,19,3)),  /* business_number  */
                cast_to_int(substring(single_rec,22,2)),  /* record_type  */
                cast_to_int(substring(single_rec,24,4)),  /* manual_number,  */
                substring(single_rec,28,2),  /* sub_manual_number,  */
                substring(single_rec,30,2),  /* claim_reserve_code,  */
                substring(single_rec,32,10),  /* claim_number,  */
                substring(single_rec,42,10),  /* federal_id, */
                cast_to_int(substring(single_rec,52,11)),  /* grand_total_modified_losses,  */
                cast_to_int(substring(single_rec,64,11)),  /* grand_total_expected_losses,  */
                cast_to_int(substring(single_rec,76,11)),  /* grand_total_limited_losses,  */
                cast_to_int(substring(single_rec,88,7)),  /* policy_maximum_claim_size, */
                substring(single_rec,96,3)::numeric/100,  /* policy_credibility, */
                substring(single_rec,100,3)::numeric/100,  /* policy_experience_modifier_percent */
                substring(single_rec,104,34),  /* employer_name,  */
                substring(single_rec,138,34),  /* dba_name,  */
                substring(single_rec,172,34),  /* referral_name,  */
                substring(single_rec,206,34),  /* address,  */
                substring(single_rec,240,24),  /* city, */
                substring(single_rec,264,2),  /* state,  */
                substring(single_rec,266,10),  /* zip_code,  */
                substring(single_rec,276,2),  /* print_code,  */
                cast_to_int(substring(single_rec,278,4)),  /* policy_year,  */
                case when substring(single_rec,282,8) > '00000000' THEN to_date(substring(single_rec,282,8), 'YYYYMMDD')
                  else null
                end,      /* extract_date, */
                case when substring(single_rec,290,8) > '00000000' THEN to_date(substring(single_rec,290,8), 'YYYYMMDD')
                  else null
                end,      /* policy_year_exp_period_beginning_date, */
                case when substring(single_rec,298,8) > '00000000' THEN to_date(substring(single_rec,298,8), 'YYYYMMDD')
                  else null
                end,  /* policy_year_exp_period_ending_date, */
                substring(single_rec,306,4),  /* green_year, */
                substring(single_rec,310,1),  /* reserves_used_in_the_published_em, */
                substring(single_rec,311,5),  /* risk_group_number */
                substring(single_rec,316,1),  /* em_capped_flag */
                substring(single_rec,317,3),  /* capped_em_percentage */
                substring(single_rec,320,1),  /* ocp_flag */
                substring(single_rec,321,1),  /* construction_cap_flag */
                substring(single_rec,322,3)::numeric/1000,  /* published_em_percentage */
                current_timestamp::timestamp as created_at,
                current_timestamp::timestamp as updated_at
      from mremps where substring(single_rec,22,2) = '10');

      /* Second pass through to grab the Manual Class Level Lines (Record_Type 20) */
      INSERT INTO mremp_employee_experience_manual_class_levels (
                representative_number,
                representative_type,
                policy_type,
                policy_number,
                business_sequence_number,
                record_type,
                manual_number,
                sub_manual_number,
                claim_reserve_code,
                claim_number,
                experience_period_payroll,
                manual_class_base_rate,
                manual_class_expected_loss_rate,
                manual_class_expected_losses,
                merit_rated_flag,
                policy_manual_status,
                limited_loss_ratio,
                limited_losses,
      	  created_at,
                Updated_at
                )
      (select
        cast_to_int(substring(single_rec,1,6)),  /* representative_number, */
                cast_to_int(substring(single_rec,8,2)),  /* representative_type */
                cast_to_int(substring(single_rec,10,1)),  /* policy_type */
                cast_to_int(substring(single_rec,11,7)),  /* policy_sequence_number  */
                cast_to_int(substring(single_rec,19,3)),  /* business_sequence_number  */
                cast_to_int(substring(single_rec,22,2)),  /* record_type  */
                cast_to_int(substring(single_rec,24,4)),  /* policy_manual_number,  */
                substring(single_rec,28,2),  /* policy_sub_manual_number,  */
                substring(single_rec,30,2),  /* claim_reserve_code,  */
                substring(single_rec,32,10),  /* claim_number,  */
                cast_to_int(substring(single_rec,42,11)),  /* experience_period_payroll, */
                substring(single_rec,54,5)::numeric/100,  /* manual_class_base_rate,  */
                substring(single_rec,60,5)::numeric/100,  /* manual_class_expected_loss_rate,  */
                cast_to_int(substring(single_rec,66,9)),  /* manual_class_expected_losses,  */
                substring(single_rec,76,1),  /* merit_rated_flag, */
                substring(single_rec,77,2),  /* policy_manual_status, */
                substring(single_rec,79,5)::numeric/10000,  /* limited_loss_ratio */
                cast_to_int(substring(single_rec,85,9)),  /* limited_losses,  */
      	  current_timestamp::timestamp as created_at,
                current_timestamp::timestamp as updated_at
      from mremps WHERE substring(single_rec,22,2) = '20') ;

      /* Third pass through to grab the Manual Class Level Lines (Record_Type 31) */
      /* NOTE: Record_Type 30 has been deprecated.  Denoted mira Reserves */
      INSERT INTO mremp_employee_experience_claim_levels (
                representative_number,
                representative_type,
                policy_type,
                policy_number,
                business_sequence_number,
                record_type,
                manual_number,
                sub_manual_number,
                claim_reserve_code,
                claim_number,
                injury_date,
                claim_indemnity_paid_using_mira_rules,
                claim_indemnity_mira_reserve,
                claim_medical_paid,
                claim_medical_reserve,
                claim_indemnity_handicap_paid_using_mira_rules,
                claim_indemnity_handicap_mira_reserve,
                claim_medical_handicap_paid,
                claim_medical_handicap_reserve,
                claim_surplus_type,
                claim_handicap_percent,
                claim_over_policy_max_value_indicator,
                created_at,
                updated_at
      )
      (select
        cast_to_int(substring(single_rec,1,6)),  /* representative_number, */
                cast_to_int(substring(single_rec,8,2)),  /* representative_type */
                cast_to_int(substring(single_rec,10,1)),  /* policy_type */
                cast_to_int(substring(single_rec,11,7)),  /* policy_sequence_number  */
                cast_to_int(substring(single_rec,19,3)),  /* business_sequence_number  */
                cast_to_int(substring(single_rec,22,2)),  /* record_type  */
                cast_to_int(substring(single_rec,24,4)),  /* claim_manual_number,  */
                substring(single_rec,28,2),  /* claim_reserve_code,  */
                substring(single_rec,30,2),  /* claim_reserve_code,  */
                substring(single_rec,32,10),  /* claim_number,  */
                case when substring(single_rec,68,8) > '00000000' THEN to_date(substring(single_rec,68,8), 'YYYYMMDD')
                  else null
                end,  /* injury_date,  */
                cast_to_int(substring(single_rec,76,7)),  /* claim_indemnity_paid_using_mira_rules,  */
                cast_to_int(substring(single_rec,84,7)),  /* claim_indemnity_mira_reserve,  */
                cast_to_int(substring(single_rec,92,7)),  /* claim_medical_paid, */
                cast_to_int(substring(single_rec,100,7)),  /* claim_medical_reserve, */
                cast_to_int(substring(single_rec,108,7)),  /* claim_indemnity_handicap_paid_using_mira_rules */
                cast_to_int(substring(single_rec,116,7)),  /* claim_indemnity_handicap_mira_reserve,  */
                cast_to_int(substring(single_rec,124,7)),  /* claim_medical_handicap_paid,  */
                cast_to_int(substring(single_rec,132,7)),  /* claim_medical_handicap_reserve,  */
                substring(single_rec,140,1),  /* claim_surplus_type,  */
                substring(single_rec,141,3),  /* claim_handicap_percent,  */
                substring(single_rec,144,1),  /* claim_over_policy_max_value_indicator  */
                current_timestamp::timestamp as created_at,
                current_timestamp::timestamp as updated_at
      from mremps WHERE substring(single_rec,22,2) = '31');
      -- END OF MREMP
      /*************************************************************************/

      end;

        $BODY$
        LANGUAGE plpgsql;


    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_process_flat_mremp;
    })
  end
end
