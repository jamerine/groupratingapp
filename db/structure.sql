--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.2
-- Dumped by pg_dump version 9.5.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: cast_to_int(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION cast_to_int(text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
      begin
          -- Note the double casting to avoid infinite recursion.
          return cast($1::varchar as integer);
      exception
          when invalid_text_representation then
              return 0;
      end;
      $_$;


--
-- Name: cast_to_numeric(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION cast_to_numeric(text) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
      begin
          -- Note the double casting to avoid infinite recursion.
          return cast($1::varchar as double precision);
      exception
          when invalid_text_representation then
              return 0;
      end;
      $_$;


--
-- Name: proc_process_flat_democs(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_democs() RETURNS void
    LANGUAGE plpgsql
    AS $$

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
    claim_total_subrogation_collected
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
    cast_to_int(substring(single_rec,266,7))   /*  claim_total_subrogation_collected  */

  from democs WHERE substring(single_rec,10,2) = '02');




  end;

    $$;


--
-- Name: proc_process_flat_mrcls(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_mrcls() RETURNS void
    LANGUAGE plpgsql
    AS $$

      BEGIN
      /***************************************************************************/
      -- START OF MRCLS

      /* Detail Record Type 02 */
      INSERT INTO mrcl_detail_records (
       representative_number,
       representative_type,
       record_type,
       requestor_number,
       policy_type,
       policy_number,
       business_sequence_number,
       valid_policy_number,
       manual_reclassifications,
       re_classed_from_manual_number,
       re_classed_to_manual_number,
       reclass_manual_coverage_type,
       reclass_creation_date,
       reclassed_payroll_information,
       payroll_reporting_period_from_date,
       payroll_reporting_period_to_date,
       re_classed_to_manual_payroll_total
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
       substring(single_rec,28,1),   /*  manual_reclassifications  */
       cast_to_int(substring(single_rec,29,5)),   /*  re-classed_from_manual_number  */
       cast_to_int(substring(single_rec,34,5)),   /*  re-classed_to_manual_number  */
       CASE WHEN substring(single_rec,39,3) LIKE 'SUP' THEN 'SN'
            WHEN substring(single_rec,39,3) LIKE 'REG' THEN 'RN'
            ELSE substring(single_rec,39,3) END,   /*  reclass_manual_coverage_type  */
       case when substring(single_rec,42,8) > '0' THEN to_date(substring(single_rec,42,8), 'YYYYMMDD')
         else null
       end,  /*  reclass_creation_date  */
       substring(single_rec,50,1),   /*  reclassed_payroll_information  */
       case when substring(single_rec,51,8) > '0' THEN to_date(substring(single_rec,51,8), 'YYYYMMDD')
         else null
       end,  /*  payroll_reporting_period_from_date  */
       case when substring(single_rec,59,8) > '0' THEN to_date(substring(single_rec,59,8), 'YYYYMMDD')
         else null
       end, /*  payroll_reporting_period_to_date  */
       CASE when substring(single_rec,67,13) > '0' THEN cast(substring(single_rec,67,13) as numeric)
       ELSE null
       end  /*re-classed_to_manual_payroll_total  */

      from mrcls WHERE substring(single_rec,10,2) = '02');



       end;

         $$;


--
-- Name: proc_process_flat_mremps(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_mremps() RETURNS void
    LANGUAGE plpgsql
    AS $$

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

        $$;


--
-- Name: proc_process_flat_pcombs(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_pcombs() RETURNS void
    LANGUAGE plpgsql
    AS $$

      BEGIN

      /* Detail Record Type 02 */
      INSERT INTO pcomb_detail_records (
              representative_number,
              representative_type,
              record_type,
              requestor_number,
              policy_type,
              policy_number,
              business_sequence_number,
              valid_policy_number,
              policy_combinations,
              predecessor_policy_type,
              predecessor_policy_number,
              predecessor_filler,
              predecessor_business_sequence_number,
              successor_policy_type,
              successor_policy_number,
              successor_filler,
              successor_business_sequence_number,
              transfer_type,
              transfer_effective_date,
              transfer_creation_date,
              partial_transfer_due_to_labor_lease,
              labor_lease_type,
              partial_transfer_payroll_movement,
              ncci_manual_number,
              manual_coverage_type,
              payroll_reporting_period_from_date,
              payroll_reporting_period_to_date,
              manual_payroll,
              created_at,
              updated_at
      )
      (select cast_to_int(substring(single_rec,1,6)),   /*  representative_number  */
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
              substring(single_rec,28,1),   /*  policy_combinations  */
              CASE WHEN cast_to_int(substring(single_rec,29,1)) = 0 THEN 'private_state_fund'
                   WHEN cast_to_int(substring(single_rec,29,1)) = 1 THEN 'public_state_fund'
                   WHEN cast_to_int(substring(single_rec,29,1)) = 2 THEN 'private_self_insured'
                   WHEN cast_to_int(substring(single_rec,29,1)) = 3 THEN 'public_app_fund'
                   ELSE substring(single_rec,29,1)
                   END,   /*  policy_type  */
              cast_to_int(substring(single_rec,29,1) || substring(single_rec,30,7)),   /*  policy_number  */
              substring(single_rec,37,1),   /*  predecessor_filler  */
              substring(single_rec,38,3),   /*  predecessor_business_sequence_number  */
              CASE WHEN cast_to_int(substring(single_rec,41,1)) = 0 THEN 'private_state_fund'
                   WHEN cast_to_int(substring(single_rec,41,1)) = 1 THEN 'public_state_fund'
                   WHEN cast_to_int(substring(single_rec,41,1)) = 2 THEN 'private_self_insured'
                   WHEN cast_to_int(substring(single_rec,41,1)) = 3 THEN 'public_app_fund'
                   ELSE substring(single_rec,41,1)
                   END,   /*  policy_type  */
              cast_to_int(substring(single_rec,41,1) || substring(single_rec,42,7)),   /*  policy_number  */
              substring(single_rec,49,1),   /*  successor_filler  */
              substring(single_rec,50,3),   /*  successor_business_sequence_number  */
              substring(single_rec,53,2),   /*  transfer_type  */
              case when substring(single_rec,55,8) > '00000000' THEN to_date(substring(single_rec,55,8), 'YYYYMMDD')
                else null
              end,   /*  transfer_effective_date  */
              case when substring(single_rec,63,8) > '00000000' THEN to_date(substring(single_rec,63,8), 'YYYYMMDD')
                else null
              end,   /*  transfer_creation_date  */
              substring(single_rec,71,1),   /*  partial_transfer_due_to_labor_lease  */
              substring(single_rec,72,5),   /*  labor_lease_type  */
              substring(single_rec,77,1),   /*  partial_transfer_payroll_movement  */
              cast_to_int( substring(single_rec,78,5)),   /*  ncci_manual_number  */
              Case when substring(single_rec,83,3) LIKE 'SUP' then 'SN'
                WHEN substring(single_rec,83,3) LIKE 'REG' then 'RN'
                ELSE substring(single_rec,83,3) END,   /*  manual_coverage_type  */
              case when substring(single_rec,86,8) > '00000000' THEN to_date(substring(single_rec,86,8), 'YYYYMMDD')
                else null
              end,   /*  payroll_reporting_period_from_date  */
              case when substring(single_rec,94,8) > '00000000' THEN to_date(substring(single_rec,94,8), 'YYYYMMDD')
                else null
              end,   /*  payroll_reporting_period_to_date  */
              CASE when substring(single_rec,102,13) > '0' THEN cast(substring(single_rec,102,13) as numeric)
              ELSE null
              end,   /*  manual_payroll  */
              current_timestamp::timestamp as created_at,
              current_timestamp::timestamp as updated_at
      from pcombs WHERE substring(single_rec,10,2) = '02');


      end;

        $$;


--
-- Name: proc_process_flat_pcovgs(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_pcovgs() RETURNS void
    LANGUAGE plpgsql
    AS $$

      BEGIN
      /***************************************************************************/
      -- START OF pcovg
      /* Detail Record Type 02 */
      INSERT INTO pcovg_detail_records (
        representative_number,
        record_type,
        requestor_number,
        policy_number,
        business_sequence_number,
        valid_policy_number,
        coverage_status,
        coverage_status_effective_date,
        coverage_status_end_date,
        created_at,
        updated_at
      )
      (
      SELECT
        cast_to_int(substring(single_rec,1,6)) /* representative_number */,
        cast_to_int(substring(single_rec,10,2)) /* record_type */,
        cast_to_int(substring(single_rec,12,3)) /* requestor_number */,
        cast_to_int(substring(single_rec,15,8)) /* policy_number */,
        cast_to_int(substring(single_rec,24,3)) /* business_sequence_number */,
        substring(single_rec,27,1) /* valid_policy_number */,
        substring(single_rec,28,5) /* coverage_status */,
        case when substring(single_rec,33,8) > '00000000' THEN to_date(substring(single_rec,33,8), 'YYYYMMDD')
          else null
        end /* coverage_status_effective_date */,
        case when substring(single_rec,41,8) > '00000000' and substring(single_rec,41,8) < '30000101' THEN to_date(substring(single_rec,41,8), 'YYYYMMDD')
        when substring(single_rec,41,8) = '30000101' THEN
          null
          else null
        end /* coverage_status_end_date */,
        current_timestamp::timestamp as created_at,
        current_timestamp::timestamp as updated_at

       from pcovgs WHERE substring(single_rec,10,2) = '02');

       end;

         $$;


--
-- Name: proc_process_flat_pdemos(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_pdemos() RETURNS void
    LANGUAGE plpgsql
    AS $$

      BEGIN
      /***************************************************************************/
      -- START OF pdemo
      /* Detail Record Type 02 */
      INSERT INTO pdemo_detail_records (
        representative_number,
        record_type,
        requestor_number,
        policy_number,
        business_sequence_number,
        valid_policy_number,
        current_coverage_status,
        coverage_status_effective_date,
        federal_identification_number,
        business_name,
        trading_as_name,
        valid_mailing_address,
        mailing_address_line_1,
        mailing_address_line_2,
        mailing_city,
        mailing_state,
        mailing_zip_code,
        mailing_zip_code_plus_4,
        mailing_country_code,
        mailing_county,
        valid_location_address,
        location_address_line_1,
        location_address_line_2,
        location_city,
        location_state,
        location_zip_code,
        location_zip_code_plus_4,
        location_country_code,
        location_county,
        currently_assigned_clm_representative_number,
        currently_assigned_risk_representative_number,
        currently_assigned_erc_representative_number,
        currently_assigned_grc_representative_number,
        immediate_successor_policy_number,
        immediate_successor_business_sequence_number,
        ultimate_successor_policy_number,
        ultimate_successor_business_sequence_number,
        employer_type,
        coverage_type,
        created_at,
        updated_at
      )
      (
      SELECT
        cast_to_int(substring(single_rec,1,6)) /* representative_number */,
        cast_to_int(substring(single_rec,10,2)) /* record_type */,
        cast_to_int(substring(single_rec,12,3)) /*  requestor_number  */,
        cast_to_int(substring(single_rec,15,8)) /*  policy_number  */,
        cast_to_int(substring(single_rec,24,3)) /*  business_sequence_number  */,
        substring(single_rec,27,1) /*  valid_policy_number  */,
        substring(single_rec,28,5) /*  current_coverage_status  */,
        case when substring(single_rec,33,8) > '00000000' THEN to_date(substring(single_rec,33,8), 'YYYYMMDD')
          else null
        end      /*  coverage_status_effective_date  */,
        cast_to_int(substring(single_rec,41,11)) /*  federal_identification_number  */,
        substring(single_rec,52,40) /*  business_name  */,
        substring(single_rec,92,40) /*  trading_as_name  */,
        substring(single_rec,132,1) /*  valid_mailing_address  */,
        substring(single_rec,133,40) /*  mailing_address_line_1  */,
        substring(single_rec,173,40) /*  mailing_address_line_2  */,
        substring(single_rec,213,30) /*  mailing_city  */,
        substring(single_rec,243,2) /*  mailing_state  */,
        cast_to_int(substring(single_rec,245,5)) /*  mailing_zip_code  */,
        cast_to_int(substring(single_rec,250,4)) /*  mailing_zip_code_plus_4  */,
        cast_to_int(substring(single_rec,254,3)) /*  mailing_country_code  */,
        cast_to_int(substring(single_rec,257,5)) /*  mailing_county  */,
        substring(single_rec,262,1) /*  valid_location_address  */,
        substring(single_rec,263,40) /*  location_address_line_1  */,
        substring(single_rec,303,40) /*  location_address_line_2  */,
        substring(single_rec,343,30) /*  location_city  */,
        substring(single_rec,373,2) /*  location_state  */,
        cast_to_int(substring(single_rec,375,5)) /*  location_zip_code  */,
        cast_to_int(substring(single_rec,380,4)) /*  location_zip_code_plus_4  */,
        cast_to_int(substring(single_rec,384,3)) /*  location_country_code  */,
        cast_to_int(substring(single_rec,387,5)) /*  location_county  */,
        cast_to_int(substring(single_rec,392,6)) /*  currently_assigned_clm_representative_number  */,
        cast_to_int(substring(single_rec,401,6)) /*  currently_assigned_risk_representative_number  */,
        cast_to_int(substring(single_rec,410,6)) /*  currently_assigned_erc_representative_number  */,
        cast_to_int(substring(single_rec,419,6)) /*  currently_assigned_grc_representative_number  */,
        cast_to_int(substring(single_rec,428,8)) /*  immediate_successor_policy_number  */,
        cast_to_int(substring(single_rec,437,3)) /*  immediate_successor_business_sequence_number  */,
        cast_to_int(substring(single_rec,440,8)) /*  ultimate_successor_policy_number  */,
        cast_to_int(substring(single_rec,449,3)) /*  ultimate_successor_business_sequence_number  */,
        substring(single_rec,452,3) /*  employer_type  */,
        substring(single_rec,455,2) /*  coverage_type  */,
        current_timestamp::timestamp as created_at,
        current_timestamp::timestamp as updated_at

       from pdemos WHERE substring(single_rec,10,2) = '02');


       end;

         $$;


--
-- Name: proc_process_flat_pemhs(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_pemhs() RETURNS void
    LANGUAGE plpgsql
    AS $$

      BEGIN
      /***************************************************************************/
      -- START OF pemhs
      /* Detail Record Type 02 */
      INSERT INTO pemh_detail_records (
        representative_number,
        record_type,
        requestor_number,
        policy_number,
        business_sequence_number,
        valid_policy_number,
        current_coverage_status,
        coverage_status_effective_date,
        experience_modifier_rate,
        em_effective_date,
        policy_year,
        reporting_period_start_date,
        reporting_period_end_date,
        group_participation_indicator,
        group_code,
        group_type,
        rrr_participation_indicator,
        rrr_tier,
        rrr_policy_claim_limit,
        rrr_minimum_premium_percentage,
        deductible_participation_indicator,
        deductible_level,
        deductible_stop_loss_indicator,
        deductible_discount_percentage,
        ocp_participation_indicator,
        ocp_participation,
        ocp_first_year_of_participation,
        grow_ohio_participation_indicator,
        em_cap_participation_indicator,
        drug_free_program_participation_indicator,
        drug_free_program_type,
        drug_free_program_participation_level,
        drug_free_program_discount_eligiblity_indicator,
        issp_participation_indicator,
        issp_discount_eligibility_indicator,
        twbns_participation_indicator,
        twbns_discount_eligibility_indicator,
        created_at,
        updated_at
      )
      (
      SELECT
        cast_to_int(substring(single_rec,1,6)) /* representative_number */,
        cast_to_int(substring(single_rec,10,2)) /* record_type */,
        cast_to_int(substring(single_rec,12,3)) /* requestor_number */,
        cast_to_int(substring(single_rec,15,8)) /* policy_number */,
        cast_to_int(substring(single_rec,24,3)) /* business_sequence_number */,
        substring(single_rec,27,1) /* valid_policy_number */,
        substring(single_rec,28,5) /* current_coverage_status */,
        case when substring(single_rec,33,8) > '00000000' THEN to_date(substring(single_rec,33,8), 'YYYYMMDD')
          else null
        end /* coverage_status_effective_date */,
        case when substring(single_rec,41,5) > '0' THEN
          substring(single_rec,41,5)::numeric
          ELSE null
        end  /* experience_modifier_rate */,
        case when substring(single_rec,46,8) > '00000000' THEN to_date(substring(single_rec,46,8), 'YYYYMMDD')
          else null
        end /* em_effective_date */,
        cast_to_int(substring(single_rec,54,4)) /* policy_year */,
        case when substring(single_rec,68,8) > '00000000' THEN
        to_date(substring(single_rec,58,8), 'YYYYMMDD')
          else null
        end /* reporting_period_start_date */,
        case when substring(single_rec,66,8) > '00000000' THEN to_date(substring(single_rec,66,8), 'YYYYMMDD')
          else null
        end /* reporting_period_end_date */,
        substring(single_rec,74,1) /* group_participation_indicator */,
        cast_to_int(substring(single_rec,75,5)) /* group_code */,
        substring(single_rec,80,5) /* group_type */,
        substring(single_rec,85,1) /* rrr_participation_indicator */,
        cast_to_int(substring(single_rec,86,1)) /* rrr_tier */,
        cast_to_int(substring(single_rec,87,6)) /* rrr_policy_claim_limit */,
        cast_to_int(substring(single_rec,93,3)) /* rrr_minimum_premium_percentage */,
        substring(single_rec,96,1) /* deductible_participation_indicator */,
        cast_to_int(substring(single_rec,97,6)) /* deductible_level */,
        substring(single_rec,103,1) /* deductible_stop_loss_indicator */,
        cast_to_int(substring(single_rec,104,3)) /* deductible_discount_percentage */,
        substring(single_rec,107,1) /* ocp_participation_indicator */,
        cast_to_int(substring(single_rec,108,1)) /* ocp_participation */,
        cast_to_int(substring(single_rec,109,4)) /* ocp_first_year_of_participation */,
        substring(single_rec,113,1) /* grow_ohio_participation_indicator */,
        substring(single_rec,114,1) /* em_cap_participation_indicator */,
        substring(single_rec,115,1) /* drug_free_program_participation_indicator */,
        substring(single_rec,116,4) /* drug_free_program_type */,
        substring(single_rec,120,1) /* drug_free_program_participation_level */,
        substring(single_rec,121,1) /* drug_free_program_discount_eligiblity_indicator */,
        substring(single_rec,122,1) /* issp_participation_indicator */,
        substring(single_rec,123,1) /* issp_discount_eligibility_indicator */,
        substring(single_rec,124,1) /* twbns_participation_indicator */,
        substring(single_rec,125,1) /* twbns_discount_eligibility_indicator */,
        current_timestamp::timestamp as created_at,
        current_timestamp::timestamp as updated_at

       from pemhs WHERE substring(single_rec,10,2) = '02');


       end;

         $$;


--
-- Name: proc_process_flat_phmgns(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_phmgns() RETURNS void
    LANGUAGE plpgsql
    AS $$

      BEGIN

      /****************************************************************************/
      -- START OF PHMGNFILE


      /* Detail Record Type 02 */
      INSERT INTO phmgn_detail_records (
                representative_number,
                representative_type,
                record_type,
                requestor_number,
                policy_type,
                policy_number,
                business_sequence_number,
                valid_policy_number,
                experience_payroll_premium_information,
                industry_code,
                ncci_manual_number,
                manual_coverage_type,
                manual_payroll,
                manual_premium,
                premium_percentage,
                upcoming_policy_year,
                policy_year_extracted_for_experience_payroll_determining_premiu,
                policy_year_extracted_beginning_date,
                policy_year_extracted_ending_date,
                created_at,
                updated_at
      )
      (select cast_to_int(substring(single_rec,1,6)),   /*  representative_number  */
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
              substring(single_rec,28,1),   /*  experience_payroll_premium_information  */
              substring(single_rec,29,2),   /*  industry_code  */
              cast_to_int(substring(single_rec,31,5)),   /*  ncci_manual_number  */
              substring(single_rec,36,3),   /*  manual_coverage_type  */
              case when substring(single_rec,39,13) > '0' THEN substring(single_rec,39,14)::numeric/100
                  else null
              end,          /*  manual_payroll  */
              case when substring(single_rec,53,13) > '0' THEN substring(single_rec,53,13)::numeric/100
                  else null
              end,  /*  manual_premium  */
              case when substring(single_rec,67,6) > '0' THEN substring(single_rec,67,6)::numeric/100
                  else null
              end,  /*  premium_percentage  */
              cast_to_int(substring(single_rec,74,4)),   /*  upcoming_policy_year  */
              cast_to_int(substring(single_rec,78,4)),   /*  policy_year_extracted_for_experience_payroll_determining_premium  */
              case when substring(single_rec,82,8) > '00000000' THEN to_date(substring(single_rec,82,8), 'YYYYMMDD')
                else null
              end,   /*  policy_year_extracted_beginning_date  */
              case when substring(single_rec,90,8) > '00000000' THEN to_date(substring(single_rec,90,8), 'YYYYMMDD')
                else null
              end,   /*  policy_year_extracted_ending_date  */
              current_timestamp::timestamp as created_at,
              current_timestamp::timestamp as updated_at
      from phmgns WHERE substring(single_rec,10,2) = '02');




      end;

        $$;


--
-- Name: proc_process_flat_rates(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_rates() RETURNS void
    LANGUAGE plpgsql
    AS $$

      BEGIN
      /***************************************************************************/
      -- START OF rates
      /* Detail Record Type 02 */
      INSERT INTO rate_detail_records (
        create_date,
        representative_number,
        representative_name,
        policy_number,
        business_sequence_number,
        policy_name,
        tax_id,
        policy_status_effective_date,
        policy_status,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class,
        manual_class_type,
        manual_class_description,
        bwc_customer_id,
        individual_first_name,
        individual_middle_name,
        individual_last_name,
        individual_tax_id,
        manual_class_rate,
        reporting_type,
        number_of_employees,
        payroll,
        created_at,
        updated_at
      )
      (
      SELECT
        split_part(single_rec, '|',1)::date,
        cast_to_int(substring(split_part(single_rec, '|',2),1,6)),
        split_part(single_rec, '|',3),
        cast_to_int(split_part(single_rec, '|',4)),
        cast_to_int(split_part(single_rec, '|',5)),
        split_part(single_rec, '|',6),
        cast_to_int(split_part(single_rec, '|',7)),
        split_part(single_rec, '|',8)::date,
        split_part(single_rec, '|',9),
        case when split_part(single_rec, '|',10) = ' ' THEN null
          else split_part(single_rec, '|',10)::date
        end,
        case when split_part(single_rec, '|',11) = ' ' THEN null
          else split_part(single_rec, '|',11)::date
        end,
        cast_to_int(split_part(single_rec, '|',12)),
        split_part(single_rec, '|',13),
        split_part(single_rec, '|',14),
        cast_to_int(split_part(single_rec, '|',15)),
        split_part(single_rec, '|',16),
        split_part(single_rec, '|',17),
        split_part(single_rec, '|',18),
        cast_to_int(split_part(single_rec, '|',19)),
        cast_to_numeric(split_part(single_rec, '|',20)),
        split_part(single_rec, '|',21),
        cast_to_int(split_part(single_rec, '|',22)),
        cast_to_numeric(split_part(single_rec, '|',23)),
        current_timestamp::timestamp as created_at,
        current_timestamp::timestamp as updated_at
       FROM public.rates


      );


       end;

         $$;


--
-- Name: proc_process_flat_sc220s(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_sc220s() RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN

/*****************************************************************************/
-- START OF SC220


-- Create Rec Type 1 table


Insert Into sc220_rec1_employer_demographics (
          representative_number,
          representative_type,
          description_ar,
          record_type,
          request_type,
          policy_type,
          policy_number,
          business_sequence_number,
          federal_identification_number,
          business_name,
          trading_as_name,
          in_care_name_contact_name,
          address_1,
          address_2,
          city,
          state,
          zip_code,
          zip_code_plus_4,
          country_code,
          county,
          currently_assigned_representative_number,
          currently_assigned_representative_type,
          successor_policy_number,
          successor_business_sequence_number,
          merit_rate,
          group_code,
          minimum_premium_percentage,
          rate_adjust_factor,
          em_effective_date,
          n2nd_merit_rate,
          n2nd_group_code,
          n2nd_minimum_premium_percentage,
          n2nd_rate_adjust_factor,
          n2nd_em_effective_date,
          n3rd_merit_rate,
          n3rd_group_code,
          n3rd_minimum_premium_percentage,
          n3rd_rate_adjust_factor,
          n3rd_em_effective_date,
          n4th_merit_rate,
          n4th_group_code,
          n4th_minimum_premium_percentage,
          n4th_rate_adjust_factor,
          n4th_em_effective_date,
          n5th_merit_rate,
          n5th_group_code,
          n5th_minimum_premium_percentage,
          n5th_rate_adjust_factor,
          n5th_em_effective_date,
          n6th_merit_rate,
          n6th_group_code,
          n6th_minimum_premium_percentage,
          n6th_rate_adjust_factor,
          n6th_em_effective_date,
          n7th_merit_rate,
          n7th_group_code,
          n7th_minimum_premium_percentage,
          n7th_rate_adjust_factor,
          n7th_em_effective_date,
          n8th_merit_rate,
          n8th_group_code,
          n8th_minimum_premium_percentage,
          n8th_rate_adjust_factor,
          n8th_em_effective_date,
          n9th_merit_rate,
          n9th_group_code,
          n9th_minimum_premium_percentage,
          n9th_rate_adjust_factor,
          n9th_em_effective_date,
          n10th_merit_rate,
          n10th_group_code,
          n10th_minimum_premium_percentage,
          n10th_rate_adjust_factor,
          n10th_em_effective_date,
          n11th_merit_rate,
          n11th_group_code,
          n11th_minimum_premium_percentage,
          n11th_rate_adjust_factor,
          n11th_em_effective_date,
          n12th_merit_rate,
          n12th_group_code,
          n12th_minimum_premium_percentage,
          n12th_rate_adjust_factor,
          n12th_em_effective_date,
          coverage_status,
          coverage_effective_date,
          coverage_end_date,
          n2nd_coverage_status,
          n2nd_coverage_effective_date,
          n2nd_coverage_end_date,
          n3rd_coverage_status,
          n3rd_coverage_effective_date,
          n3rd_coverage_end_date,
          n4th_coverage_status,
          n4th_coverage_effective_date,
          n4th_coverage_end_date,
          n5th_coverage_status,
          n5th_coverage_effective_date,
          n5th_coverage_end_date,
          n6th_coverage_status,
          n6th_coverage_effective_date,
          n6th_coverage_end_date,
          regular_balance_amount,
          attorney_general_balance_amount,
          appealed_balance_amount,
          pending_balance_amount,
          advance_deposit_amount,
          created_at,
          updated_at
)
(select
    cast_to_int(substring(single_rec,1,6)),        -- representative_number char(6),
          cast_to_int(substring(single_rec,7,2)),      -- representative_type char(2),
          substring(single_rec,9,2),      -- description_ar char(2),
          cast_to_int(substring(single_rec,11,1)),     -- record_type char(1),
          cast_to_int(substring(single_rec,12,3)),     -- request_type char(3),
          CASE WHEN cast_to_int(substring(single_rec,15,1)) = 0 THEN 'private_state_fund'
               WHEN cast_to_int(substring(single_rec,15,1)) = 1 THEN 'public_state_fund'
               WHEN cast_to_int(substring(single_rec,15,1)) = 2 THEN 'private_self_insured'
               WHEN cast_to_int(substring(single_rec,15,1)) = 3 THEN 'public_app_fund'
               ELSE substring(single_rec,15,1)
               END,   /*  policy_type  */
          cast_to_int(substring(single_rec,15,1) || substring(single_rec,16,7)),   /*  policy_number  */
          cast_to_int(substring(single_rec,23,3)),     -- business_sequence_number char(3),
          substring(single_rec,26,11),    -- federal_identification_number numeric,
          substring(single_rec,37,40),    -- business_name char(40),
          substring(single_rec,77,40),    -- trading_as_name char(40),
          substring(single_rec,117,40),   -- in_care_name_contact_name char(40),
          substring(single_rec,157,40),   -- address_1 char(40),
          substring(single_rec,197,40),   -- address_2 char(40),
          substring(single_rec,237,30),   -- city char(30),
          substring(single_rec,267,2),    -- state char(2),
          substring(single_rec,269,5),    -- zip_code char(5),
          substring(single_rec,274,4),    -- zip_code_plus_4 char(4),
          substring(single_rec,278,3),    -- country_code char(3),
          substring(single_rec,281,5),    -- county char(5),
          cast_to_int(substring(single_rec,286,6)) ,    -- currently_assigned_representative_number char(6),
          substring(single_rec,292,2),    -- currently_assigned_representative_type char(2),
          cast_to_int(substring(single_rec,294,8)),    -- successor_policy_number numeric(8,2),
          cast_to_int(substring(single_rec,302,3)),    -- successor_business_sequence_number char(3),
          substring(single_rec,305,6)::numeric/1000,    -- merit_rate char(6),
          substring(single_rec,311,5),    -- group_code char(5),
          substring(single_rec,316,4),    -- minimum_premium_percentage char(4),
          substring(single_rec,320,4),    -- rate_adjust_factor char(4),
          case when substring(single_rec,324,8) > '00000000' THEN to_date(substring(single_rec,324,8), 'MMDDYYYY')
            else null
          end,   -- em_effective_date date,
          substring(single_rec,332,6)::numeric/1000,    -- n2nd_merit_rate char(6),
          substring(single_rec,338,5),    -- n2nd_group_code char(5),
          substring(single_rec,343,4),    -- n2nd_minimum_premium_percentage char(4),
          substring(single_rec,347,4),    -- n2nd_rate_adjust_factor char(4),
          case when substring(single_rec,351,8) > '00000000' THEN to_date(substring(single_rec,351,8), 'MMDDYYYY')
            else null
          end,    -- n2nd_em_effective_date date,
          substring(single_rec,359,6)::numeric/1000,    -- n3rd_merit_rate char(6),
          substring(single_rec,365,5),    -- n3rd_group_code char(5),
          substring(single_rec,370,4),    -- n3rd_minimum_premium_percentage char(4),
          substring(single_rec,374,4),    -- n3rd_rate_adjust_factor char(4),
          case when substring(single_rec,378,8) > '00000000' THEN to_date(substring(single_rec,378,8), 'MMDDYYYY')
            else null
          end,    -- n3rd_em_effective_date date,
          substring(single_rec,386,6)::numeric/1000,    -- n4th_merit_rate char(6),
          substring(single_rec,392,5),    -- n4th_group_code char(5),
          substring(single_rec,397,4),    -- n4th_minimum_premium_percentage char(4),
          substring(single_rec,401,4),    -- n4th_rate_adjust_factor char(4),
          case when substring(single_rec,405,8) > '00000000' THEN to_date(substring(single_rec,405,8), 'MMDDYYYY')
            else null
          end,      -- n4th_em_effective_date date,
          substring(single_rec,413,6)::numeric/1000,    -- n5th_merit_rate char(6),
          substring(single_rec,419,5),    -- n5th_group_code char(5),
          substring(single_rec,424,4),    -- n5th_minimum_premium_percentage char(4),
          substring(single_rec,428,4),    -- n5th_rate_adjust_factor char(4),
          case when substring(single_rec,432,8) > '00000000' THEN to_date(substring(single_rec,432,8), 'MMDDYYYY')
            else null
          end,      -- n5th_em_effective_date date,
          substring(single_rec,440,6)::numeric/1000,    -- n6th_merit_rate char(6),
          substring(single_rec,446,5),    -- n6th_group_code char(5),
          substring(single_rec,451,4),    -- n6th_minimum_premium_percentage char(4),
          substring(single_rec,455,4),    -- n6th_rate_adjust_factor char(4),
          case when substring(single_rec,459,8) > '00000000' THEN to_date(substring(single_rec,459,8), 'MMDDYYYY')
            else null
          end,      -- n6th_em_effective_date date,
          substring(single_rec,467,6)::numeric/1000,    -- n7th_merit_rate char(6),
          substring(single_rec,473,5),    -- n7th_group_code char(5),
          substring(single_rec,478,4),    -- n7th_minimum_premium_percentage char(4),
          substring(single_rec,482,4),    -- n7th_rate_adjust_factor char(4),
          case when substring(single_rec,486,8) > '00000000' THEN to_date(substring(single_rec,486,8), 'MMDDYYYY')
            else null
          end,      -- n7th_em_effective_date date,
          substring(single_rec,494,6)::numeric/1000,    -- n8th_merit_rate char(6),
          substring(single_rec,500,5),    -- n8th_group_code char(5),
          substring(single_rec,505,4),    -- n8th_minimum_premium_percentage char(4),
          substring(single_rec,509,4),    -- n8th_rate_adjust_factor char(4),
          case when substring(single_rec,513,8) > '00000000' THEN to_date(substring(single_rec,513,8), 'MMDDYYYY')
            else null
          end,      -- n8th_em_effective_date date,
          substring(single_rec,521,6)::numeric/1000,    -- n9th_merit_rate char(6),
          substring(single_rec,527,5),    -- n9th_group_code char(5),
          substring(single_rec,532,4),    -- n9th_minimum_premium_percentage char(4),
          substring(single_rec,536,4),    -- n9th_rate_adjust_factor char(4),
          case when substring(single_rec,540,8) > '00000000' THEN to_date(substring(single_rec,540,8), 'MMDDYYYY')
            else null
          end,      -- n9th_em_effective_date date,
          substring(single_rec,548,6)::numeric/1000,    -- n10th_merit_rate char(6),
          substring(single_rec,554,5),    -- n10th_group_code char(5),
          substring(single_rec,559,4),    -- n10th_minimum_premium_percentage char(4),
          substring(single_rec,563,4),    -- n10th_rate_adjust_factor char(4),
          case when substring(single_rec,567,8) > '00000000' THEN to_date(substring(single_rec,567,8), 'MMDDYYYY')
            else null
          end,      -- n10th_em_effective_date date,
          substring(single_rec,575,6)::numeric/1000,    -- n11th_merit_rate char(6),
          substring(single_rec,581,5),    -- n11th_group_code char(5),
          substring(single_rec,586,4),    -- n11th_minimum_premium_percentage char(4),
          substring(single_rec,590,4),    -- n11th_rate_adjust_factor char(4),
          case when substring(single_rec,594,8) > '00000000' THEN to_date(substring(single_rec,594,8), 'MMDDYYYY')
            else null
          end,      -- n11th_em_effective_date date,
          substring(single_rec,602,6)::numeric/1000,    -- n12th_merit_rate char(6),
          substring(single_rec,608,5),    -- n12th_group_code char(5),
          substring(single_rec,613,4),    -- n12th_minimum_premium_percentage char(4),
          substring(single_rec,617,4),    -- n12th_rate_adjust_factor char(4),
          case when substring(single_rec,621,8) > '00000000' THEN to_date(substring(single_rec,621,8), 'MMDDYYYY')
            else null
          end,      -- n12th_em_effective_date date,
          substring(single_rec,629,5),    -- coverage_status char(5),
          case when substring(single_rec,634,8) > '00000000' THEN to_date(substring(single_rec,634,8), 'MMDDYYYY')          else null
          end,     -- coverage_effective_date date,
          case when substring(single_rec,642,8) > '00000000' THEN to_date(substring(single_rec,642,8), 'MMDDYYYY')
            else null
          end,            -- coverage_end_date date,
          substring(single_rec,650,5),    -- n2nd_coverage_status char(5),
          case when substring(single_rec,655,8) > '00000000' THEN to_date(substring(single_rec,655,8), 'MMDDYYYY')
            else null
          end,             -- n2nd_coverage_effective_date date,
          case when substring(single_rec,663,8) > '00000000' THEN to_date(substring(single_rec,663,8), 'MMDDYYYY')
            else null
          end,    -- n2nd_coverage_end_date date,
          substring(single_rec,671,5),    -- n3rd_coverage_status char(5),
          case when substring(single_rec,676,8) > '00000000' THEN to_date(substring(single_rec,676,8), 'MMDDYYYY')
            else null
          end,    -- n3rd_coverage_effective_date date,
          case when substring(single_rec,684,8) > '00000000' THEN to_date(substring(single_rec,684,8), 'MMDDYYYY')
            else null
          end,    -- n3rd_coverage_end_datedate,
          substring(single_rec,692,5),    -- n4th_coverage_status char(5),
          case when substring(single_rec,697,8) > '00000000' THEN to_date(substring(single_rec,697,8), 'MMDDYYYY')
            else null
          end,    -- n4th_coverage_effective_date date,
          case when substring(single_rec,705,8) > '00000000' THEN to_date(substring(single_rec,705,8), 'MMDDYYYY')
            else null
          end,    -- n4th_coverage_end_date date,
          substring(single_rec,713,5),    -- n5th_coverage_status char(5),
          case when substring(single_rec,718,8) > '00000000' THEN to_date(substring(single_rec,718,8), 'MMDDYYYY')
            else null
          end,    -- n5th_coverage_effective_date date,
          case when substring(single_rec,726,8) > '00000000' THEN to_date(substring(single_rec,726,8), 'MMDDYYYY')
            else null
          end,    -- n5th_coverage_end_date date,
          substring(single_rec,734,5),    -- n6th_coverage_status char(5),
          case when substring(single_rec,739,8) > '00000000' THEN to_date(substring(single_rec,739,8), 'MMDDYYYY')
            else null
          end,    -- n6th_coverage_effective_date date,
          case when substring(single_rec,747,8) > '00000000' THEN to_date(substring(single_rec,747,8), 'MMDDYYYY')
            else null
          end,    -- n6th_coverage_end_date date,
          cast_to_int(substring(single_rec,755,12)),   -- regular_balance_amount char(13),
          cast_to_int(substring(single_rec,768,12)),   -- attorney_general_balance_amount char(13),
          cast_to_int(substring(single_rec,781,12)),   -- appealed_balance_amount char(13),
          cast_to_int(substring(single_rec,794,12)),   -- pending_balance_amount char(13),
          cast_to_int(substring(single_rec,807,10)),   -- advance_deposit_amount numeric
          current_timestamp::timestamp as created_at,
          current_timestamp::timestamp as updated_at
from sc220s where substring(single_rec,11,1) = '1');



Insert Into sc220_rec2_employer_manual_level_payrolls
         (representative_number,
          representative_type,
          description_ar,
          record_type,
          request_type,
          policy_type,
          policy_number,
          business_sequence_number,
          manual_number,
          manual_type,
          year_to_date_payroll,
          manual_class_rate,
          year_to_date_premium_billed,
          manual_effective_date,
          n2nd_year_to_date_payroll,
          n2nd_manual_class_rate,
          n2nd_year_to_date_premium_billed,
          n2nd_manual_effective_date,
          n3rd_year_to_date_payroll,
          n3rd_manual_class_rate,
          n3rd_year_to_date_premium_billed,
          n3rd_manual_effective_date,
          n4th_year_to_date_payroll,
          n4th_manual_class_rate,
          n4th_year_to_date_premium_billed,
          n4th_manual_effective_date,
          n5th_year_to_date_payroll,
          n5th_manual_class_rate,
          n5th_year_to_date_premium_billed,
          n5th_manual_effective_date,
          n6th_year_to_date_payroll,
          n6th_manual_class_rate,
          n6th_year_to_date_premium_billed,
          n6th_manual_effective_date,
          n7th_year_to_date_payroll,
          n7th_manual_class_rate,
          n7th_year_to_date_premium_billed,
          n7th_manual_effective_date,
          n8th_year_to_date_payroll,
          n8th_manual_class_rate,
          n8th_year_to_date_premium_billed,
          n8th_manual_effective_date,
          n9th_year_to_date_payroll,
          n9th_manual_class_rate,
          n9th_year_to_date_premium_billed,
          n9th_manual_effective_date,
          n10th_year_to_date_payroll,
          n10th_manual_class_rate,
          n10th_year_to_date_premium_billed,
          n10th_manual_effective_date,
          n11th_year_to_date_payroll,
          n11th_manual_class_rate,
          n11th_year_to_date_premium_billed,
          n11th_manual_effective_date,
          n12th_year_to_date_payroll,
          n12th_manual_class_rate,
          n12th_year_to_date_premium_billed,
          n12th_manual_effective_date,
          created_at,
          updated_at
 )
 (select  cast_to_int(substring(single_rec,1,6)),       -- representative_number
          cast_to_int(substring(single_rec,7,2)),       -- representative_type
          substring(single_rec,9,2),       -- description_ar
          cast_to_int(substring(single_rec,11,1)),      -- record_type
          cast_to_int(substring(single_rec,12,3)),      -- request_type
          CASE WHEN cast_to_int(substring(single_rec,15,1)) = 0 THEN 'private_state_fund'
               WHEN cast_to_int(substring(single_rec,15,1)) = 1 THEN 'public_state_fund'
               WHEN cast_to_int(substring(single_rec,15,1)) = 2 THEN 'private_self_insured'
               WHEN cast_to_int(substring(single_rec,15,1)) = 3 THEN 'public_app_fund'
               ELSE substring(single_rec,15,1)
               END,   /*  policy_type  */
          cast_to_int(substring(single_rec,15,1) || substring(single_rec,16,7)),   /*  policy_number  */
          cast_to_int(substring(single_rec,23,3)),      -- business_sequence_number
          cast_to_int(substring(single_rec,26,6)),      -- manual_number
          substring(single_rec,32,2),      -- manual_type
          substring(single_rec,34,11)::numeric/100,     -- year_to_date_payroll
          substring(single_rec,46,8)::numeric/10000,      -- manual_class_rate
          substring(single_rec,55,11)::numeric/100,     -- year_to_date_premium_billed
          case when substring(single_rec,67,8) > '00000000' THEN to_date(substring(single_rec,67,8), 'MMDDYYYY')
            else null
          end,      -- manual_effective_date
          substring(single_rec,75,11)::numeric/100,     -- n2nd_year_to_date_payroll
          substring(single_rec,87,8)::numeric/10000,      -- n2nd_manual_class_rate
          substring(single_rec,96,11)::numeric/100,     -- n2nd_year_to_date_premium_billed
          case when substring(single_rec,108,8) > '00000000' THEN to_date(substring(single_rec,108,8), 'MMDDYYYY')
            else null
          end,     -- n2nd_manual_effective_date
          substring(single_rec,116,11)::numeric/100,    -- n3rd_year_to_date_payroll
          substring(single_rec,128,8)::numeric/10000,     -- n3rd_manual_class_rate
          substring(single_rec,137,11)::numeric/100,    -- n3rd_year_to_date_premium_billed
          case when substring(single_rec,149,8) > '00000000' THEN to_date(substring(single_rec,149,8), 'MMDDYYYY')
            else null
          end,     -- n3rd_manual_effective_date
          substring(single_rec,157,11)::numeric/100,    -- n4th_year_to_date_payroll
          substring(single_rec,169,8)::numeric/10000,     -- n4th_manual_class_rate
          substring(single_rec,178,11)::numeric/100,    -- n4th_year_to_date_premium_billed
          case when substring(single_rec,190,8) > '00000000' THEN to_date(substring(single_rec,190,8), 'MMDDYYYY')
            else null
          end,     -- n4th_manual_effective_date
          substring(single_rec,198,11)::numeric/100,    -- n5th_year_to_date_payroll
          substring(single_rec,210,8)::numeric/10000,     -- n5th_manual_class_rate
          substring(single_rec,219,11)::numeric/100,    -- n5th_year_to_date_premium_billed
          case when substring(single_rec,231,8) > '00000000' THEN to_date(substring(single_rec,231,8), 'MMDDYYYY')
            else null
          end,     -- n5th_manual_effective_date
          substring(single_rec,239,11)::numeric/100,    -- n6th_year_to_date_payroll
          substring(single_rec,251,8)::numeric/10000,     -- n6th_manual_class_rate
          substring(single_rec,260,11)::numeric/100,    -- n6th_year_to_date_premium_billed
          case when substring(single_rec,272,8) > '00000000' THEN to_date(substring(single_rec,272,8), 'MMDDYYYY')
            else null
          end,     -- n6th_manual_effective_date
          substring(single_rec,280,11)::numeric/100,    -- n7th_year_to_date_payroll
          substring(single_rec,292,8)::numeric/10000,     -- n7th_manual_class_rate
          substring(single_rec,301,11)::numeric/100,    -- n7th_year_to_date_premium_billed
          case when substring(single_rec,313,8) > '00000000' THEN to_date(substring(single_rec,313,8), 'MMDDYYYY')
            else null
          end,     -- n7th_manual_effective_date
          substring(single_rec,321,11)::numeric/100,    -- n8th_year_to_date_payroll
          substring(single_rec,333,8)::numeric/10000,     -- n8th_manual_class_rate
          substring(single_rec,342,11)::numeric/100,    -- n8th_year_to_date_premium_billed
          case when substring(single_rec,354,8) > '00000000' THEN to_date(substring(single_rec,354,8), 'MMDDYYYY')
            else null
          end,     -- n8th_manual_effective_date
          substring(single_rec,362,11)::numeric/100,    -- n9th_year_to_date_payroll
          substring(single_rec,374,8)::numeric/10000,     -- n9th_manual_class_rate
          substring(single_rec,383,11)::numeric/100,    -- n9th_year_to_date_premium_billed
          case when substring(single_rec,395,8) > '00000000' THEN to_date(substring(single_rec,395,8), 'MMDDYYYY')
            else null
          end,     -- n9th_manual_effective_date
          substring(single_rec,403,11)::numeric/100,    -- n10th_year_to_date_payroll
          substring(single_rec,415,8)::numeric/10000,     -- n10th_manual_class_rate
          substring(single_rec,424,11)::numeric/100,    -- n10th_year_to_date_premium_billed
          case when substring(single_rec,436,8) > '00000000' THEN to_date(substring(single_rec,436,8), 'MMDDYYYY')
            else null
          end,     -- n10th_manual_effective_date
          substring(single_rec,444,11)::numeric/100,    -- n11th_year_to_date_payroll
          substring(single_rec,456,8)::numeric/10000,     -- n11th_manual_class_rate
          substring(single_rec,465,11)::numeric/100,    -- n11th_year_to_date_premium_billed
          case when substring(single_rec,477,8) > '00000000' THEN to_date(substring(single_rec,477,8), 'MMDDYYYY')
            else null
          end,     -- n11th_manual_effective_date
          substring(single_rec,485,11)::numeric/100,    -- n12th_year_to_date_payroll
          substring(single_rec,497,8)::numeric/10000,     -- n12th_manual_class_rate
          substring(single_rec,506,11)::numeric/100,    -- n12th_year_to_date_premium_billed
          case when substring(single_rec,518,8) > '00000000' THEN to_date(substring(single_rec,518,8), 'MMDDYYYY')
            else null
          end,     -- n12th_manual_effective_date
          current_timestamp::timestamp as created_at,
          current_timestamp::timestamp as updated_at

from sc220s where substring(single_rec,11,1) = '2');

-- Insert Rec Type 3 into the database

INSERT INTO sc220_rec3_employer_ar_transactions
   (representative_number,
    representative_type,
    descriptionar,
    record_type,
    request_type,
    policy_type,
    policy_number,
    business_sequence_number,
    trans_date,
    invoice_number,
    billing_trans_status_code,
    trans_amount,
    trans_type,
    paid_amount,
    n2nd_trans_date,
    n2nd_invoice_number,
    n2nd_billing_trans_status_code,
    n2nd_trans_amount,
    n2nd_trans_type,
    n2nd_paid_amount,
    n3rd_trans_date,
    n3rd_invoice_number,
    n3rd_billing_trans_status_code,
    n3rd_trans_amount,
    n3rd_trans_type,
    n3rd_paid_amount,
    n4th_trans_date,
    n4th_invoice_number,
    n4th_billing_trans_status_code,
    n4th_trans_amount,
    n4th_trans_type,
    n4th_paid_amount,
    n5th_trans_date,
    n5th_invoice_number,
    n5th_billing_trans_status_code,
    n5th_trans_amount,
    n5th_trans_type,
    n5th_paid_amount,
    n6th_trans_date,
    n6th_invoice_number,
    n6th_billing_trans_status_code,
    n6th_trans_amount,
    n6th_trans_type,
    n6th_paid_amount,
    n7th_trans_date,
    n7th_invoice_number,
    n7th_billing_trans_status_code,
    n7th_trans_amount,
    n7th_trans_type,
    n7th_paid_amount,
    n8th_trans_date,
    n8th_invoice_number,
    n8th_billing_trans_status_code,
    n8th_trans_amount,
    n8th_trans_type,
    n8th_paid_amount,
    n9th_trans_date,
    n9th_invoice_number,
    n9th_billing_trans_status_code,
    n9th_trans_amount,
    n9th_trans_type,
    n9th_paid_amount,
    n10th_trans_date,
    n10th_invoice_number,
    n10th_billing_trans_status_code,
    n10th_trans_amount,
    n10th_trans_type,
    n10th_paid_amount,
    n11th_trans_date,
    n11th_invoice_number,
    n11th_billing_trans_status_code,
    n11th_trans_amount,
    n11th_trans_type,
    n11th_paid_amount,
    n12th_trans_date,
    n12th_invoice_number,
    n12th_billing_trans_status_code,
    n12th_trans_amount,
    n12th_trans_type,
    n12th_paid_amount,
    n13th_trans_date,
    n13th_invoice_number,
    n13th_billing_trans_status_code,
    n13th_trans_amount,
    n13th_trans_type,
    n13th_paid_amount,
    n14th_trans_date,
    n14th_invoice_number,
    n14th_billing_trans_status_code,
    n14th_trans_amount,
    n14th_trans_type,
    n14th_paid_amount,
    n15th_trans_date,
    n15th_invoice_number,
    n15th_billing_trans_status_code,
    n15th_trans_amount,
    n15th_trans_type,
    n15th_paid_amount,
    created_at,
    updated_at
)
(select
    cast_to_int(substring(single_rec,1,6)),       -- representative_number
    cast_to_int(substring(single_rec,7,2)),       -- representative_type
    substring(single_rec,9,2),       -- descriptionar
    cast_to_int(substring(single_rec,11,1)),      -- record_type
    cast_to_int(substring(single_rec,12,3)),      -- request_type
    CASE WHEN cast_to_int(substring(single_rec,15,1)) = 0 THEN 'private_state_fund'
         WHEN cast_to_int(substring(single_rec,15,1)) = 1 THEN 'public_state_fund'
         WHEN cast_to_int(substring(single_rec,15,1)) = 2 THEN 'private_self_insured'
         WHEN cast_to_int(substring(single_rec,15,1)) = 3 THEN 'public_app_fund'
         ELSE substring(single_rec,15,1)
         END,   /*  policy_type  */
    cast_to_int(substring(single_rec,15,1) || substring(single_rec,16,7)),   /*  policy_number  */
    cast_to_int(substring(single_rec,23,3)),      -- business_sequence_number
    case when substring(single_rec,26,8) > '00000000' THEN to_date(substring(single_rec,26,8), 'MMDDYYYY')
      else null
    end,                              -- trans_date
    substring(single_rec,34,12),     -- invoice_number
    substring(single_rec,46,5),      -- billing_trans_status_code
    substring(single_rec,51,10)::numeric/1000,     -- trans_amount
    substring(single_rec,62,5),      -- trans_type
    substring(single_rec,67,10)::numeric/1000,     -- paid_amount
    case when substring(single_rec,78,8) > '00000000' THEN to_date(substring(single_rec,78,8), 'MMDDYYYY')
      else null
    end,                              -- n2nd_trans_date
    substring(single_rec,86,12),     -- n2nd_invoice_number
    substring(single_rec,98,5),      -- n2nd_billing_trans_status_code
    substring(single_rec,103,10)::numeric/1000,    -- n2nd_trans_amount
    substring(single_rec,114,5),     -- n2nd_trans_type
    substring(single_rec,119,10)::numeric/1000,    -- n2nd_paid_amount
    case when substring(single_rec,130,8) > '00000000' THEN to_date(substring(single_rec,130,8), 'MMDDYYYY')
      else null
    end,                             -- n3rd_trans_date
    substring(single_rec,138,12),    -- n3rd_invoice_number
    substring(single_rec,150,5),     -- n3rd_billing_trans_status_code
    substring(single_rec,155,10)::numeric/1000,    -- n3rd_trans_amount
    substring(single_rec,166,5),     -- n3rd_trans_type
    substring(single_rec,171,10)::numeric/1000,    -- n3rd_paid_amount
    case when substring(single_rec,182,8) > '00000000' THEN to_date(substring(single_rec,182,8), 'MMDDYYYY')
      else null
    end,                             -- n4th_trans_date
    substring(single_rec,190,12),    -- n4th_invoice_number
    substring(single_rec,202,5),     -- n4th_billing_trans_status_code
    substring(single_rec,207,10)::numeric/1000,    -- n4th_trans_amount
    substring(single_rec,218,5),     -- n4th_trans_type
    substring(single_rec,223,10)::numeric/1000,    -- n4th_paid_amount
    case when substring(single_rec,234,8) > '00000000' THEN to_date(substring(single_rec,234,8), 'MMDDYYYY')
      else null
    end,                             -- n5th_trans_date
    substring(single_rec,242,12),    -- n5th_invoice_number
    substring(single_rec,254,5),     -- n5th_billing_trans_status_code
    substring(single_rec,259,10)::numeric/1000,    -- n5th_trans_amount
    substring(single_rec,270,5),     -- n5th_trans_type
    substring(single_rec,275,10)::numeric/1000,    -- n5th_paid_amount
    case when substring(single_rec,286,8) > '00000000' THEN to_date(substring(single_rec,286,8), 'MMDDYYYY')
      else null
    end,                             -- n6th_trans_date
    substring(single_rec,294,12),    -- n6th_invoice_number
    substring(single_rec,306,5),     -- n6th_billing_trans_status_code
    substring(single_rec,311,10)::numeric/1000,    -- n6th_trans_amount
    substring(single_rec,322,5),     -- n6th_trans_type
    substring(single_rec,327,10)::numeric/1000,    -- n6th_paid_amount
    case when substring(single_rec,338,8) > '00000000' THEN to_date(substring(single_rec,338,8), 'MMDDYYYY')
      else null
    end,                             -- n7th_trans_date
    substring(single_rec,346,12),    -- n7th_invoice_number
    substring(single_rec,358,5),     -- n7th_billing_trans_status_code
    substring(single_rec,363,10)::numeric/1000,    -- n7th_trans_amount
    substring(single_rec,374,5),     -- n7th_trans_type
    substring(single_rec,379,10)::numeric/1000,    -- n7th_paid_amount
    case when substring(single_rec,390,8) > '00000000' THEN to_date(substring(single_rec,390,8), 'MMDDYYYY')
      else null
    end,                             -- n8th_trans_date
    substring(single_rec,398,12),    -- n8th_invoice_number
    substring(single_rec,410,5),     -- n8th_billing_trans_status_code
    substring(single_rec,415,10)::numeric/1000,    -- n8th_trans_amount
    substring(single_rec,426,5),     -- n8th_trans_type
    substring(single_rec,431,10)::numeric/1000,    -- n8th_paid_amount
    case when substring(single_rec,442,8) > '00000000' THEN to_date(substring(single_rec,442,8), 'MMDDYYYY')
      else null
    end,                             -- n9th_trans_date
    substring(single_rec,450,12),    -- n9th_invoice_number
    substring(single_rec,462,5),     -- n9th_billing_trans_status_code
    substring(single_rec,467,10)::numeric/1000,    -- n9th_trans_amount
    substring(single_rec,478,5),     -- n9th_trans_type
    substring(single_rec,483,10)::numeric/1000,    -- n9th_paid_amount
    case when substring(single_rec,494,8) > '00000000' THEN to_date(substring(single_rec,494,8), 'MMDDYYYY')
      else null
    end,                             -- n10th_trans_date
    substring(single_rec,502,12),    -- n10th_invoice_number
    substring(single_rec,514,5),     -- n10th_billing_trans_status_code
    substring(single_rec,519,10)::numeric/1000,    -- n10th_trans_amount
    substring(single_rec,530,5),     -- n10th_trans_type
    substring(single_rec,535,10)::numeric/1000,    -- n10th_paid_amount
    case when substring(single_rec,546,8) > '00000000' THEN to_date(substring(single_rec,546,8), 'MMDDYYYY')
      else null
    end,                             -- n11th_trans_date
    substring(single_rec,554,12),    -- n11th_invoice_number
    substring(single_rec,566,5),     -- n11th_billing_trans_status_code
    substring(single_rec,571,10)::numeric/1000,    -- n11th_trans_amount
    substring(single_rec,582,5),     -- n11th_trans_type
    substring(single_rec,587,10)::numeric/1000,    -- n11th_paid_amount
    case when substring(single_rec,598,8) > '00000000' THEN to_date(substring(single_rec,598,8), 'MMDDYYYY')
      else null
    end,                             -- n12th_trans_date
    substring(single_rec,606,12),    -- n12th_invoice_number
    substring(single_rec,618,5),     -- n12th_billing_trans_status_code
    substring(single_rec,623,10)::numeric/1000,    -- n12th_trans_amount
    substring(single_rec,634,5),     -- n12th_trans_type
    substring(single_rec,639,10)::numeric/1000,    -- n12th_paid_amount
    case when substring(single_rec,650,8) > '00000000' THEN to_date(substring(single_rec,650,8), 'MMDDYYYY')
      else null
    end,                             -- n13th_trans_date
    substring(single_rec,658,12),    -- n13th_invoice_number
    substring(single_rec,670,5),     -- n13th_billing_trans_status_code
    substring(single_rec,675,10)::numeric/1000,    -- n13th_trans_amount
    substring(single_rec,686,5),     -- n13th_trans_type
    substring(single_rec,691,10)::numeric/1000,    -- n13th_paid_amount
    case when substring(single_rec,702,8) > '00000000' THEN to_date(substring(single_rec,702,8), 'MMDDYYYY')
      else null
    end,                             -- n14th_trans_date
    substring(single_rec,710,12),    -- n14th_invoice_number
    substring(single_rec,722,5),     -- n14th_billing_trans_status_code
    substring(single_rec,727,10)::numeric/1000,    -- n14th_trans_amount
    substring(single_rec,738,5),     -- n14th_trans_type
    substring(single_rec,743,10)::numeric/1000,    -- n14th_paid_amount
    case when substring(single_rec,754,8) > '00000000' THEN to_date(substring(single_rec,754,8), 'MMDDYYYY')
      else null
    end,                             -- n15th_trans_date
    substring(single_rec,762,12),    -- n15th_invoice_number
    substring(single_rec,774,5),     -- n15th_billing_trans_status_code
    substring(single_rec,779,10)::numeric/1000,    -- n15th_trans_amount
    substring(single_rec,790,5),     -- n15th_trans_type
    substring(single_rec,795,10)::numeric/1000,    -- n15th_paid_amount
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
from sc220s where substring(single_rec,11,1) = '3');

-- Insert Rec Type 4 into the database

Insert Into sc220_rec4_policy_not_founds
   (representative_number,
    representative_type,
    description,
    record_type,
    request_type,
    policy_type,
    policy_number,
    business_sequence_number,
    error_message,
    created_at,
    updated_at
)
(select
    cast_to_int(substring(single_rec,1,6)),       -- representative_number
    cast_to_int(substring(single_rec,7,2)),       -- representative_type
    substring(single_rec,9,2),       -- description
    cast_to_int(substring(single_rec,11,1)),      -- record_type
    cast_to_int(substring(single_rec,12,3)),      -- request_type
    CASE WHEN cast_to_int(substring(single_rec,15,1)) = 0 THEN 'private_state_fund'
         WHEN cast_to_int(substring(single_rec,15,1)) = 1 THEN 'public_state_fund'
         WHEN cast_to_int(substring(single_rec,15,1)) = 2 THEN 'private_self_insured'
         WHEN cast_to_int(substring(single_rec,15,1)) = 3 THEN 'public_app_fund'
         ELSE substring(single_rec,15,1)
         END,   /*  policy_type  */
    cast_to_int(substring(single_rec,15,1) || substring(single_rec,16,7)),   /*  policy_number  */
    cast_to_int(substring(single_rec,23,3)),      -- business_sequence_number
    substring(single_rec,26,25),     -- error_message
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
from sc220s where substring(single_rec,11,1) = '4');


 /*************** END OF SC220 FILE CONVERSION ***************/

 end;

   $$;


--
-- Name: proc_process_flat_sc230s(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_sc230s() RETURNS void
    LANGUAGE plpgsql
    AS $$

    BEGIN

    INSERT INTO sc230_employer_demographics (
      representative_number,
      representative_type,
      policy_type,
      policy_number,
      business_sequence_number,
      claim_manual_number,
      record_type,
      claim_number,
      policy_name,
      doing_business_as_name,
      street_address,
      city,
      state,
      zip_code,
      created_at,
      updated_at
    )
    (select cast_to_int(substring(single_rec,1,6)),   /*  representative_number  */
            cast_to_int(substring(single_rec,8,2)),   /*  representative_type  */
            CASE WHEN cast_to_int(substring(single_rec,10,1)) = 0 THEN 'private_state_fund'
                 WHEN cast_to_int(substring(single_rec,10,1)) = 1 THEN 'public_state_fund'
                 WHEN cast_to_int(substring(single_rec,10,1)) = 2 THEN 'private_self_insured'
                 WHEN cast_to_int(substring(single_rec,10,1)) = 3 THEN 'public_app_fund'
                 ELSE substring(single_rec,10,1)
                 END,   /*  policy_type  */
            cast_to_int(substring(single_rec,10,1) || substring(single_rec,11,7)),   /*  policy_number  */
            cast_to_int(substring(single_rec,19,3)),   /*  business_sequence_number  */
            cast_to_int(substring(single_rec,22,4)),   /*  claim_manual_number  */
            substring(single_rec,26,2),   /*  record_type  */
            substring(single_rec,28,10),   /*  claim_number  */
            substring(single_rec,38,34),   /*  policy_name  */
            substring(single_rec,72,34),   /*  doing_business_as_name  */
            substring(single_rec,106,34),   /*  street_address  */
            substring(single_rec,140,24),   /*  city  */
            substring(single_rec,164,2),   /*  state  */
            cast_to_int(substring(single_rec,166,5)),   /*  zip_code  */
            current_timestamp::timestamp as created_at,
            current_timestamp::timestamp as updated_at
    from sc230s WHERE substring(single_rec,26,2) = '01');

    /* Claim Medical Payments Record – Record Type ‘02’: */

    INSERT INTO sc230_claim_medical_payments (
      representative_number,
      representative_type,
      policy_type,
      policy_number,
      business_sequence_number,
      claim_manual_number,
      record_type,
      claim_number,
      hearing_date,
      injury_date,
      from_date,
      to_date,
      award_type,
      number_of_weeks,
      awarded_weekly_rate,
      award_amount,
      payment_amount,
      claimant_name,
      payee_name,
      created_at,
      updated_at

    )
    (select cast_to_int(substring(single_rec,1,6)),   /*  representative_number  */
            cast_to_int(substring(single_rec,8,2)),   /*  representative_type  */
            cast_to_int(substring(single_rec,10,1)),   /*  policy_type  */
            cast_to_int(substring(single_rec,11,7)),   /*  policy_sequence_number  */
            cast_to_int(substring(single_rec,19,3)),   /*  business_sequence_number  */
            cast_to_int(substring(single_rec,22,4)),   /*  claim_manual_number  */
            substring(single_rec,26,2),   /*  record_type  */
            substring(single_rec,28,10),   /*  claim_number  */
            case when substring(single_rec,38,6) > '00000000' THEN to_date(substring(single_rec,38,6), 'YYMMDD')
              else null
            end,   /*  hearing_date  */
            case when substring(single_rec,44,6) > '00000000' THEN to_date(substring(single_rec,44,6), 'YYMMDD')
              else null
            end,   /*  injury_date  */
            substring(single_rec,50,6),   /*  from_date  */
            substring(single_rec,56,6),   /*  to_date  */
            substring(single_rec,62,2),   /*  award_type  */
            substring(single_rec,64,6),   /*  number_of_weeks  */
            substring(single_rec,70,6),   /*  awarded_weekly_rate  */
            cast_to_int(substring(single_rec,76,9)),   /*  award_amount  */
            substring(single_rec,86,9)::numeric/100,   /*  payment_amount  */
            substring(single_rec,96,26),   /*  claimant_name  */
            substring(single_rec,122,24),   /*  payee_name  */
            current_timestamp::timestamp as created_at,
            current_timestamp::timestamp as updated_at
    from sc230s WHERE substring(single_rec,26,2) = '02');

    /* SC230	Claim Indemnity Awards Record – Record Type ‘03’: */
    INSERT INTO sc230_claim_indemnity_awards (
      representative_number,
      representative_type,
      policy_type,
      policy_number,
      business_sequence_number,
      claim_manual_number,
      record_type,
      claim_number,
      hearing_date,
      injury_date,
      from_date,
      to_date,
      award_type,
      number_of_weeks,
      awarded_weekly_rate,
      award_amount,
      payment_amount,
      claimant_name,
      payee_name,
      created_at,
      updated_at
    )
    (select cast_to_int(substring(single_rec,1,6)),   /*  representative_number  */
            cast_to_int(substring(single_rec,8,2)),   /*  representative_type  */
            cast_to_int(substring(single_rec,10,1)),   /*  policy_type  */
            cast_to_int(substring(single_rec,11,7)),   /*  policy_sequence_number  */
            cast_to_int(substring(single_rec,19,3)),   /*  business_sequence_number  */
            cast_to_int(substring(single_rec,22,4)),   /*  claim_manual_number  */
            substring(single_rec,26,2),   /*  record_type  */
            substring(single_rec,28,10),   /*  claim_number  */
            case when substring(single_rec,38,6) > '00000000' THEN to_date(substring(single_rec,38,6), 'YYMMDD')
              else null
            end,   /*  hearing_date  */
            case when substring(single_rec,44,6) > '00000000' THEN to_date(substring(single_rec,44,6), 'YYMMDD')
              else null
            end,   /*  injury_date  */
            case when substring(single_rec,50,6) > '00000000' THEN to_date(substring(single_rec,50,6), 'YYMMDD')
              else null
            end,   /*  from_date  */
            case when substring(single_rec,56,6) > '00000000' THEN to_date(substring(single_rec,56,6), 'YYMMDD')
              else null
            end,   /*  to_date  */
            substring(single_rec,62,2),   /*  award_type  */
            substring(single_rec,64,6),   /*  number_of_weeks  */
            substring(single_rec,70,6)::numeric/100,   /*  awarded_weekly_rate  */
            substring(single_rec,76,9)::numeric/100,   /*  award_amount  */
            cast_to_int(substring(single_rec,86,9)),   /*  payment_amount  */
            substring(single_rec,96,26),   /*  claimant_name  */
            substring(single_rec,122,24),   /*  payee_name  */
            current_timestamp::timestamp as created_at,
            current_timestamp::timestamp as updated_at
    from sc230s WHERE substring(single_rec,26,2) = '03');

    end;

      $$;


--
-- Name: proc_step_1(integer, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_1(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date) RETURNS void
    LANGUAGE plpgsql
    AS $_$

        DECLARE
          run_date timestamp := LOCALTIMESTAMP;
        BEGIN


        /*  BEGIN GROUP RATING PROCESS OF INSERTING RECORDS FROM FLAT FILES INTO THE NEWLY CREATED PROCESS AND FINAL TABLES        */

        -- STEP 1 A -- CREATE FINAL EMPLOYER DEMOGRAPHICS

        INSERT INTO final_employer_demographics_informations (
          representative_number,
          policy_type,
          policy_number,
          successor_policy_number,
          currently_assigned_representative_number,
          federal_identification_number,
          business_name,
          trading_as_name,
          in_care_name_contact_name,
          address_1,
          address_2,
          city,
          state,
          zip_code,
          zip_code_plus_4,
          country_code,
          county,
          merit_rate,
          group_code,
          minimum_premium_percentage,
          rate_adjust_factor,
          em_effective_date,
          regular_balance_amount,
          attorney_general_balance_amount,
          appealed_balance_amount,
          pending_balance_amount,
          advance_deposit_amount,
          data_source,
          created_at,
          updated_at
            )

        (Select
          representative_number,
          policy_type,
          policy_number,
          successor_policy_number,
          currently_assigned_representative_number,
          federal_identification_number,
          REGEXP_REPLACE(business_name, '\s+$', ''),
          REGEXP_REPLACE(trading_as_name, '\s+$', ''),
          REGEXP_REPLACE(in_care_name_contact_name, '\s+$', ''),
          REGEXP_REPLACE(address_1, '\s+$', ''),
          REGEXP_REPLACE(address_2, '\s+$', ''),
          REGEXP_REPLACE(city, '\s+$', ''),
          REGEXP_REPLACE(state, '\s+$', ''),
          zip_code,
          zip_code_plus_4,
          country_code,
          county,
          merit_rate,
          group_code,
          minimum_premium_percentage,
          rate_adjust_factor,
          em_effective_date,
          regular_balance_amount,
          attorney_general_balance_amount,
          appealed_balance_amount,
          pending_balance_amount,
          advance_deposit_amount,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.sc220_rec1_employer_demographics
        WHERE representative_number = process_representative
        );



        -- STEP 1B -- CREATE POLICY COVERAGE HISTORY FROM SC220


        Insert into process_policy_coverage_status_histories
        (
          representative_number,
           policy_type,
           policy_number,
           coverage_effective_date,
           coverage_end_date,
           coverage_status,
           data_source,
           created_at,
           updated_at
        )

        (SELECT
        representative_number,
        policy_type,
        policy_number,
        coverage_effective_date,
        coverage_end_date,
        coverage_status,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM sc220_rec1_employer_demographics
        WHERE coverage_effective_date is not null and representative_number = process_representative
        );

        Insert into process_policy_coverage_status_histories
        (
          representative_number,
          policy_type,
           policy_number,
           coverage_effective_date,
           coverage_end_date,
           coverage_status,
           data_source,
    	created_at,
    	updated_at
        )
        (SELECT
        representative_number,
        policy_type,
        policy_number,
        n2nd_coverage_effective_date,
        n2nd_coverage_end_date,
        n2nd_coverage_status,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM sc220_rec1_employer_demographics
        WHERE n2nd_coverage_effective_date is not null
        and representative_number = process_representative
        );

        Insert into process_policy_coverage_status_histories
        (
          representative_number,
           policy_type,
           policy_number,
           coverage_effective_date,
           coverage_end_date,
           coverage_status,
           data_source,
    	     created_at,
    	     updated_at
        )
        (SELECT
        representative_number,
         policy_type,
        policy_number,
        n3rd_coverage_effective_date,
        n3rd_coverage_end_date,
        n3rd_coverage_status,
        'bwc' as data_source,
            run_date as created_at,
        run_date as updated_at
        FROM sc220_rec1_employer_demographics
        WHERE n3rd_coverage_effective_date is not null
        and representative_number = process_representative
        );

        Insert into process_policy_coverage_status_histories
        (
          representative_number,
           policy_type,
           policy_number,
           coverage_effective_date,
           coverage_end_date,
           coverage_status,
           data_source,
           created_at,
           updated_at
        )
        (SELECT
        representative_number,
         policy_type,
        policy_number,
        n4th_coverage_effective_date,
        n4th_coverage_end_date,
        n4th_coverage_status,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM sc220_rec1_employer_demographics
        WHERE n4th_coverage_effective_date is not null
        and representative_number = process_representative
        );

        Insert into process_policy_coverage_status_histories
        (
          representative_number,
           policy_type,
           policy_number,
           coverage_effective_date,
           coverage_end_date,
           coverage_status,
           data_source,
           created_at,
           updated_at
        )
        (SELECT
        representative_number,
         policy_type,
        policy_number,
        n5th_coverage_effective_date,
        n5th_coverage_end_date,
        n5th_coverage_status,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM sc220_rec1_employer_demographics
        WHERE n5th_coverage_effective_date is not null
        and representative_number = process_representative
        );


        Insert into process_policy_coverage_status_histories
        (
          representative_number,
           policy_type,
           policy_number,
           coverage_effective_date,
           coverage_end_date,
           coverage_status,
           data_source,
           created_at,
           updated_at
        )

        (SELECT
        representative_number,
         policy_type,
        policy_number,
        n6th_coverage_effective_date,
        n6th_coverage_end_date,
        n6th_coverage_status,
        'bwc' as data_source,
            run_date as created_at,
        run_date as updated_at
        FROM sc220_rec1_employer_demographics
        WHERE n6th_coverage_effective_date is not null
        and representative_number = process_representative
        );

        Update public.process_policy_coverage_status_histories pcsh set (lapse_days, updated_at) = (t2.lapse_days, t2.updated_at)
        FROM
        (SELECT a.representative_number,
         policy_type,
          a.policy_number,
          a.coverage_effective_date,
          a.coverage_end_date,
          a.coverage_status,
          (CASE WHEN a.coverage_status = 'LAPSE' and a.coverage_end_date is not null Then (a.coverage_end_date - a.coverage_effective_date)
               WHEN a.coverage_status = 'LAPSE' and a.coverage_end_date is null THEN (run_date::date - a.coverage_effective_date)
               ELSE '0'::integer END) as lapse_days,
           run_date as updated_at
          FROM public.process_policy_coverage_status_histories a
          WHERE a.representative_number = process_representative
        ) t2
        WHERE pcsh.representative_number = t2.representative_number and pcsh.policy_number = t2.policy_number and pcsh.coverage_effective_date = t2.coverage_effective_date and pcsh.coverage_end_date = t2.coverage_end_date and pcsh.coverage_status = t2.coverage_status;


        Update public.process_policy_coverage_status_histories pcsh set (lapse_days, updated_at) = (t2.lapse_days, t2.updated_at)
        FROM
        (SELECT a.representative_number,
         policy_type,
          a.policy_number,
          a.coverage_effective_date,
          a.coverage_end_date,
          a.coverage_status,
          (run_date::date - a.coverage_effective_date) as lapse_days,
           run_date as updated_at
          FROM public.process_policy_coverage_status_histories a
          WHERE a.coverage_end_date is null and a.coverage_status = 'LAPSE'
          and a.representative_number = process_representative
        ) t2
        WHERE  pcsh.policy_number = t2.policy_number and pcsh.coverage_effective_date = t2.coverage_effective_date and pcsh.coverage_status = t2.coverage_status ;


        -- 65 milliseconds

        -- Add policy_creation_date to the employer_demographics_information file first from Steve's file


        UPDATE public.final_employer_demographics_informations edi SET
        (policy_creation_date, updated_at) =
        (t2.policy_creation_date, t2.updated_at)
        FROM
        (SELECT a.policy_number,
            a.policy_original_effective_date as policy_creation_date,
            run_date as updated_at
        FROM bwc_codes_policy_effective_dates a
        ) t2
        WHERE edi.policy_number = t2.policy_number;



        -- UPDATE Null values of creation date that do not exist from Steve's file.
        UPDATE public.final_employer_demographics_informations edi SET
        (policy_creation_date, updated_at) = (t2.min_coverage_effective_date, t2.updated_at)
        FROM
        (SELECT min_pcsh.policy_number,
            min(min_pcsh.coverage_effective_date) as min_coverage_effective_date,
            run_date as updated_at
        FROM process_policy_coverage_status_histories min_pcsh
        WHERE policy_number in
          (
            SELECT policy_number from public.final_employer_demographics_informations WHERE policy_creation_date is null
          )
        GROUP BY policy_number
        ORDER by policy_number
        ) t2
        WHERE edi.policy_number = t2.policy_number;




        UPDATE public.final_employer_demographics_informations edi SET
        (current_policy_status, current_policy_status_effective_date, updated_at) =
        (t2.max_coverage_status, t2.max_coverage_effective_date, t2.updated_at)
        FROM
        (
          (SELECT max_pcsh.policy_number as max_policy_number,
              max_pcsh.coverage_effective_date as max_coverage_effective_date,
              max_pcsh.coverage_status as max_coverage_status,
              run_date as updated_at
          FROM process_policy_coverage_status_histories max_pcsh
          Inner Join (
              SELECT policy_number, max(coverage_effective_date) as coverage_effective_date
              FROM process_policy_coverage_status_histories
              GROUP BY policy_number
          ) b ON max_pcsh.policy_number = b.policy_number and max_pcsh.coverage_effective_date = b.coverage_effective_date)
        ) t2
        WHERE edi.policy_number = t2.max_policy_number;

        end;
          $_$;


--
-- Name: proc_step_100(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_100(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $_$

        DECLARE
          run_date timestamp := LOCALTIMESTAMP;
        BEGIN

        /* UPDATED FROM NEW PIRS FILES MONDAY, DECEMBER 5, 2015 */


        -- STEP 1 A -- CREATE FINAL EMPLOYER DEMOGRAPHICS

        INSERT INTO final_employer_demographics_informations (
          representative_number,
          policy_number,
          valid_policy_number,
          current_coverage_status,
          coverage_status_effective_date,
          federal_identification_number,
          business_name,
          trading_as_name,
          valid_mailing_address,
          mailing_address_line_1,
          mailing_address_line_2,
          mailing_city,
          mailing_state,
          mailing_zip_code,
          mailing_zip_code_plus_4,
          mailing_country_code,
          mailing_county,
          valid_location_address,
          location_address_line_1,
          location_address_line_2,
          location_city,
          location_state,
          location_zip_code,
          location_zip_code_plus_4,
          location_country_code,
          location_county,
          currently_assigned_clm_representative_number,
          currently_assigned_risk_representative_number,
          currently_assigned_erc_representative_number,
          currently_assigned_grc_representative_number,
          immediate_successor_policy_number,
          immediate_successor_business_sequence_number,
          ultimate_successor_policy_number,
          ultimate_successor_business_sequence_number,
          employer_type,
          coverage_type,
          policy_employer_type,
          policy_coverage_type,
          data_source,
          created_at,
          updated_at
        )

        (Select
          representative_number,
          policy_number,
          valid_policy_number,
          REGEXP_REPLACE(current_coverage_status, '\s+$', ''),
          coverage_status_effective_date,
          federal_identification_number,
          REGEXP_REPLACE(business_name, '\s+$', ''),
          REGEXP_REPLACE(trading_as_name, '\s+$', ''),
          valid_mailing_address,
          REGEXP_REPLACE(mailing_address_line_1, '\s+$', ''),
          REGEXP_REPLACE(mailing_address_line_2, '\s+$', ''),
          REGEXP_REPLACE(mailing_city, '\s+$', ''),
          REGEXP_REPLACE(mailing_state, '\s+$', ''),
          mailing_zip_code,
          mailing_zip_code_plus_4,
          mailing_country_code,
          mailing_county,
          valid_location_address,
          REGEXP_REPLACE(location_address_line_1, '\s+$', ''),
          REGEXP_REPLACE(location_address_line_2, '\s+$', ''),
          REGEXP_REPLACE(location_city, '\s+$', ''),
          REGEXP_REPLACE(location_state, '\s+$', ''),
          location_zip_code,
          location_zip_code_plus_4,
          location_country_code,
          location_county,
          currently_assigned_clm_representative_number,
          currently_assigned_risk_representative_number,
          currently_assigned_erc_representative_number,
          currently_assigned_grc_representative_number,
          immediate_successor_policy_number,
          immediate_successor_business_sequence_number,
          ultimate_successor_policy_number,
          ultimate_successor_business_sequence_number,
          employer_type,
          coverage_type,
          CASE WHEN employer_type = 'PA ' THEN 'private_account'
        		   WHEN employer_type = 'PEC' THEN 'public_employer_county'
        		   WHEN employer_type = 'PES' THEN 'public_employer_state'
          end as policy_employer_type,
          CASE WHEN coverage_type = 'SF' THEN 'state_fund'
        		   WHEN coverage_type = 'SI' THEN 'self_insured'
        		   WHEN coverage_type = 'BL' THEN 'black_lung'
        		   WHEN coverage_type = 'ML' THEN 'marine_fund'
          end as policy_coverage_type,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.pdemo_detail_records
        WHERE representative_number = process_representative
        );



        -- STEP 1B -- CREATE POLICY COVERAGE HISTORY FROM SC220


        Insert into process_policy_coverage_status_histories
        (
        representative_number,
        policy_number,
        coverage_status,
        coverage_effective_date,
        coverage_end_date,
        data_source,
        created_at,
        updated_at
        )

        (SELECT
        representative_number,
        policy_number,
        coverage_status,
        coverage_status_effective_date,
        coverage_status_end_date,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM pcovg_detail_records
        WHERE coverage_status_effective_date is not null and representative_number = process_representative
        ORDER BY policy_number, coverage_status_effective_date DESC
        );


        --     UPDATE LAPSE PERIOD

        Update public.process_policy_coverage_status_histories pcsh set (lapse_days, updated_at) = (t2.lapse_days, t2.updated_at)
        FROM
        (SELECT a.representative_number,
          a.policy_number,
          a.coverage_effective_date,
          a.coverage_end_date,
          a.coverage_status,
          (CASE WHEN a.coverage_status = 'LAPSE' and a.coverage_end_date is not null Then (a.coverage_end_date - a.coverage_effective_date)
               WHEN a.coverage_status = 'LAPSE' and a.coverage_end_date is null THEN (run_date::date - a.coverage_effective_date)
               WHEN a.coverage_status = 'LAPSE' and a.coverage_end_date is null THEN (run_date::date - a.coverage_effective_date)
               ELSE '0'::integer END) as lapse_days,
          run_date as updated_at
          FROM public.process_policy_coverage_status_histories a
          WHERE a.representative_number = process_representative
        ) t2
        WHERE pcsh.representative_number = t2.representative_number and pcsh.policy_number = t2.policy_number and pcsh.coverage_effective_date = t2.coverage_effective_date and pcsh.coverage_end_date = t2.coverage_end_date and pcsh.coverage_status = t2.coverage_status;


        -- UPDATE current coverage status periods that are lapse with the number of days they have been lapse.

        Update public.process_policy_coverage_status_histories pcsh set (lapse_days, updated_at) = (t2.lapse_days, t2.updated_at)
        FROM
        (SELECT a.representative_number,
         policy_type,
          a.policy_number,
          a.coverage_effective_date,
          a.coverage_end_date,
          a.coverage_status,
          (run_date::date - a.coverage_effective_date) as lapse_days,
           run_date as updated_at
          FROM public.process_policy_coverage_status_histories a
          WHERE a.coverage_end_date is null and a.coverage_status = 'LAPSE'
          and a.representative_number = process_representative
        ) t2
        WHERE  pcsh.policy_number = t2.policy_number and pcsh.coverage_effective_date = t2.coverage_effective_date and pcsh.coverage_status = t2.coverage_status ;


        -- 65 milliseconds



        UPDATE public.final_employer_demographics_informations edi SET
        (policy_creation_date, updated_at) =
        (t2.min_coverage_effective_date, t2.updated_at)
        FROM
        (
        SELECT a.representative_number,
          a.policy_number,
          MIN(a.coverage_effective_date) as min_coverage_effective_date,
           current_timestamp as updated_at
          FROM public.process_policy_coverage_status_histories a
          GROUP BY a.representative_number, a.policy_number
        ) t2
        WHERE edi.policy_number = t2.policy_number;

        end;
          $_$;


--
-- Name: proc_step_2(integer, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_2(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

      DECLARE
        run_date timestamp := LOCALTIMESTAMP;
      BEGIN
      -- STEP 2A -- Process Payroll File
      /*************** Create Table for transposing the columns of sc220 to rows ***************/
      /*************** Union all queries of subsets of sc220 into rows of new table ***************/

      INSERT INTO process_payroll_breakdown_by_manual_classes (
        representative_number,
          policy_type,
        	policy_number,
        	manual_number,
        	manual_type,
        	reporting_period_start_date,
        	reporting_period_end_date,
        	manual_class_rate,
        	manual_class_payroll,
        	manual_class_premium,
          payroll_origin,
          data_source,
          created_at,
          updated_at
      )
      (SELECT representative_number,
        policy_type,
        policy_number,
      	manual_number,
      	manual_type,
      	manual_effective_date as reporting_period_start_date,
      	(manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
      	manual_class_rate as manual_class_rate,
      	year_to_date_payroll as manual_class_payroll,
      	year_to_date_premium_billed as manual_class_premium,
        'payroll' as payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
      	FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE manual_effective_date is not null and representative_number = process_representative and manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );

        INSERT INTO process_payroll_breakdown_by_manual_classes (
          representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            manual_class_premium,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
        	policy_number,
        	manual_number,
        	manual_type,
        	n2nd_manual_effective_date as reporting_period_start_date,
        	(n2nd_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
        	n2nd_manual_class_rate as manual_class_rate,
        	n2nd_year_to_date_payroll as manual_class_payroll,
        	n2nd_year_to_date_premium_billed as manual_class_premium,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        	FROM public.sc220_rec2_employer_manual_level_payrolls
          WHERE n2nd_manual_effective_date is not null and representative_number = process_representative and n2nd_manual_effective_date >= experience_period_lower_date
          ORDER BY
            policy_number ASC,
            manual_number ASC,
            reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
          representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            manual_class_premium,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
        	policy_number,
        	manual_number,
        	manual_type,
        	n3rd_manual_effective_date as reporting_period_start_date,
        	(n3rd_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
        	n3rd_manual_class_rate as manual_class_rate,
        	n3rd_year_to_date_payroll as manual_class_payroll,
        	n3rd_year_to_date_premium_billed as manual_class_premium,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      	   FROM public.sc220_rec2_employer_manual_level_payrolls
           WHERE n3rd_manual_effective_date is not null and representative_number = process_representative and n3rd_manual_effective_date >= experience_period_lower_date
           ORDER BY
             policy_number ASC,
             manual_number ASC,
             reporting_period_start_date ASC
           );
           INSERT INTO process_payroll_breakdown_by_manual_classes (
             representative_number,
               policy_type,
               policy_number,
               manual_number,
               manual_type,
               reporting_period_start_date,
               reporting_period_end_date,
               manual_class_rate,
               manual_class_payroll,
               manual_class_premium,
               payroll_origin,
               data_source,
               created_at,
               updated_at
           )
        (SELECT representative_number,
          policy_type,
        	policy_number,
        	manual_number,
        	manual_type,
        	n4th_manual_effective_date as reporting_period_start_date,
        	(n4th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
        	n4th_manual_class_rate as manual_class_rate,
        	n4th_year_to_date_payroll as manual_class_payroll,
        	n4th_year_to_date_premium_billed as manual_class_premium,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        	FROM public.sc220_rec2_employer_manual_level_payrolls
          WHERE n4th_manual_effective_date is not null and representative_number = process_representative and n4th_manual_effective_date >= experience_period_lower_date
          ORDER BY
            policy_number ASC,
            manual_number ASC,
            reporting_period_start_date ASC
          );
          INSERT INTO process_payroll_breakdown_by_manual_classes (
            representative_number,
              policy_type,
              policy_number,
              manual_number,
              manual_type,
              reporting_period_start_date,
              reporting_period_end_date,
              manual_class_rate,
              manual_class_payroll,
              manual_class_premium,
              payroll_origin,
              data_source,
              created_at,
              updated_at
          )
        (SELECT representative_number,
        policy_type,
      	policy_number,
      	manual_number,
      	manual_type,
      	n5th_manual_effective_date as reporting_period_start_date,
      	(n5th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
      	n5th_manual_class_rate as manual_class_rate,
      	n5th_year_to_date_payroll as manual_class_payroll,
      	n5th_year_to_date_premium_billed as manual_class_premium,
        'payroll' as payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
      	FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n5th_manual_effective_date is not null and representative_number = process_representative and n5th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
          representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            manual_class_premium,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
        	policy_number,
        	manual_number,
        	manual_type,
        	n6th_manual_effective_date as reporting_period_start_date,
        	(n6th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
        	n6th_manual_class_rate as manual_class_rate,
        	n6th_year_to_date_payroll as manual_class_payroll,
        	n6th_year_to_date_premium_billed as manual_class_premium,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      	FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n6th_manual_effective_date is not null and representative_number = process_representative and n6th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
          representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            manual_class_premium,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
        	policy_number,
        	manual_number,
        	manual_type,
        	n7th_manual_effective_date as reporting_period_start_date,
        	(n7th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
        	n7th_manual_class_rate as manual_class_rate,
        	n7th_year_to_date_payroll as manual_class_payroll,
        	n7th_year_to_date_premium_billed as manual_class_premium,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      	FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n7th_manual_effective_date is not null and representative_number = process_representative and n7th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
          representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            manual_class_premium,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
        	policy_number,
        	manual_number,
        	manual_type,
        	n8th_manual_effective_date as reporting_period_start_date,
        	(n8th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
        	n8th_manual_class_rate as manual_class_rate,
        	n8th_year_to_date_payroll as manual_class_payroll,
        	n8th_year_to_date_premium_billed as manual_class_premium,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      	FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n8th_manual_effective_date is not null and representative_number = process_representative and n8th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
          representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            manual_class_premium,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
        	policy_number,
        	manual_number,
        	manual_type,
        	n9th_manual_effective_date as reporting_period_start_date,
        	(n9th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
        	n9th_manual_class_rate as manual_class_rate,
        	n9th_year_to_date_payroll as manual_class_payroll,
        	n9th_year_to_date_premium_billed as manual_class_premium,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      	FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n9th_manual_effective_date is not null and representative_number = process_representative and n9th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
          representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            manual_class_premium,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
        	policy_number,
        	manual_number,
        	manual_type,
        	n10th_manual_effective_date as reporting_period_start_date,
        	(n10th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
        	n10th_manual_class_rate as manual_class_rate,
        	n10th_year_to_date_payroll as manual_class_payroll,
        	n10th_year_to_date_premium_billed as manual_class_premium,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      	FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n10th_manual_effective_date is not null and representative_number = process_representative and n10th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
          representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            manual_class_premium,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
        	policy_number,
        	manual_number,
        	manual_type,
        	n11th_manual_effective_date as reporting_period_start_date,
        	(n11th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
        	n11th_manual_class_rate as manual_class_rate,
        	n11th_year_to_date_payroll as manual_class_payroll,
        	n11th_year_to_date_premium_billed as manual_class_premium,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      	FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n11th_manual_effective_date is not null and representative_number = process_representative and n11th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
          representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            manual_class_premium,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
        	policy_number,
        	manual_number,
        	manual_type,
        	n12th_manual_effective_date as reporting_period_start_date,
        	(n12th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
        	n12th_manual_class_rate as manual_class_rate,
        	n12th_year_to_date_payroll as manual_class_payroll,
        	n12th_year_to_date_premium_billed as manual_class_premium,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        	FROM public.sc220_rec2_employer_manual_level_payrolls
          WHERE n12th_manual_effective_date is not null and representative_number = process_representative and n12th_manual_effective_date >= experience_period_lower_date
          ORDER BY
            policy_number ASC,
            manual_number ASC,
            reporting_period_start_date ASC
        );


          DELETE FROM public.process_payroll_breakdown_by_manual_classes
          WHERE id IN (SELECT id
                FROM (SELECT id,
                               ROW_NUMBER() OVER (partition BY policy_type, policy_number, manual_number, manual_type, reporting_period_start_date, manual_class_rate, manual_class_payroll, manual_class_premium, payroll_origin, data_source, created_at, updated_at ORDER BY id) AS rnum
                       FROM public.process_payroll_breakdown_by_manual_classes) t
                WHERE t.rnum > 1);

      end;

        $$;


--
-- Name: proc_step_200(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_200(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

      DECLARE
        run_date timestamp := LOCALTIMESTAMP;
      BEGIN

      /* UPDATED FROM NEW PIRS FILES MONDAY, DECEMBER 5, 2015 */



      INSERT INTO process_payroll_breakdown_by_manual_classes (
        representative_number,
        policy_number,
        policy_status_effective_date,
        policy_status,
        manual_number,
        manual_class_type,
        manual_class_description,
        bwc_customer_id,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_rate,
        manual_class_payroll,
        reporting_type,
        number_of_employees,
        payroll_origin,
        data_source,
        created_at,
        updated_at
      )
      (SELECT
          a.representative_number,
          a.policy_number,
          a.policy_status_effective_date,
          a.policy_status,
          a.manual_class as manual_number,
          a.manual_class_type,
          a.manual_class_description,
          a.bwc_customer_id,
          a.reporting_period_start_date,
          a.reporting_period_end_date,
          a.manual_class_rate,
          a.payroll as manual_class_payroll,
          a.reporting_type,
          a.number_of_employees,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.rate_detail_records a
        LEFT JOIN public.final_employer_demographics_informations b
        ON a.policy_number = b.policy_number
        WHERE a.reporting_period_start_date is not null and a.representative_number = process_representative and a.reporting_period_start_date >= experience_period_lower_date and a.reporting_period_start_date >= b.policy_creation_date
        ORDER BY
          policy_number ASC,
          manual_class ASC,
          reporting_period_start_date ASC
        );





      -- Add SC220 AND WILL REMOVE ONCE THE BWC CHANGES THE RATES FILE TO INCLUDE HISTORY VALUES

      INSERT INTO process_payroll_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_class_type,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_rate,
          manual_class_payroll,
          reporting_type,
          payroll_origin,
          data_source,
          created_at,
          updated_at
      )
      (SELECT representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_type as manual_class_type,
          manual_effective_date as reporting_period_start_date,
          (manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
          manual_class_rate,
          year_to_date_payroll as manual_class_payroll,
          'A' as reporting_type,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      FROM public.sc220_rec2_employer_manual_level_payrolls
      WHERE manual_effective_date is not null and representative_number = process_representative and manual_effective_date >= experience_period_lower_date
      ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );

        INSERT INTO process_payroll_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_class_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            reporting_type,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_type as manual_class_type,
          n2nd_manual_effective_date as reporting_period_start_date,
          (n2nd_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
          n2nd_manual_class_rate as manual_class_rate,
          n2nd_year_to_date_payroll as manual_class_payroll,
          'A' as reporting_type,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
          FROM public.sc220_rec2_employer_manual_level_payrolls
          WHERE n2nd_manual_effective_date is not null and representative_number = process_representative and n2nd_manual_effective_date >= experience_period_lower_date
          ORDER BY
            policy_number ASC,
            manual_number ASC,
            reporting_period_start_date ASC
        );


        INSERT INTO process_payroll_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_class_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            reporting_type,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_type as manual_class_type,
          n3rd_manual_effective_date as reporting_period_start_date,
          (n3rd_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
          n3rd_manual_class_rate as manual_class_rate,
          n3rd_year_to_date_payroll as manual_class_payroll,
          'A' as reporting_type,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
           FROM public.sc220_rec2_employer_manual_level_payrolls
           WHERE n3rd_manual_effective_date is not null and representative_number = process_representative and n3rd_manual_effective_date >= experience_period_lower_date
           ORDER BY
             policy_number ASC,
             manual_number ASC,
             reporting_period_start_date ASC
           );
           INSERT INTO process_payroll_breakdown_by_manual_classes (
             representative_number,
             policy_type,
             policy_number,
             manual_number,
             manual_class_type,
             reporting_period_start_date,
             reporting_period_end_date,
             manual_class_rate,
             manual_class_payroll,
             reporting_type,
             payroll_origin,
             data_source,
             created_at,
             updated_at
           )
        (SELECT representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_type as manual_class_type,
          n4th_manual_effective_date as reporting_period_start_date,
          (n4th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
          n4th_manual_class_rate as manual_class_rate,
          n4th_year_to_date_payroll as manual_class_payroll,
          'A' as reporting_type,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
          FROM public.sc220_rec2_employer_manual_level_payrolls
          WHERE n4th_manual_effective_date is not null and representative_number = process_representative and n4th_manual_effective_date >= experience_period_lower_date
          ORDER BY
            policy_number ASC,
            manual_number ASC,
            reporting_period_start_date ASC
          );
          INSERT INTO process_payroll_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_class_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            reporting_type,
            payroll_origin,
            data_source,
            created_at,
            updated_at
          )
        (SELECT representative_number,
        policy_type,
        policy_number,
        manual_number,
        manual_type as manual_class_type,
        n5th_manual_effective_date as reporting_period_start_date,
        (n5th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
        n5th_manual_class_rate as manual_class_rate,
        n5th_year_to_date_payroll as manual_class_payroll,
        'A' as reporting_type,
        'payroll' as payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n5th_manual_effective_date is not null and representative_number = process_representative and n5th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_class_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            reporting_type,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_type as manual_class_type,
          n6th_manual_effective_date as reporting_period_start_date,
          (n6th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
          n6th_manual_class_rate as manual_class_rate,
          n6th_year_to_date_payroll as manual_class_payroll,
          'A' as reporting_type,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n6th_manual_effective_date is not null and representative_number = process_representative and n6th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_class_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            reporting_type,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_type as manual_class_type,
          n7th_manual_effective_date as reporting_period_start_date,
          (n7th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
          n7th_manual_class_rate as manual_class_rate,
          n7th_year_to_date_payroll as manual_class_payroll,
          'A' as reporting_type,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n7th_manual_effective_date is not null and representative_number = process_representative and n7th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_class_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            reporting_type,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_type as manual_class_type,
          n8th_manual_effective_date as reporting_period_start_date,
          (n8th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
          n8th_manual_class_rate as manual_class_rate,
          n8th_year_to_date_payroll as manual_class_payroll,
          'A' as reporting_type,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n8th_manual_effective_date is not null and representative_number = process_representative and n8th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_class_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            reporting_type,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_type as manual_class_type,
          n9th_manual_effective_date as reporting_period_start_date,
          (n9th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
          n9th_manual_class_rate as manual_class_rate,
          n9th_year_to_date_payroll as manual_class_payroll,
          'A' as reporting_type,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n9th_manual_effective_date is not null and representative_number = process_representative and n9th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_class_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            reporting_type,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_type as manual_class_type,
          n10th_manual_effective_date as reporting_period_start_date,
          (n10th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
          n10th_manual_class_rate as manual_class_rate,
          n10th_year_to_date_payroll as manual_class_payroll,
          'A' as reporting_type,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n10th_manual_effective_date is not null and representative_number = process_representative and n10th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_number,
            manual_class_type,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            reporting_type,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_type as manual_class_type,
          n11th_manual_effective_date as reporting_period_start_date,
          (n11th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
          n11th_manual_class_rate as manual_class_rate,
          n11th_year_to_date_payroll as manual_class_payroll,
          'A' as reporting_type,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.sc220_rec2_employer_manual_level_payrolls
        WHERE n11th_manual_effective_date is not null and representative_number = process_representative and n11th_manual_effective_date >= experience_period_lower_date
        ORDER BY
          policy_number ASC,
          manual_number ASC,
          reporting_period_start_date ASC
        );
        INSERT INTO process_payroll_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_class_type,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_rate,
          manual_class_payroll,
          reporting_type,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_type as manual_class_type,
          n12th_manual_effective_date as reporting_period_start_date,
          (n12th_manual_effective_date + (6::text || ' month')::interval  - (1::text || ' day')::interval)::date as reporting_period_end_date,
          n12th_manual_class_rate as manual_class_rate,
          n12th_year_to_date_payroll as manual_class_payroll,
          'A' as reporting_type,
          'payroll' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
          FROM public.sc220_rec2_employer_manual_level_payrolls
          WHERE n12th_manual_effective_date is not null and representative_number = process_representative and n12th_manual_effective_date >= experience_period_lower_date
          ORDER BY
            policy_number ASC,
            manual_number ASC,
            reporting_period_start_date ASC
        );


          DELETE FROM public.process_payroll_breakdown_by_manual_classes
          WHERE id IN (SELECT id
                FROM (SELECT id,
                               ROW_NUMBER() OVER (partition BY policy_type, policy_number, manual_number, manual_class_type, reporting_period_start_date, reporting_period_end_date, manual_class_rate, manual_class_payroll, reporting_type, payroll_origin, data_source ORDER BY id) AS rnum
                       FROM public.process_payroll_breakdown_by_manual_classes) t
                WHERE t.rnum > 1);

      end;

        $$;


--
-- Name: proc_step_3(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_3(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

        DECLARE
          run_date timestamp := LOCALTIMESTAMP;
        BEGIN


        -- STEP 3A POLICY COMBINE FULL TRANSFER

        INSERT INTO process_policy_combine_full_transfers (
          representative_number,
          policy_type,
          manual_number,
          manual_type,
          manual_class_effective_date,
          manual_class_rate,
          manual_class_payroll,
          manual_class_premium,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT DISTINCT
            a.representative_number,
            a.policy_type,
            a.manual_number,
            a.manual_type,
            a.manual_class_effective_date,
            a.manual_class_rate,
            a.manual_class_payroll,
            a.manual_class_premium,
            b.predecessor_policy_type,
            b.predecessor_policy_number,
            b.successor_policy_type,
            b.successor_policy_number,
            b.transfer_type,
            b.transfer_effective_date,
            b.transfer_creation_date,
            'full_transfer' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
          FROM public.process_payroll_breakdown_by_manual_classes a
          Right Join public.pcomb_detail_records b
          ON a.policy_number = b.predecessor_policy_number
          Where b.transfer_type = 'FC' and a.representative_number = process_representative
          GROUP BY a.representative_number,
            a.policy_type,
            a.manual_number,
            a.manual_type,
            a.manual_class_effective_date,
            a.manual_class_rate,
            a.manual_class_payroll,
            a.manual_class_premium,
            b.predecessor_policy_type,
            b.predecessor_policy_number,
            b.successor_policy_type,
            b.successor_policy_number,
            b.transfer_type,
            b.transfer_effective_date,
            b.transfer_creation_date
        );



        /*********************************************************************/
        -- Remove exceptions from full_transfer table
        -- Create 'Request Payroll Information Table'
        /*********************************************************************/


        INSERT INTO exception_table_policy_combined_request_payroll_infos (
          representative_number,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
         (SELECT DISTINCT
             b.representative_number,
             b.predecessor_policy_type,
             b.predecessor_policy_number,
             b.successor_policy_type,
             b.successor_policy_number,
             b.transfer_type,
             b.transfer_effective_date,
             b.transfer_creation_date,
             'full_transfer' as payroll_origin,
             'bwc' as data_source,
             run_date as created_at,
             run_date as updated_at
           FROM public.process_payroll_breakdown_by_manual_classes a
           Right Join public.pcomb_detail_records b
           ON a.policy_number = b.predecessor_policy_number
           Where b.transfer_type = 'FC' and a.representative_number is null and b.transfer_creation_date >= experience_period_lower_date and predecessor_policy_number not in (SELECT policy_number from bwc_codes_peo_lists)
           GROUP BY
             b.representative_number,
             b.predecessor_policy_type,
             b.predecessor_policy_number,
             b.successor_policy_type,
             b.successor_policy_number,
             b.transfer_type,
             b.transfer_effective_date,
             b.transfer_creation_date,
             payroll_origin
         );


         DELETE FROM public.process_policy_combine_full_transfers
          WHERE representative_number is null;


        -- 3B -- POLICY COMBINE FULL TRANSFER NO LEASES

        -- No labor lease, just partial payroll combinations
        -- Will add the designated payroll amount for the manual class for the designated
        -- payroll period from the predecessor_policy_number to the successor_policy_number.



        -- 05/03/16 Appendment to Logic
        -- If it is a State Fund PEO [will create a custom table to query against for a list of the PEOs], we want to only transfer payroll from [+ transfer] predecessor_policy_number (client) to the (successor_policy_number) State Fund PEO .  We will not do the [- transfer] away from the predecessor_policy_number (client). ALSO mark the policy number as not eligable for group rating.

        -- If it is a Self Insured PEO [policy_type 2] we will not transfer any of the payroll or anything from the policy combined, but we will keep them eligable for group rating.


        INSERT INTO process_policy_combine_partial_transfer_no_leases (
            representative_number,
            valid_policy_number,
            policy_combinations,
            predecessor_policy_type,
            predecessor_policy_number,
            successor_policy_type,
            successor_policy_number,
            transfer_type,
            transfer_effective_date,
            transfer_creation_date,
            partial_transfer_due_to_labor_lease,
            labor_lease_type,
            partial_transfer_payroll_movement,
            ncci_manual_number,
            manual_coverage_type,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            manual_payroll,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
            valid_policy_number,
            policy_combinations,
            predecessor_policy_type,
            predecessor_policy_number,
            successor_policy_type,
            successor_policy_number,
            transfer_type,
            transfer_effective_date,
            transfer_creation_date,
            partial_transfer_due_to_labor_lease,
            labor_lease_type,
            partial_transfer_payroll_movement,
            ncci_manual_number,
            manual_coverage_type,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            manual_payroll,
            'partial_transfer' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
        FROM public.pcomb_detail_records
        WHERE policy_combinations = 'Y' and transfer_type = 'PT' and partial_transfer_due_to_labor_lease = 'N' and representative_number = process_representative
        GROUP BY representative_number,
              valid_policy_number,
              policy_combinations,
              predecessor_policy_type,
              predecessor_policy_number,
              successor_policy_type,
              successor_policy_number,
              transfer_type,
              transfer_effective_date,
              transfer_creation_date,
              partial_transfer_due_to_labor_lease,
              labor_lease_type,
              partial_transfer_payroll_movement,
              ncci_manual_number,
              manual_coverage_type,
              payroll_reporting_period_from_date,
              payroll_reporting_period_to_date,
              manual_payroll
        );

        -- Two different ways to do this, append the policy combination records to the end of the payroll
        -- list or we can "merge" or "upsert" the data policy combination records with the list of payroll
        -- for each manual class for the corresponding policies.


        -- STEP 3C -- POLICY COMBINATION -- PARTIAL TO FULL LEASE
        -- Labor lease, just full and partial payroll combinations
        -- Will add the designated payroll amount for the manual class for the designated
        -- payroll period from the predecessor_policy_number to the successor_policy_number.

        -- Only add the predecessor_policy_number



        INSERT INTO process_policy_combine_partial_to_full_leases (
          representative_number,
          valid_policy_number,
          policy_combinations,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          partial_transfer_due_to_labor_lease,
          labor_lease_type,
          partial_transfer_payroll_movement,
          ncci_manual_number,
          manual_coverage_type,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          manual_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (
        SELECT representative_number,
          valid_policy_number,
          policy_combinations,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          partial_transfer_due_to_labor_lease,
          labor_lease_type,
          partial_transfer_payroll_movement,
          ncci_manual_number,
          manual_coverage_type,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          manual_payroll,
          'partial_to_full_lease' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.pcomb_detail_records
        WHERE partial_transfer_due_to_labor_lease = 'Y' and labor_lease_type != 'LTERM' and representative_number = process_representative
        GROUP BY representative_number,
          valid_policy_number,
          policy_combinations,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          partial_transfer_due_to_labor_lease,
          labor_lease_type,
          partial_transfer_payroll_movement,
          ncci_manual_number,
          manual_coverage_type,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          manual_payroll
        );



        -- Two different ways to do this, append the policy combination records to the end of the payroll
        -- list or we can "merge" or "upsert" the data policy combination records with the list of payroll
        -- for each manual class for the corresponding policies.


        --  UPDATE PEO LIST file from list of PEO Transfers.
        INSERT INTO bwc_codes_peo_lists (
        policy_type,
        policy_number,
        updated_at
        )
        (
        SELECT DISTINCT
           successor_policy_type,
           successor_policy_number,
           run_date as updated_at
        FROM public.process_policy_combine_partial_to_full_leases
        WHERE partial_transfer_due_to_labor_lease = 'Y' and successor_policy_number not in (SELECT policy_number FROM public.bwc_codes_peo_lists)
        );




        -- STEP 3D -- TERMINATE POLICY COMBINATIONS LEASES --
        -- Labor lease TERMINATE payroll combinations
        -- Will add the designated payroll amount for the manual class for the designated
        -- payroll period from the predecessor_policy_number to the successor_policy_number.

        -- Only add the predecessor_policy_number



        INSERT INTO process_policy_combination_lease_terminations (
          representative_number,
          valid_policy_number,
          policy_combinations,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          partial_transfer_due_to_labor_lease,
          labor_lease_type,
          partial_transfer_payroll_movement,
          ncci_manual_number,
          manual_coverage_type,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          manual_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (
          SELECT representative_number,
              valid_policy_number,
              policy_combinations,
              predecessor_policy_type,
              predecessor_policy_number,
              successor_policy_type,
              successor_policy_number,
              transfer_type,
              transfer_effective_date,
              transfer_creation_date,
              partial_transfer_due_to_labor_lease,
              labor_lease_type,
              partial_transfer_payroll_movement,
              ncci_manual_number,
              manual_coverage_type,
              payroll_reporting_period_from_date,
              payroll_reporting_period_to_date,
              manual_payroll,
              'lease_terminated' as payroll_origin,
              'bwc' as data_source,
              run_date as created_at,
              run_date as updated_at
          FROM public.pcomb_detail_records
          WHERE partial_transfer_due_to_labor_lease = 'Y'
            and labor_lease_type = 'LTERM' and representative_number = process_representative
        GROUP BY representative_number,
                valid_policy_number,
                policy_combinations,
                predecessor_policy_type,
                predecessor_policy_number,
                successor_policy_type,
                successor_policy_number,
                transfer_type,
                transfer_effective_date,
                transfer_creation_date,
                partial_transfer_due_to_labor_lease,
                labor_lease_type,
                partial_transfer_payroll_movement,
                ncci_manual_number,
                manual_coverage_type,
                payroll_reporting_period_from_date,
                payroll_reporting_period_to_date,
                manual_payroll
        );




        -- Two different ways to do this, append the policy combination records to the end of the payroll
        -- list or we can "merge" or "upsert" the data policy combination records with the list of payroll
        -- for each manual class for the corresponding policies.

        -- transfering the leased payroll out of PEO and adding it back to the employer


        -- STEP 3E -- CREATE POLICY LEVEL ROLLUPS for payroll and combinations

        -- All payroll transactions for policy Number and Manual class per period

        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT a.representative_number,
         a.policy_type,
         a.policy_number,
         a.manual_type,
         a.manual_number,
         a.manual_class_effective_date,
         a.manual_class_payroll,
         a.payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM public.process_payroll_breakdown_by_manual_classes a
        LEFT JOIN public.final_employer_demographics_informations b
        ON a.policy_number = b.policy_number
        where a.representative_number = process_representative and b.policy_creation_date <= a.manual_class_effective_date
        );



        -- Payroll combination - Full Transfer -- Positive
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
        successor_policy_type as "policy_type",
        successor_policy_number as "policy_number",
        manual_type,
        manual_number,
        manual_class_effective_date,
        manual_class_payroll,
        payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM public.process_policy_combine_full_transfers
        where representative_number = process_representative
        );

        -- Payroll combination - Full Transfer -- Negative
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
        predecessor_policy_type as "policy_type",
        predecessor_policy_number as "policy_number",
        manual_type,
        manual_number,
        manual_class_effective_date,
        (- manual_class_payroll),
        payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM public.process_policy_combine_full_transfers
        where representative_number = process_representative
        );


        -- Payroll combination - Partial Transfer -- No Lease -- Positive
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
        successor_policy_type as "policy_type",
        successor_policy_number as "policy_number",
        manual_coverage_type as manual_type,
        ncci_manual_number as "manual_number",
        payroll_reporting_period_from_date as "manual_class_effective_date",
        manual_payroll as "manual_payroll",
        payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM public.process_policy_combine_partial_transfer_no_leases
        where representative_number = process_representative
        );

        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
        predecessor_policy_type as "policy_type",
        predecessor_policy_number as "policy_number",
        manual_coverage_type as manual_type,
        ncci_manual_number as "manual_number",
        payroll_reporting_period_from_date as "manual_class_effective_date",
        (-manual_payroll) as "manual_payroll",
        payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM public.process_policy_combine_partial_transfer_no_leases
        where representative_number = process_representative
        );


        -- Payroll Combination - Partial to Full Lease -- Positive
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
          successor_policy_type as "policy_type",
          successor_policy_number as "policy_number",
          manual_coverage_type as manual_type,
          ncci_manual_number as "manual_number",
          payroll_reporting_period_from_date as "manual_class_effective_date",
          manual_payroll as "manual_payroll",
          payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.process_policy_combine_partial_to_full_leases
        where representative_number = process_representative
        );


        -- Payroll Combination - Partial to Full Lease -- Negative
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
          predecessor_policy_type as "policy_type",
          predecessor_policy_number as "policy_number",
          manual_coverage_type as manual_type,
          ncci_manual_number as "manual_number",
          payroll_reporting_period_from_date as "manual_class_effective_date",
          (-manual_payroll) as "manual_payroll",
          payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.process_policy_combine_partial_to_full_leases
        WHERE successor_policy_number not in (SELECT policy_number FROM public.bwc_codes_peo_lists)
        and labor_lease_type != 'LFULL' and representative_number = process_representative
        );


        -- Payroll Combinaton - Lease Termination -- Postive
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
          successor_policy_type as "policy_type",
          successor_policy_number as "policy_number",
          manual_coverage_type as manual_type,
          ncci_manual_number as "manual_number",
          payroll_reporting_period_from_date as "manual_class_effective_date",
          manual_payroll as "manual_payroll",
          payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.process_policy_combination_lease_terminations
        WHERE labor_lease_type != 'LFULL' and representative_number = process_representative
        );




        -- Payroll Combinaton - Lease Termination -- Negative
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
        predecessor_policy_type as "policy_type",
        predecessor_policy_number as "policy_number",
        manual_coverage_type as manual_type,
        ncci_manual_number as "manual_number",
        payroll_reporting_period_from_date as "manual_class_effective_date",
        (-manual_payroll) as "manual_payroll",
        payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM public.process_policy_combination_lease_terminations
        where representative_number = process_representative
        );


        -- STEP 3F -- Manual Reclassifications
        -- Creates and inserts records into a table for all Manual Reclassifications






        INSERT INTO process_manual_reclass_tables (
            representative_number,
            policy_type,
            policy_number,
            re_classed_from_manual_number,
            re_classed_to_manual_number,
            reclass_manual_coverage_type,
            reclass_creation_date,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            re_classed_to_manual_payroll_total,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (Select
            representative_number,
            policy_type,
            policy_number,
            re_classed_from_manual_number,
            re_classed_to_manual_number,
            reclass_manual_coverage_type,
            reclass_creation_date,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            re_classed_to_manual_payroll_total,
            'manual_reclass' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
        FROM public.mrcl_detail_records
        WHERE valid_policy_number = 'Y'
            and manual_reclassifications = 'Y'
            and reclass_creation_date is not null
            and reclassed_payroll_information = 'Y'
            and representative_number = process_representative
        );


        -- STEP 3G -- ADDING MANUAL RECLASSIFICIATIONS TO THE PAYROLL table

        -- Insert Manual Reclassification Payroll changes into the payroll_all_transactions_breakdown_by_manual_class table.


        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        --  payroll deducted from the manual class that is being reclassed
        (Select
            representative_number,
            policy_type,
            policy_number as "policy_number",
            reclass_manual_coverage_type as manual_type,
            re_classed_from_manual_number as "manual_number",
            payroll_reporting_period_from_date as "payroll_reporting_period_from_date",
            (-re_classed_to_manual_payroll_total) as "manual_payroll",
            'manual_reclass' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
        FROM public.process_manual_reclass_tables
        where representative_number = process_representative
        );

        -- payroll added to new payroll manual class
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_number,
          manual_type,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (Select
            representative_number,
            policy_type,
            policy_number as "policy_number",
            re_classed_to_manual_number as "manual_number",
            reclass_manual_coverage_type as manual_type,
            payroll_reporting_period_from_date as "payroll_reporting_period_from_date",
            (re_classed_to_manual_payroll_total) as "manual_payroll",
            'manual_reclass' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
        FROM public.process_manual_reclass_tables
        where representative_number = process_representative
        );

        DELETE FROM public.process_payroll_all_transactions_breakdown_by_manual_classes
        WHERE id IN (SELECT id
              FROM (SELECT id,
                             ROW_NUMBER() OVER (partition BY representative_number, policy_type, policy_number, manual_type, manual_number, manual_class_effective_date,
       manual_class_payroll, data_source, created_at,
       updated_at ORDER BY id) AS rnum
                     FROM public.process_payroll_all_transactions_breakdown_by_manual_classes) t
              WHERE t.rnum > 1);
      end;
          $$;


--
-- Name: proc_step_300(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_300(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

        DECLARE
          run_date timestamp := LOCALTIMESTAMP;
        BEGIN


        -- STEP 3A POLICY COMBINE FULL TRANSFER

        INSERT INTO process_policy_combine_full_transfers (
          representative_number,
          policy_type,
          manual_number,
          manual_class_type,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_rate,
          manual_class_payroll,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT DISTINCT
            a.representative_number,
            a.policy_type,
            a.manual_number,
            a.manual_class_type,
            a.reporting_period_start_date,
            a.reporting_period_end_date,
            a.manual_class_rate,
            a.manual_class_payroll,
            b.predecessor_policy_type,
            b.predecessor_policy_number,
            b.successor_policy_type,
            b.successor_policy_number,
            b.transfer_type,
            b.transfer_effective_date,
            b.transfer_creation_date,
            'full_transfer' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
          FROM public.process_payroll_breakdown_by_manual_classes a
          Right Join public.pcomb_detail_records b
          ON a.policy_number = b.predecessor_policy_number
          RIGHT JOIN public.final_employer_demographics_informations c
          ON a.policy_number = c.policy_number
          Where b.transfer_type = 'FC' and a.representative_number = process_representative
          and a.reporting_period_start_date >= c.policy_creation_date
          GROUP BY a.representative_number,
            a.policy_type,
            a.manual_number,
            a.manual_class_type,
            a.reporting_period_start_date,
            a.reporting_period_end_date,
            a.manual_class_rate,
            a.manual_class_payroll,
            b.predecessor_policy_type,
            b.predecessor_policy_number,
            b.successor_policy_type,
            b.successor_policy_number,
            b.transfer_type,
            b.transfer_effective_date,
            b.transfer_creation_date
        );



        /*********************************************************************/
        -- Remove exceptions from full_transfer table
        -- Create 'Request Payroll Information Table'
        /*********************************************************************/


        INSERT INTO exception_table_policy_combined_request_payroll_infos (
          representative_number,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
         (SELECT DISTINCT
             b.representative_number,
             b.predecessor_policy_type,
             b.predecessor_policy_number,
             b.successor_policy_type,
             b.successor_policy_number,
             b.transfer_type,
             b.transfer_effective_date,
             b.transfer_creation_date,
             'full_transfer' as payroll_origin,
             'bwc' as data_source,
             run_date as created_at,
             run_date as updated_at
           FROM public.process_payroll_breakdown_by_manual_classes a
           Right Join public.pcomb_detail_records b
           ON a.policy_number = b.predecessor_policy_number
           Where b.transfer_type = 'FC' and a.representative_number is null and b.transfer_creation_date >= experience_period_lower_date
           GROUP BY
             b.representative_number,
             b.predecessor_policy_type,
             b.predecessor_policy_number,
             b.successor_policy_type,
             b.successor_policy_number,
             b.transfer_type,
             b.transfer_effective_date,
             b.transfer_creation_date,
             payroll_origin
         );


         DELETE FROM public.process_policy_combine_full_transfers
          WHERE representative_number is null;


        -- 3B -- POLICY COMBINE FULL TRANSFER NO LEASES

        -- No labor lease, just partial payroll combinations
        -- Will add the designated payroll amount for the manual class for the designated
        -- payroll period from the predecessor_policy_number to the successor_policy_number.



        -- 05/03/16 Appendment to Logic
        -- If it is a State Fund PEO [will create a custom table to query against for a list of the PEOs], we want to only transfer payroll from [+ transfer] predecessor_policy_number (client) to the (successor_policy_number) State Fund PEO .  We will not do the [- transfer] away from the predecessor_policy_number (client). ALSO mark the policy number as not eligable for group rating.

        -- If it is a Self Insured PEO [policy_type 2] we will not transfer any of the payroll or anything from the policy combined, but we will keep them eligable for group rating.


        INSERT INTO process_policy_combine_partial_transfer_no_leases (
            representative_number,
            valid_policy_number,
            policy_combinations,
            predecessor_policy_type,
            predecessor_policy_number,
            successor_policy_type,
            successor_policy_number,
            transfer_type,
            transfer_effective_date,
            transfer_creation_date,
            partial_transfer_due_to_labor_lease,
            labor_lease_type,
            partial_transfer_payroll_movement,
            ncci_manual_number,
            manual_coverage_type,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            manual_payroll,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
            valid_policy_number,
            policy_combinations,
            predecessor_policy_type,
            predecessor_policy_number,
            successor_policy_type,
            successor_policy_number,
            transfer_type,
            transfer_effective_date,
            transfer_creation_date,
            partial_transfer_due_to_labor_lease,
            labor_lease_type,
            partial_transfer_payroll_movement,
            ncci_manual_number,
            manual_coverage_type,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            manual_payroll,
            'partial_transfer' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
        FROM public.pcomb_detail_records
        WHERE policy_combinations = 'Y' and transfer_type = 'PT' and partial_transfer_due_to_labor_lease = 'N' and representative_number = process_representative
        GROUP BY representative_number,
              valid_policy_number,
              policy_combinations,
              predecessor_policy_type,
              predecessor_policy_number,
              successor_policy_type,
              successor_policy_number,
              transfer_type,
              transfer_effective_date,
              transfer_creation_date,
              partial_transfer_due_to_labor_lease,
              labor_lease_type,
              partial_transfer_payroll_movement,
              ncci_manual_number,
              manual_coverage_type,
              payroll_reporting_period_from_date,
              payroll_reporting_period_to_date,
              manual_payroll
        );

      end;
          $$;


--
-- Name: proc_step_301(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_301(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

              DECLARE
                run_date timestamp := LOCALTIMESTAMP;
              BEGIN


          -- Two different ways to do this, append the policy combination records to the end of the payroll
          -- list or we can "merge" or "upsert" the data policy combination records with the list of payroll
          -- for each manual class for the corresponding policies.


          -- STEP 3C -- POLICY COMBINATION -- PARTIAL TO FULL LEASE
          -- Labor lease, just full and partial payroll combinations
          -- Will add the designated payroll amount for the manual class for the designated
          -- payroll period from the predecessor_policy_number to the successor_policy_number.

          -- Only add the predecessor_policy_number



          INSERT INTO process_policy_combine_partial_to_full_leases (
            representative_number,
            valid_policy_number,
            policy_combinations,
            predecessor_policy_type,
            predecessor_policy_number,
            successor_policy_type,
            successor_policy_number,
            transfer_type,
            transfer_effective_date,
            transfer_creation_date,
            partial_transfer_due_to_labor_lease,
            labor_lease_type,
            partial_transfer_payroll_movement,
            ncci_manual_number,
            manual_coverage_type,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            manual_payroll,
            payroll_origin,
            data_source,
            created_at,
            updated_at
          )
          (
          SELECT representative_number,
            valid_policy_number,
            policy_combinations,
            predecessor_policy_type,
            predecessor_policy_number,
            successor_policy_type,
            successor_policy_number,
            transfer_type,
            transfer_effective_date,
            transfer_creation_date,
            partial_transfer_due_to_labor_lease,
            labor_lease_type,
            partial_transfer_payroll_movement,
            ncci_manual_number,
            manual_coverage_type,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            manual_payroll,
            'partial_to_full_lease' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
          FROM public.pcomb_detail_records
          WHERE partial_transfer_due_to_labor_lease = 'Y' and labor_lease_type != 'LTERM' and representative_number = process_representative
          GROUP BY representative_number,
            valid_policy_number,
            policy_combinations,
            predecessor_policy_type,
            predecessor_policy_number,
            successor_policy_type,
            successor_policy_number,
            transfer_type,
            transfer_effective_date,
            transfer_creation_date,
            partial_transfer_due_to_labor_lease,
            labor_lease_type,
            partial_transfer_payroll_movement,
            ncci_manual_number,
            manual_coverage_type,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            manual_payroll
          );



          -- Two different ways to do this, append the policy combination records to the end of the payroll
          -- list or we can "merge" or "upsert" the data policy combination records with the list of payroll
          -- for each manual class for the corresponding policies.


          --  UPDATE PEO LIST file from list of PEO Transfers.
          INSERT INTO bwc_codes_peo_lists (
          policy_type,
          policy_number,
          updated_at
          )
          (
          SELECT DISTINCT
             successor_policy_type,
             successor_policy_number,
             run_date as updated_at
          FROM public.process_policy_combine_partial_to_full_leases
          WHERE partial_transfer_due_to_labor_lease = 'Y' and successor_policy_number not in (SELECT policy_number FROM public.bwc_codes_peo_lists)
          );




          -- STEP 3D -- TERMINATE POLICY COMBINATIONS LEASES --
          -- Labor lease TERMINATE payroll combinations
          -- Will add the designated payroll amount for the manual class for the designated
          -- payroll period from the predecessor_policy_number to the successor_policy_number.

          -- Only add the predecessor_policy_number



          INSERT INTO process_policy_combination_lease_terminations (
            representative_number,
            valid_policy_number,
            policy_combinations,
            predecessor_policy_type,
            predecessor_policy_number,
            successor_policy_type,
            successor_policy_number,
            transfer_type,
            transfer_effective_date,
            transfer_creation_date,
            partial_transfer_due_to_labor_lease,
            labor_lease_type,
            partial_transfer_payroll_movement,
            ncci_manual_number,
            manual_coverage_type,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            manual_payroll,
            payroll_origin,
            data_source,
            created_at,
            updated_at
          )
          (
            SELECT representative_number,
                valid_policy_number,
                policy_combinations,
                predecessor_policy_type,
                predecessor_policy_number,
                successor_policy_type,
                successor_policy_number,
                transfer_type,
                transfer_effective_date,
                transfer_creation_date,
                partial_transfer_due_to_labor_lease,
                labor_lease_type,
                partial_transfer_payroll_movement,
                ncci_manual_number,
                manual_coverage_type,
                payroll_reporting_period_from_date,
                payroll_reporting_period_to_date,
                manual_payroll,
                'lease_terminated' as payroll_origin,
                'bwc' as data_source,
                run_date as created_at,
                run_date as updated_at
            FROM public.pcomb_detail_records
            WHERE partial_transfer_due_to_labor_lease = 'Y'
              and labor_lease_type = 'LTERM' and representative_number = process_representative
          GROUP BY representative_number,
                  valid_policy_number,
                  policy_combinations,
                  predecessor_policy_type,
                  predecessor_policy_number,
                  successor_policy_type,
                  successor_policy_number,
                  transfer_type,
                  transfer_effective_date,
                  transfer_creation_date,
                  partial_transfer_due_to_labor_lease,
                  labor_lease_type,
                  partial_transfer_payroll_movement,
                  ncci_manual_number,
                  manual_coverage_type,
                  payroll_reporting_period_from_date,
                  payroll_reporting_period_to_date,
                  manual_payroll
          );




          -- Two different ways to do this, append the policy combination records to the end of the payroll
          -- list or we can "merge" or "upsert" the data policy combination records with the list of payroll
          -- for each manual class for the corresponding policies.

          -- transfering the leased payroll out of PEO and adding it back to the employer


          -- STEP 3E -- CREATE POLICY LEVEL ROLLUPS for payroll and combinations

          -- All payroll transactions for policy Number and Manual class per period

          INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            policy_status_effective_date,
            policy_status,
            manual_number,
            manual_class_type,
            manual_class_description,
            bwc_customer_id,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_rate,
            manual_class_payroll,
            reporting_type,
            number_of_employees,
            payroll_origin,
            data_source,
            created_at,
            updated_at

          )
          (SELECT a.representative_number,
            a.policy_type,
            a.policy_number,
            a.policy_status_effective_date,
            a.policy_status,
            a.manual_number,
            a.manual_class_type,
            a.manual_class_description,
            a.bwc_customer_id,
            a.reporting_period_start_date,
            a.reporting_period_end_date,
            a.manual_class_rate,
            a.manual_class_payroll,
            a.reporting_type,
            a.number_of_employees,
            a.payroll_origin,
            a.data_source,
            a.created_at,
            a.updated_at
          FROM public.process_payroll_breakdown_by_manual_classes a
          LEFT JOIN public.final_employer_demographics_informations b
          ON a.policy_number = b.policy_number
          where a.representative_number = process_representative and b.policy_creation_date <= a.reporting_period_start_date
          );



          -- Payroll combination - Full Transfer -- Positive
          INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_class_type,
            manual_number,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_payroll,
            policy_transferred,
            manual_class_transferred,
            transfer_creation_date,
            reporting_type,
            payroll_origin,
            data_source,
            created_at,
            updated_at
          )
          (SELECT representative_number,
          successor_policy_type as "policy_type",
          successor_policy_number as "policy_number",
          manual_class_type,
          manual_number,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_payroll,
          predecessor_policy_number as "policy_transferred",
          manual_number as "manual_class_transferred",
          transfer_creation_date,
          'A' as reporting_type,
          payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
          FROM public.process_policy_combine_full_transfers
          where representative_number = process_representative
          );

          -- Payroll combination - Full Transfer -- Negative
          INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_class_type,
            manual_number,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_payroll,
            reporting_type,
            policy_transferred,
            manual_class_transferred,
            transfer_creation_date,
            payroll_origin,
            data_source,
            created_at,
            updated_at
          )
          (SELECT representative_number,
          predecessor_policy_type as "policy_type",
          predecessor_policy_number as "policy_number",
          manual_class_type,
          manual_number,
          reporting_period_start_date,
          reporting_period_end_date,
          (- manual_class_payroll) as "manual_class_payroll",
          'A' as reporting_type,
          successor_policy_number as "policy_transferred",
          manual_number as "manual_class_transferred",
          transfer_creation_date,
          payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
          FROM public.process_policy_combine_full_transfers
          where representative_number = process_representative
          );


          -- Payroll combination - Partial Transfer -- No Lease -- Positive
          INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_class_type,
            manual_number,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_payroll,
            reporting_type,
            policy_transferred,
            manual_class_transferred,
            transfer_creation_date,
            payroll_origin,
            data_source,
            created_at,
            updated_at
          )
          (SELECT representative_number,
            successor_policy_type as "policy_type",
            successor_policy_number as "policy_number",
            manual_coverage_type as manual_class_type,
            ncci_manual_number as "manual_number",
            payroll_reporting_period_from_date as "reporting_period_start_date",
            payroll_reporting_period_to_date as "reporting_period_end_date",
            manual_payroll,
            'A' as reporting_type,
            predecessor_policy_number as "policy_transferred",
            ncci_manual_number as "manual_class_transferred",
            transfer_creation_date,
            payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
          FROM public.process_policy_combine_partial_transfer_no_leases
          where representative_number = process_representative
          );

          INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_class_type,
            manual_number,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_payroll,
            reporting_type,
            policy_transferred,
            manual_class_transferred,
            transfer_creation_date,
            payroll_origin,
            data_source,
            created_at,
            updated_at
          )
          (SELECT representative_number,
            predecessor_policy_type as "policy_type",
            predecessor_policy_number as "policy_number",
            manual_coverage_type as manual_class_type,
            ncci_manual_number as "manual_number",
            payroll_reporting_period_from_date as "reporting_period_start_date",
            payroll_reporting_period_to_date as "reporting_period_end_date",
            (-manual_payroll) as "manual_payroll",
            'A' as reporting_type,
            successor_policy_number as "policy_transferred",
            ncci_manual_number as "manual_class_transferred",
            transfer_creation_date,
            payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
          FROM public.process_policy_combine_partial_transfer_no_leases
          where representative_number = process_representative
          );


          -- Payroll Combination - Partial to Full Lease -- Positive
          INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
            representative_number,
            policy_type,
            policy_number,
            manual_class_type,
            manual_number,
            reporting_period_start_date,
            reporting_period_end_date,
            manual_class_payroll,
            reporting_type,
            policy_transferred,
            manual_class_transferred,
            transfer_creation_date,
            payroll_origin,
            data_source,
            created_at,
            updated_at
          )
          (SELECT representative_number,
            successor_policy_type as "policy_type",
            successor_policy_number as "policy_number",
            manual_coverage_type as manual_class_type,
            ncci_manual_number as "manual_number",
            payroll_reporting_period_from_date as "reporting_period_start_date",
            payroll_reporting_period_to_date as "reporting_period_end_date",
            manual_payroll as "manual_payroll",
            'A' as reporting_type,
            predecessor_policy_number as "policy_transferred",
            ncci_manual_number as "manual_class_transferred",
            transfer_creation_date,
            payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
          FROM public.process_policy_combine_partial_to_full_leases
          where representative_number = process_representative
          );

        end;
            $$;


--
-- Name: proc_step_302(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_302(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

            DECLARE
              run_date timestamp := LOCALTIMESTAMP;
            BEGIN

        -- Payroll Combination - Partial to Full Lease -- Negative
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_class_type,
          manual_number,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_payroll,
          reporting_type,
          policy_transferred,
          manual_class_transferred,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
          predecessor_policy_type as "policy_type",
          predecessor_policy_number as "policy_number",
          manual_coverage_type as manual_class_type,
          ncci_manual_number as "manual_number",
          payroll_reporting_period_from_date as "reporting_period_start_date",
          payroll_reporting_period_to_date as "reporting_period_end_date",
          (-manual_payroll) as "manual_payroll",
          'A' as reporting_type,
          successor_policy_number as "policy_transferred",
          ncci_manual_number as "manual_class_transferred",
          transfer_creation_date,
          payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.process_policy_combine_partial_to_full_leases
        WHERE successor_policy_number not in (SELECT policy_number FROM public.bwc_codes_peo_lists)
        and labor_lease_type != 'LFULL' and representative_number = process_representative
        );


        -- Payroll Combinaton - Lease Termination -- Postive
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_class_type,
          manual_number,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_payroll,
          reporting_type,
          policy_transferred,
          manual_class_transferred,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
          successor_policy_type as "policy_type",
          successor_policy_number as "policy_number",
          manual_coverage_type as manual_class_type,
          ncci_manual_number as "manual_number",
          payroll_reporting_period_from_date as "reporting_period_start_date",
          payroll_reporting_period_to_date as "reporting_period_end_date",
          manual_payroll as "manual_class_payroll",
          'A' as reporting_type,
          predecessor_policy_number as "policy_transferred",
          ncci_manual_number as "manual_class_transferred",
          transfer_creation_date,
          payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.process_policy_combination_lease_terminations
        WHERE labor_lease_type != 'LFULL' and representative_number = process_representative
        );




        -- Payroll Combinaton - Lease Termination -- Negative
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_class_type,
          manual_number,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_payroll,
          reporting_type,
          policy_transferred,
          manual_class_transferred,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
          predecessor_policy_type as "policy_type",
          predecessor_policy_number as "policy_number",
          manual_coverage_type as manual_class_type,
          ncci_manual_number as "manual_number",
          payroll_reporting_period_from_date as "reporting_period_start_date",
          payroll_reporting_period_to_date as "reporting_period_end_date",
          (-manual_payroll) as "manual_class_payroll",
          'A' as reporting_type,
          successor_policy_number as "policy_transferred",
          ncci_manual_number as "manual_class_transferred",
          transfer_creation_date,
          payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
          FROM public.process_policy_combination_lease_terminations
          where representative_number = process_representative
        );


        -- STEP 3F -- Manual Reclassifications
        -- Creates and inserts records into a table for all Manual Reclassifications






        INSERT INTO process_manual_reclass_tables (
            representative_number,
            policy_type,
            policy_number,
            re_classed_from_manual_number,
            re_classed_to_manual_number,
            reclass_manual_coverage_type,
            reclass_creation_date,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            re_classed_to_manual_payroll_total,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (Select
            representative_number,
            policy_type,
            policy_number,
            re_classed_from_manual_number,
            re_classed_to_manual_number,
            reclass_manual_coverage_type,
            reclass_creation_date,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            re_classed_to_manual_payroll_total,
            'manual_reclass' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
        FROM public.mrcl_detail_records
        WHERE valid_policy_number = 'Y'
            and manual_reclassifications = 'Y'
            and reclass_creation_date is not null
            and reclassed_payroll_information = 'Y'
            and representative_number = process_representative
        );

        INSERT INTO process_manual_reclass_tables (
            representative_number,
            policy_type,
            policy_number,
            re_classed_from_manual_number,
            re_classed_to_manual_number,
            reclass_manual_coverage_type,
            reclass_creation_date,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            re_classed_to_manual_payroll_total,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (Select
            a.representative_number,
            a.policy_type,
            a.policy_number,
            c.manual_class_from as "re_classed_from_manual_number",
            c.manual_class_to as "re_classed_to_manual_number",
            a.manual_class_type,
            to_date((c.policy_year || '-01-01'), 'YYYY-MM-DD') as "reclass_creation_date",
            a.reporting_period_start_date as payroll_reporting_period_from_date,
            a.reporting_period_end_date as payroll_reporting_period_to_date,
            a.manual_class_payroll as "re_classed_to_manual_payroll_total",
            'manual_reclass_auto' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
        FROM public.process_payroll_breakdown_by_manual_classes a
        INNER JOIN public.bwc_annual_manual_class_changes c
        ON a.manual_number = c.manual_class_from
            and a.representative_number = process_representative
        );


        DELETE FROM process_manual_reclass_tables
            WHERE id IN (SELECT id
               FROM (SELECT id, ROW_NUMBER() OVER (partition BY representative_number,
                           policy_number,
                           re_classed_from_manual_number,
                           re_classed_to_manual_number,
                           reclass_manual_coverage_type,
                           payroll_reporting_period_from_date,
                           payroll_reporting_period_to_date,
                           re_classed_to_manual_payroll_total,
                           data_source
                           ORDER BY policy_type ASC) AS rnum
                              FROM process_manual_reclass_tables) t
             WHERE t.rnum > 1);


      end;
          $$;


--
-- Name: proc_step_303(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_303(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

      DECLARE
        run_date timestamp := LOCALTIMESTAMP;
      BEGIN

      -- STEP 3G -- ADDING MANUAL RECLASSIFICIATIONS TO THE PAYROLL table

      -- Insert Manual Reclassification Payroll changes into the payroll_all_transactions_breakdown_by_manual_class table.


      INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
        representative_number,
        policy_type,
        policy_number,
        manual_class_type,
        manual_number,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
        reporting_type,
        policy_transferred,
        manual_class_transferred,
        transfer_creation_date,
        payroll_origin,
        data_source,
        created_at,
        updated_at
      )
      --  payroll deducted from the manual class that is being reclassed
      (Select
          representative_number,
          policy_type,
          policy_number as "policy_number",
          reclass_manual_coverage_type as manual_class_type,
          re_classed_from_manual_number as "manual_number",
          payroll_reporting_period_from_date as "payroll_reporting_period_from_date",
          payroll_reporting_period_to_date as "payroll_reporting_period_to_date",
          (-re_classed_to_manual_payroll_total) as "manual_payroll",
          'A' as reporting_type,
          policy_number as "policy_transferred",
          re_classed_to_manual_number as "manual_class_transferred",
          reclass_creation_date as "transfer_creation_date",
          'manual_reclass' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      FROM public.process_manual_reclass_tables
      where representative_number = process_representative
      );

      -- payroll added to new payroll manual class
      INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
        representative_number,
        policy_type,
        policy_number,
        manual_number,
        manual_class_type,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
        reporting_type,
        policy_transferred,
        manual_class_transferred,
        transfer_creation_date,
        payroll_origin,
        data_source,
        created_at,
        updated_at
      )
      (Select
          representative_number,
          policy_type,
          policy_number as "policy_number",
          re_classed_to_manual_number as "manual_number",
          reclass_manual_coverage_type as manual_class_type,
          payroll_reporting_period_from_date as "payroll_reporting_period_from_date",
          payroll_reporting_period_to_date as "payroll_reporting_period_to_date",
          (re_classed_to_manual_payroll_total) as "manual_payroll",
          'A' as reporting_type,
          policy_number as "policy_transferred",
          re_classed_from_manual_number as "manual_class_transferred",
          reclass_creation_date as "transfer_creation_date",
          'manual_reclass' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      FROM public.process_manual_reclass_tables
      where representative_number = process_representative
      );



      DELETE FROM process_payroll_all_transactions_breakdown_by_manual_classes
          WHERE id IN (SELECT id
             FROM (SELECT id, ROW_NUMBER() OVER (partition BY representative_number,
                            policy_type,
                            policy_number,
                            manual_class_type,
                            manual_number,
                            reporting_period_start_date,
                            reporting_period_end_date,
                            manual_class_rate,
                            manual_class_payroll,
                            reporting_type,
                            policy_transferred,
                            manual_class_transferred,
                            data_source ORDER BY transfer_creation_date DESC) AS rnum
                            FROM process_payroll_all_transactions_breakdown_by_manual_classes) t
           WHERE t.rnum > 1);

    end;
        $$;


--
-- Name: proc_step_3_a(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_3_a(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

        DECLARE
          run_date timestamp := LOCALTIMESTAMP;
        BEGIN


        -- STEP 3A POLICY COMBINE FULL TRANSFER

        INSERT INTO process_policy_combine_full_transfers (
          representative_number,
          policy_type,
          manual_number,
          manual_class_type,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_rate,
          manual_class_payroll,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT DISTINCT
            a.representative_number,
            a.policy_type,
            a.manual_number,
            a.manual_class_type,
            a.reporting_period_start_date,
            a.reporting_period_end_date,
            a.manual_class_rate,
            a.manual_class_payroll,
            b.predecessor_policy_type,
            b.predecessor_policy_number,
            b.successor_policy_type,
            b.successor_policy_number,
            b.transfer_type,
            b.transfer_effective_date,
            b.transfer_creation_date,
            'full_transfer' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
          FROM public.process_payroll_breakdown_by_manual_classes a
          Right Join public.pcomb_detail_records b
          ON a.policy_number = b.predecessor_policy_number
          RIGHT JOIN public.final_employer_demographics_informations c
          ON a.policy_number = c.policy_number
          Where b.transfer_type = 'FC' and a.representative_number = process_representative
          and a.reporting_period_start_date >= c.policy_creation_date
          GROUP BY a.representative_number,
            a.policy_type,
            a.manual_number,
            a.manual_class_type,
            a.reporting_period_start_date,
            a.reporting_period_end_date,
            a.manual_class_rate,
            a.manual_class_payroll,
            b.predecessor_policy_type,
            b.predecessor_policy_number,
            b.successor_policy_type,
            b.successor_policy_number,
            b.transfer_type,
            b.transfer_effective_date,
            b.transfer_creation_date
        );



        /*********************************************************************/
        -- Remove exceptions from full_transfer table
        -- Create 'Request Payroll Information Table'
        /*********************************************************************/


        INSERT INTO exception_table_policy_combined_request_payroll_infos (
          representative_number,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
         (SELECT DISTINCT
             b.representative_number,
             b.predecessor_policy_type,
             b.predecessor_policy_number,
             b.successor_policy_type,
             b.successor_policy_number,
             b.transfer_type,
             b.transfer_effective_date,
             b.transfer_creation_date,
             'full_transfer' as payroll_origin,
             'bwc' as data_source,
             run_date as created_at,
             run_date as updated_at
           FROM public.process_payroll_breakdown_by_manual_classes a
           Right Join public.pcomb_detail_records b
           ON a.policy_number = b.predecessor_policy_number
           Where b.transfer_type = 'FC' and a.representative_number is null and b.transfer_creation_date >= experience_period_lower_date
           GROUP BY
             b.representative_number,
             b.predecessor_policy_type,
             b.predecessor_policy_number,
             b.successor_policy_type,
             b.successor_policy_number,
             b.transfer_type,
             b.transfer_effective_date,
             b.transfer_creation_date,
             payroll_origin
         );


         DELETE FROM public.process_policy_combine_full_transfers
          WHERE representative_number is null;


        -- 3B -- POLICY COMBINE FULL TRANSFER NO LEASES

        -- No labor lease, just partial payroll combinations
        -- Will add the designated payroll amount for the manual class for the designated
        -- payroll period from the predecessor_policy_number to the successor_policy_number.



        -- 05/03/16 Appendment to Logic
        -- If it is a State Fund PEO [will create a custom table to query against for a list of the PEOs], we want to only transfer payroll from [+ transfer] predecessor_policy_number (client) to the (successor_policy_number) State Fund PEO .  We will not do the [- transfer] away from the predecessor_policy_number (client). ALSO mark the policy number as not eligable for group rating.

        -- If it is a Self Insured PEO [policy_type 2] we will not transfer any of the payroll or anything from the policy combined, but we will keep them eligable for group rating.


        INSERT INTO process_policy_combine_partial_transfer_no_leases (
            representative_number,
            valid_policy_number,
            policy_combinations,
            predecessor_policy_type,
            predecessor_policy_number,
            successor_policy_type,
            successor_policy_number,
            transfer_type,
            transfer_effective_date,
            transfer_creation_date,
            partial_transfer_due_to_labor_lease,
            labor_lease_type,
            partial_transfer_payroll_movement,
            ncci_manual_number,
            manual_coverage_type,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            manual_payroll,
            payroll_origin,
            data_source,
            created_at,
            updated_at
        )
        (SELECT representative_number,
            valid_policy_number,
            policy_combinations,
            predecessor_policy_type,
            predecessor_policy_number,
            successor_policy_type,
            successor_policy_number,
            transfer_type,
            transfer_effective_date,
            transfer_creation_date,
            partial_transfer_due_to_labor_lease,
            labor_lease_type,
            partial_transfer_payroll_movement,
            ncci_manual_number,
            manual_coverage_type,
            payroll_reporting_period_from_date,
            payroll_reporting_period_to_date,
            manual_payroll,
            'partial_transfer' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
        FROM public.pcomb_detail_records
        WHERE policy_combinations = 'Y' and transfer_type = 'PT' and partial_transfer_due_to_labor_lease = 'N' and representative_number = process_representative
        GROUP BY representative_number,
              valid_policy_number,
              policy_combinations,
              predecessor_policy_type,
              predecessor_policy_number,
              successor_policy_type,
              successor_policy_number,
              transfer_type,
              transfer_effective_date,
              transfer_creation_date,
              partial_transfer_due_to_labor_lease,
              labor_lease_type,
              partial_transfer_payroll_movement,
              ncci_manual_number,
              manual_coverage_type,
              payroll_reporting_period_from_date,
              payroll_reporting_period_to_date,
              manual_payroll
        );

      end;
          $$;


--
-- Name: proc_step_3_b(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_3_b(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

            DECLARE
              run_date timestamp := LOCALTIMESTAMP;
            BEGIN


        -- Two different ways to do this, append the policy combination records to the end of the payroll
        -- list or we can "merge" or "upsert" the data policy combination records with the list of payroll
        -- for each manual class for the corresponding policies.


        -- STEP 3C -- POLICY COMBINATION -- PARTIAL TO FULL LEASE
        -- Labor lease, just full and partial payroll combinations
        -- Will add the designated payroll amount for the manual class for the designated
        -- payroll period from the predecessor_policy_number to the successor_policy_number.

        -- Only add the predecessor_policy_number



        INSERT INTO process_policy_combine_partial_to_full_leases (
          representative_number,
          valid_policy_number,
          policy_combinations,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          partial_transfer_due_to_labor_lease,
          labor_lease_type,
          partial_transfer_payroll_movement,
          ncci_manual_number,
          manual_coverage_type,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          manual_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (
        SELECT representative_number,
          valid_policy_number,
          policy_combinations,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          partial_transfer_due_to_labor_lease,
          labor_lease_type,
          partial_transfer_payroll_movement,
          ncci_manual_number,
          manual_coverage_type,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          manual_payroll,
          'partial_to_full_lease' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.pcomb_detail_records
        WHERE partial_transfer_due_to_labor_lease = 'Y' and labor_lease_type != 'LTERM' and representative_number = process_representative
        GROUP BY representative_number,
          valid_policy_number,
          policy_combinations,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          partial_transfer_due_to_labor_lease,
          labor_lease_type,
          partial_transfer_payroll_movement,
          ncci_manual_number,
          manual_coverage_type,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          manual_payroll
        );



        -- Two different ways to do this, append the policy combination records to the end of the payroll
        -- list or we can "merge" or "upsert" the data policy combination records with the list of payroll
        -- for each manual class for the corresponding policies.


        --  UPDATE PEO LIST file from list of PEO Transfers.
        INSERT INTO bwc_codes_peo_lists (
        policy_type,
        policy_number,
        updated_at
        )
        (
        SELECT DISTINCT
           successor_policy_type,
           successor_policy_number,
           run_date as updated_at
        FROM public.process_policy_combine_partial_to_full_leases
        WHERE partial_transfer_due_to_labor_lease = 'Y' and successor_policy_number not in (SELECT policy_number FROM public.bwc_codes_peo_lists)
        );




        -- STEP 3D -- TERMINATE POLICY COMBINATIONS LEASES --
        -- Labor lease TERMINATE payroll combinations
        -- Will add the designated payroll amount for the manual class for the designated
        -- payroll period from the predecessor_policy_number to the successor_policy_number.

        -- Only add the predecessor_policy_number



        INSERT INTO process_policy_combination_lease_terminations (
          representative_number,
          valid_policy_number,
          policy_combinations,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          partial_transfer_due_to_labor_lease,
          labor_lease_type,
          partial_transfer_payroll_movement,
          ncci_manual_number,
          manual_coverage_type,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          manual_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (
          SELECT representative_number,
              valid_policy_number,
              policy_combinations,
              predecessor_policy_type,
              predecessor_policy_number,
              successor_policy_type,
              successor_policy_number,
              transfer_type,
              transfer_effective_date,
              transfer_creation_date,
              partial_transfer_due_to_labor_lease,
              labor_lease_type,
              partial_transfer_payroll_movement,
              ncci_manual_number,
              manual_coverage_type,
              payroll_reporting_period_from_date,
              payroll_reporting_period_to_date,
              manual_payroll,
              'lease_terminated' as payroll_origin,
              'bwc' as data_source,
              run_date as created_at,
              run_date as updated_at
          FROM public.pcomb_detail_records
          WHERE partial_transfer_due_to_labor_lease = 'Y'
            and labor_lease_type = 'LTERM' and representative_number = process_representative
        GROUP BY representative_number,
                valid_policy_number,
                policy_combinations,
                predecessor_policy_type,
                predecessor_policy_number,
                successor_policy_type,
                successor_policy_number,
                transfer_type,
                transfer_effective_date,
                transfer_creation_date,
                partial_transfer_due_to_labor_lease,
                labor_lease_type,
                partial_transfer_payroll_movement,
                ncci_manual_number,
                manual_coverage_type,
                payroll_reporting_period_from_date,
                payroll_reporting_period_to_date,
                manual_payroll
        );




        -- Two different ways to do this, append the policy combination records to the end of the payroll
        -- list or we can "merge" or "upsert" the data policy combination records with the list of payroll
        -- for each manual class for the corresponding policies.

        -- transfering the leased payroll out of PEO and adding it back to the employer


        -- STEP 3E -- CREATE POLICY LEVEL ROLLUPS for payroll and combinations

        -- All payroll transactions for policy Number and Manual class per period

        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          policy_status_effective_date,
          policy_status,
          manual_number,
          manual_class_type,
          manual_class_description,
          bwc_customer_id,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_rate,
          manual_class_payroll,
          reporting_type,
          number_of_employees,
          payroll_origin,
          data_source,
          created_at,
          updated_at

        )
        (SELECT a.representative_number,
          a.policy_type,
          a.policy_number,
          a.policy_status_effective_date,
          a.policy_status,
          a.manual_number,
          a.manual_class_type,
          a.manual_class_description,
          a.bwc_customer_id,
          a.reporting_period_start_date,
          a.reporting_period_end_date,
          a.manual_class_rate,
          a.manual_class_payroll,
          a.reporting_type,
          a.number_of_employees,
          a.payroll_origin,
          a.data_source,
          a.created_at,
          a.updated_at
        FROM public.process_payroll_breakdown_by_manual_classes a
        LEFT JOIN public.final_employer_demographics_informations b
        ON a.policy_number = b.policy_number
        where a.representative_number = process_representative and b.policy_creation_date <= a.reporting_period_start_date
        );



        -- Payroll combination - Full Transfer -- Positive
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_class_type,
          manual_number,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_payroll,
          policy_transferred,
          transfer_creation_date,
          reporting_type,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
        successor_policy_type as "policy_type",
        successor_policy_number as "policy_number",
        manual_class_type,
        manual_number,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
        predecessor_policy_number as "policy_transferred",
        transfer_creation_date,
        'A' as reporting_type,
        payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM public.process_policy_combine_full_transfers
        where representative_number = process_representative
        );

        -- Payroll combination - Full Transfer -- Negative
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_class_type,
          manual_number,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_payroll,
          reporting_type,
          policy_transferred,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
        predecessor_policy_type as "policy_type",
        predecessor_policy_number as "policy_number",
        manual_class_type,
        manual_number,
        reporting_period_start_date,
        reporting_period_end_date,
        (- manual_class_payroll) as "manual_class_payroll",
        'A' as reporting_type,
        successor_policy_number as "policy_transferred",
        transfer_creation_date,
        payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM public.process_policy_combine_full_transfers
        where representative_number = process_representative
        );


        -- Payroll combination - Partial Transfer -- No Lease -- Positive
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_class_type,
          manual_number,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_payroll,
          reporting_type,
          policy_transferred,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
          successor_policy_type as "policy_type",
          successor_policy_number as "policy_number",
          manual_coverage_type as manual_class_type,
          ncci_manual_number as "manual_number",
          payroll_reporting_period_from_date as "reporting_period_start_date",
          payroll_reporting_period_to_date as "reporting_period_end_date",
          manual_payroll,
          'A' as reporting_type,
          predecessor_policy_number as "policy_transferred",
          transfer_creation_date,
          payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.process_policy_combine_partial_transfer_no_leases
        where representative_number = process_representative
        );

        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_class_type,
          manual_number,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_payroll,
          reporting_type,
          policy_transferred,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
          predecessor_policy_type as "policy_type",
          predecessor_policy_number as "policy_number",
          manual_coverage_type as manual_class_type,
          ncci_manual_number as "manual_number",
          payroll_reporting_period_from_date as "reporting_period_start_date",
          payroll_reporting_period_to_date as "reporting_period_end_date",
          (-manual_payroll) as "manual_payroll",
          'A' as reporting_type,
          successor_policy_number as "policy_transferred",
          transfer_creation_date,
          payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.process_policy_combine_partial_transfer_no_leases
        where representative_number = process_representative
        );


        -- Payroll Combination - Partial to Full Lease -- Positive
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_class_type,
          manual_number,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_payroll,
          reporting_type,
          policy_transferred,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
          successor_policy_type as "policy_type",
          successor_policy_number as "policy_number",
          manual_coverage_type as manual_class_type,
          ncci_manual_number as "manual_number",
          payroll_reporting_period_from_date as "reporting_period_start_date",
          payroll_reporting_period_to_date as "reporting_period_end_date",
          manual_payroll as "manual_payroll",
          'A' as reporting_type,
          predecessor_policy_number as "policy_transferred",
          transfer_creation_date,
          payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.process_policy_combine_partial_to_full_leases
        where representative_number = process_representative
        );

      end;
          $$;


--
-- Name: proc_step_3_c(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_3_c(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

          DECLARE
            run_date timestamp := LOCALTIMESTAMP;
          BEGIN

      -- Payroll Combination - Partial to Full Lease -- Negative
      INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
        representative_number,
        policy_type,
        policy_number,
        manual_class_type,
        manual_number,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
        reporting_type,
        policy_transferred,
        transfer_creation_date,
        payroll_origin,
        data_source,
        created_at,
        updated_at
      )
      (SELECT representative_number,
        predecessor_policy_type as "policy_type",
        predecessor_policy_number as "policy_number",
        manual_coverage_type as manual_class_type,
        ncci_manual_number as "manual_number",
        payroll_reporting_period_from_date as "reporting_period_start_date",
        payroll_reporting_period_to_date as "reporting_period_end_date",
        (-manual_payroll) as "manual_payroll",
        'A' as reporting_type,
        successor_policy_number as "policy_transferred",
        transfer_creation_date,
        payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
      FROM public.process_policy_combine_partial_to_full_leases
      WHERE successor_policy_number not in (SELECT policy_number FROM public.bwc_codes_peo_lists)
      and labor_lease_type != 'LFULL' and representative_number = process_representative
      );


      -- Payroll Combinaton - Lease Termination -- Postive
      INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
        representative_number,
        policy_type,
        policy_number,
        manual_class_type,
        manual_number,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
        reporting_type,
        policy_transferred,
        transfer_creation_date,
        payroll_origin,
        data_source,
        created_at,
        updated_at
      )
      (SELECT representative_number,
        successor_policy_type as "policy_type",
        successor_policy_number as "policy_number",
        manual_coverage_type as manual_class_type,
        ncci_manual_number as "manual_number",
        payroll_reporting_period_from_date as "reporting_period_start_date",
        payroll_reporting_period_to_date as "reporting_period_end_date",
        manual_payroll as "manual_class_payroll",
        'A' as reporting_type,
        predecessor_policy_number as "policy_transferred",
        transfer_creation_date,
        payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
      FROM public.process_policy_combination_lease_terminations
      WHERE labor_lease_type != 'LFULL' and representative_number = process_representative
      );




      -- Payroll Combinaton - Lease Termination -- Negative
      INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
        representative_number,
        policy_type,
        policy_number,
        manual_class_type,
        manual_number,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
        reporting_type,
        policy_transferred,
        transfer_creation_date,
        payroll_origin,
        data_source,
        created_at,
        updated_at
      )
      (SELECT representative_number,
        predecessor_policy_type as "policy_type",
        predecessor_policy_number as "policy_number",
        manual_coverage_type as manual_class_type,
        ncci_manual_number as "manual_number",
        payroll_reporting_period_from_date as "reporting_period_start_date",
        payroll_reporting_period_to_date as "reporting_period_end_date",
        (-manual_payroll) as "manual_class_payroll",
        'A' as reporting_type,
        successor_policy_number as "policy_transferred",
        transfer_creation_date,
        payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM public.process_policy_combination_lease_terminations
        where representative_number = process_representative
      );


      -- STEP 3F -- Manual Reclassifications
      -- Creates and inserts records into a table for all Manual Reclassifications






      INSERT INTO process_manual_reclass_tables (
          representative_number,
          policy_type,
          policy_number,
          re_classed_from_manual_number,
          re_classed_to_manual_number,
          reclass_manual_coverage_type,
          reclass_creation_date,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          re_classed_to_manual_payroll_total,
          payroll_origin,
          data_source,
          created_at,
          updated_at
      )
      (Select
          representative_number,
          policy_type,
          policy_number,
          re_classed_from_manual_number,
          re_classed_to_manual_number,
          reclass_manual_coverage_type,
          reclass_creation_date,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          re_classed_to_manual_payroll_total,
          'manual_reclass' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      FROM public.mrcl_detail_records
      WHERE valid_policy_number = 'Y'
          and manual_reclassifications = 'Y'
          and reclass_creation_date is not null
          and reclassed_payroll_information = 'Y'
          and representative_number = process_representative
      );


      -- STEP 3G -- ADDING MANUAL RECLASSIFICIATIONS TO THE PAYROLL table

      -- Insert Manual Reclassification Payroll changes into the payroll_all_transactions_breakdown_by_manual_class table.


      INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
        representative_number,
        policy_type,
        policy_number,
        manual_class_type,
        manual_number,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
        reporting_type,
        policy_transferred,
        transfer_creation_date,
        payroll_origin,
        data_source,
        created_at,
        updated_at
      )
      --  payroll deducted from the manual class that is being reclassed
      (Select
          representative_number,
          policy_type,
          policy_number as "policy_number",
          reclass_manual_coverage_type as manual_class_type,
          re_classed_from_manual_number as "manual_number",
          payroll_reporting_period_from_date as "payroll_reporting_period_from_date",
          payroll_reporting_period_to_date as "payroll_reporting_period_to_date",
          (-re_classed_to_manual_payroll_total) as "manual_payroll",
          'A' as reporting_type,
          policy_number as "policy_transferred",
          reclass_creation_date as "transfer_creation_date",
          'manual_reclass' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      FROM public.process_manual_reclass_tables
      where representative_number = process_representative
      );

      -- payroll added to new payroll manual class
      INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
        representative_number,
        policy_type,
        policy_number,
        manual_number,
        manual_class_type,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
        reporting_type,
        policy_transferred,
        transfer_creation_date,
        payroll_origin,
        data_source,
        created_at,
        updated_at
      )
      (Select
          representative_number,
          policy_type,
          policy_number as "policy_number",
          re_classed_to_manual_number as "manual_number",
          reclass_manual_coverage_type as manual_class_type,
          payroll_reporting_period_from_date as "payroll_reporting_period_from_date",
          payroll_reporting_period_to_date as "payroll_reporting_period_to_date",
          (re_classed_to_manual_payroll_total) as "manual_payroll",
          'A' as reporting_type,
          policy_number as "policy_transferred",
          reclass_creation_date as "transfer_creation_date",
          'manual_reclass' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      FROM public.process_manual_reclass_tables
      where representative_number = process_representative
      );

      DELETE FROM process_payroll_all_transactions_breakdown_by_manual_classes
          WHERE id IN (SELECT id
             FROM (SELECT id, ROW_NUMBER() OVER (partition BY representative_number,
                            policy_type,
                            policy_number,
                            manual_class_type,
                            manual_number,
                            reporting_period_start_date,
                            reporting_period_end_date,
                            manual_class_payroll,
                            reporting_type,
                            data_source ORDER BY transfer_creation_date DESC) AS rnum
                            FROM process_payroll_all_transactions_breakdown_by_manual_classes) t
             WHERE t.rnum > 1);


    end;
        $$;


--
-- Name: proc_step_4(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_4(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

        DECLARE
          run_date timestamp := LOCALTIMESTAMP;
        BEGIN
        -- STEP 4 -- Manual Class 4 Year Rollups
        -- Create table that adds up 4 year payroll for each unique policy number and manual class combination,
          -- Calculates expected losses for each manual class by joining bwc_codes_base_rates_exp_loss_rates table
          -- Adds industry_group to manual class by joining bwc_codes_ncci_manual_classes

        INSERT INTO final_manual_class_four_year_payroll_and_exp_losses
          (
            representative_number,
            policy_number,
            manual_number,
            manual_class_type,
            data_source,
            created_at,
            updated_at
          )
          (
            SELECT
            a.representative_number,
            a.policy_number,
            b.manual_number,
            b.manual_class_type,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
          FROM public.final_employer_demographics_informations a
          Inner Join public.process_payroll_all_transactions_breakdown_by_manual_classes b
          ON a.policy_number = b.policy_number
          WHERE b.reporting_period_start_date >= experience_period_lower_date and a.representative_number = process_representative
          GROUP BY a.representative_number,
            a.policy_number,
            b.manual_number,
            b.manual_class_type
          );



          -- Broke manual_class payroll calculations into two tables.
          -- One  to calculate payroll and manual_reclass payroll when  a.reporting_period_start_date > edi.policy_creation_date because a payroll is only counted in your experience when you have a policy_created.

          -- One to calculate the payroll of transferred payroll from another policy.  This does not require a policy to be  created.


          INSERT INTO process_manual_class_four_year_payroll_with_conditions
          (
            representative_number,
            policy_number,
            manual_number,
            manual_class_type,
            manual_class_four_year_period_payroll,
            data_source,
            created_at,
            updated_at
          )
          (
            SELECT
              a.representative_number,
              a.policy_number,
              a.manual_number,
              a.manual_class_type,
              SUM(a.manual_class_payroll) as manual_class_four_year_period_payroll,
              'bwc' as data_source,
              run_date as created_at,
              run_date as updated_at
            FROM public.process_payroll_all_transactions_breakdown_by_manual_classes a
            Left Join public.final_employer_demographics_informations edi
            ON a.policy_number = edi.policy_number
            WHERE (a.reporting_period_start_date BETWEEN experience_period_lower_date and experience_period_upper_date)
            and a.representative_number = process_representative -- date range for experience_period
              and (a.payroll_origin = 'payroll' or a.payroll_origin = 'manual_reclass' or a.payroll_origin = 'payroll_adjustment') and (a.reporting_period_start_date >= edi.policy_creation_date )
            GROUP BY a.representative_number, a.policy_number, a.manual_number, a.manual_class_type
          );

            INSERT INTO process_manual_class_four_year_payroll_without_conditions
            (
              representative_number,
              policy_number,
              manual_number,
              manual_class_type,
              manual_class_four_year_period_payroll,
              data_source,
              created_at,
              updated_at
            )
            (
            SELECT
              a.representative_number,
              a.policy_number,
              a.manual_number,
              a.manual_class_type,
              SUM(a.manual_class_payroll) as manual_class_four_year_period_payroll,
              'bwc' as data_source,
              run_date as created_at,
              run_date as updated_at
            FROM public.process_payroll_all_transactions_breakdown_by_manual_classes a
            Left Join public.final_employer_demographics_informations edi
            ON a.policy_number = edi.policy_number
            WHERE (a.reporting_period_start_date BETWEEN experience_period_lower_date and experience_period_upper_date)
            and a.representative_number = process_representative -- date range for experience_period
              and (a.payroll_origin != 'payroll' and a.payroll_origin != 'manual_reclass' and a.payroll_origin != 'payroll_adjustment')
            GROUP BY a.representative_number, a.policy_number, a.manual_number, a.manual_class_type
            );





        -- Calculate manual_class_payroll

         UPDATE public.final_manual_class_four_year_payroll_and_exp_losses a SET (manual_class_four_year_period_payroll, updated_at) = (t2.manual_class_four_year_period_payroll, t2.updated_at)
         FROM
         (SELECT a.representative_number, a.policy_number, a.manual_number, a.manual_class_type,
        ROUND(((Case when wo.manual_class_four_year_period_payroll is null then '0'::decimal ELSE
        wo.manual_class_four_year_period_payroll END)
        + (Case when w.manual_class_four_year_period_payroll is null then '0'::decimal ELSE
        w.manual_class_four_year_period_payroll END))::numeric,2) as manual_class_four_year_period_payroll,
        run_date as updated_at
        FROM public.final_manual_class_four_year_payroll_and_exp_losses a
        Left join public.process_manual_class_four_year_payroll_without_conditions wo
        ON a.policy_number = wo.policy_number and a.manual_number = wo.manual_number and a.manual_class_type = wo.manual_class_type
        Left join public.process_manual_class_four_year_payroll_with_conditions w
        ON a.policy_number = w.policy_number and a.manual_number = w.manual_number and a.manual_class_type = w.manual_class_type
         ) t2
         WHERE a.policy_number = t2.policy_number and a.manual_number = t2.manual_number and a.manual_class_type = t2.manual_class_type and a.representative_number = t2.representative_number and a.representative_number = process_representative;









         UPDATE public.final_manual_class_four_year_payroll_and_exp_losses a SET (manual_class_expected_loss_rate, manual_class_base_rate, manual_class_expected_losses, manual_class_industry_group, updated_at) = (t2.manual_class_expected_loss_rate, t2.manual_class_base_rate, t2.manual_class_expected_losses, t2.manual_class_industry_group, t2.updated_at)
         FROM
         (  SELECT
             a.representative_number,
             a.policy_number,
             a.manual_number,
             a.manual_class_type,
             b.expected_loss_rate as manual_class_expected_loss_rate,
             b.base_rate as manual_class_base_rate,
             ROUND((a.manual_class_four_year_period_payroll * b.expected_loss_rate)::numeric, 4)
             as "manual_class_expected_losses",
             c.industry_group as "manual_class_industry_group",
             run_date as updated_at
           FROM public.final_manual_class_four_year_payroll_and_exp_losses a
           LEFT JOIN public.bwc_codes_base_rates_exp_loss_rates b
           ON a.manual_number = b.class_code
           LEFT JOIN public.bwc_codes_ncci_manual_classes c
           ON a.manual_number = c.ncci_manual_classification
           Left Join public.final_employer_demographics_informations edi
           ON a.policy_number = edi.policy_number
           ) t2
         WHERE a.policy_number = t2.policy_number and a.manual_number = t2.manual_number and a.manual_class_type = t2.manual_class_type and a.representative_number = t2.representative_number and (a.representative_number is not null) and a.representative_number = process_representative;




        -- 7/5/2016 __ CREATED NEW PEO TABLE called process_policy_experience_period_peo.
        -- This will calculate which policies were involved with a state fund or self insurred peo.
        -- It finds the most recent date of the effective_date for si peo or sf peo and documents it
        -- Then it finds the most recent termintation date for si peo or sf peo and documents it.
        -- If a policy is involved with a peo within the experience period, you will eventually reject that policy from getting quoted for group rating.


        -- Insert all policy_numbers and manual_numbers that are associated with a PEO LEASE
        INSERT INTO public.process_policy_experience_period_peos (
          representative_number,
          policy_type,
          policy_number,
          data_source,
          created_at,
          updated_at
        )
        (
          SELECT DISTINCT
               representative_number,
               predecessor_policy_type as policy_type,
               predecessor_policy_number as policy_number,
               'bwc' as data_source,
               run_date as created_at,
               run_date as updated_at
          FROM public.process_policy_combine_partial_to_full_leases
          where representative_number = process_representative
        );



        -- Self Insured  PEO LEASE INTO

         UPDATE public.process_policy_experience_period_peos mce SET
         (manual_class_si_peo_lease_effective_date, updated_at) = (t2.manual_class_si_peo_lease_effective_date, t2.updated_at)
         FROM
         (SELECT pcl.representative_number,
          pcl.predecessor_policy_number as policy_number,
          max(pcl.transfer_effective_date) as manual_class_si_peo_lease_effective_date,
          run_date as updated_at
         FROM public.process_policy_combine_partial_to_full_leases pcl
         -- Self Insured PEO
         WHERE pcl.successor_policy_type = 'private_self_insured' and pcl.successor_policy_number in (SELECT peo.policy_number FROM bwc_codes_peo_lists peo) and pcl.representative_number = process_representative
         GROUP BY pcl.representative_number,
          pcl.predecessor_policy_number
        ) t2
          WHERE mce.policy_number = t2.policy_number and mce.representative_number = t2.representative_number and (mce.representative_number is not null);

        --
        -- -- Self Insured PEO LEASE OUT
        --
        UPDATE public.process_policy_experience_period_peos mce SET
        (manual_class_si_peo_lease_termination_date, updated_at) = (t2.manual_class_si_peo_lease_termination_date, t2.updated_at)
        FROM
        ( SELECT pct.representative_number,
         pct.successor_policy_number as policy_number,
         max(pct.transfer_effective_date) as manual_class_si_peo_lease_termination_date,
         run_date as updated_at
        FROM public.process_policy_combination_lease_terminations pct
        WHERE pct.predecessor_policy_number in (SELECT peo.policy_number FROM bwc_codes_peo_lists peo) and pct.predecessor_policy_type = 'private_self_insured' and pct.representative_number = process_representative
        GROUP BY pct.representative_number,
         pct.successor_policy_number
        ) t2
        WHERE mce.policy_number = t2.policy_number and mce.representative_number = t2.representative_number and (mce.representative_number is not null);
        --
        -- -- State Fund PEO LEASE INTO
        --

     UPDATE public.process_policy_experience_period_peos mce SET
     (manual_class_sf_peo_lease_effective_date, updated_at) = (t2.manual_class_sf_peo_lease_effective_date, t2.updated_at)
     FROM
     (SELECT pcl.representative_number,
      pcl.predecessor_policy_number as policy_number,
      max(pcl.transfer_effective_date) as manual_class_sf_peo_lease_effective_date,
      run_date as updated_at
     FROM public.process_policy_combine_partial_to_full_leases pcl
     -- Self Insured PEO
     WHERE pcl.successor_policy_type != 'private_self_insured' and pcl.successor_policy_number in (SELECT peo.policy_number FROM bwc_codes_peo_lists peo) and pcl.representative_number = process_representative
     GROUP BY pcl.representative_number,
      pcl.predecessor_policy_number
    ) t2
      WHERE mce.policy_number = t2.policy_number and mce.representative_number = t2.representative_number and (mce.representative_number is not null);

    --
    -- -- Self Insured PEO LEASE OUT
    --
    UPDATE public.process_policy_experience_period_peos mce SET
    (manual_class_sf_peo_lease_termination_date, updated_at) = (t2.manual_class_sf_peo_lease_termination_date, t2.updated_at)
    FROM
    ( SELECT pct.representative_number,
     pct.successor_policy_number as policy_number,
     max(pct.transfer_effective_date) as manual_class_sf_peo_lease_termination_date,
     run_date as updated_at
    FROM public.process_policy_combination_lease_terminations pct
    WHERE pct.predecessor_policy_number in (SELECT peo.policy_number FROM bwc_codes_peo_lists peo) and pct.predecessor_policy_type != 'private_self_insured'and pct.representative_number = process_representative
    GROUP BY pct.representative_number,
     pct.successor_policy_number
    ) t2
    WHERE mce.policy_number = t2.policy_number and mce.representative_number = t2.representative_number and (mce.representative_number is not null);


    end;

      $$;


--
-- Name: proc_step_400(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_400(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

        DECLARE
          run_date timestamp := LOCALTIMESTAMP;
        BEGIN
        -- STEP 4 -- Manual Class 4 Year Rollups
        -- Create table that adds up 4 year payroll for each unique policy number and manual class combination,
          -- Calculates expected losses for each manual class by joining bwc_codes_base_rates_exp_loss_rates table
          -- Adds industry_group to manual class by joining bwc_codes_ncci_manual_classes

        INSERT INTO final_manual_class_four_year_payroll_and_exp_losses
          (
            representative_number,
            policy_number,
            manual_number,
            manual_class_type,
            data_source,
            created_at,
            updated_at
          )
          (
            SELECT
            a.representative_number,
            a.policy_number,
            b.manual_number,
            b.manual_class_type,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
          FROM public.final_employer_demographics_informations a
          Inner Join public.process_payroll_all_transactions_breakdown_by_manual_classes b
          ON a.policy_number = b.policy_number
          WHERE b.reporting_period_start_date >= experience_period_lower_date and a.representative_number = process_representative
          GROUP BY a.representative_number,
            a.policy_number,
            b.manual_number,
            b.manual_class_type
          );



          -- Broke manual_class payroll calculations into two tables.
          -- One  to calculate payroll and manual_reclass payroll when  a.reporting_period_start_date > edi.policy_creation_date because a payroll is only counted in your experience when you have a policy_created.

          -- One to calculate the payroll of transferred payroll from another policy.  This does not require a policy to be  created.


         UPDATE public.final_manual_class_four_year_payroll_and_exp_losses a SET (manual_class_expected_loss_rate, manual_class_base_rate, manual_class_industry_group, updated_at) = (t2.manual_class_expected_loss_rate, t2.manual_class_base_rate, t2.manual_class_industry_group, t2.updated_at)
         FROM
         (  SELECT
             a.representative_number,
             a.policy_number,
             a.manual_number,
             a.manual_class_type,
             b.expected_loss_rate as manual_class_expected_loss_rate,
             b.base_rate as manual_class_base_rate,
             c.industry_group as "manual_class_industry_group",
             run_date as updated_at
           FROM public.final_manual_class_four_year_payroll_and_exp_losses a
           LEFT JOIN public.bwc_codes_base_rates_exp_loss_rates b
           ON a.manual_number = b.class_code
           LEFT JOIN public.bwc_codes_ncci_manual_classes c
           ON a.manual_number = c.ncci_manual_classification
           Left Join public.final_employer_demographics_informations edi
           ON a.policy_number = edi.policy_number
           ) t2
         WHERE a.policy_number = t2.policy_number and a.manual_number = t2.manual_number and a.manual_class_type = t2.manual_class_type and a.representative_number = t2.representative_number and (a.representative_number is not null) and a.representative_number = process_representative;




        -- 7/5/2016 __ CREATED NEW PEO TABLE called process_policy_experience_period_peo.
        -- This will calculate which policies were involved with a state fund or self insurred peo.
        -- It finds the most recent date of the effective_date for si peo or sf peo and documents it
        -- Then it finds the most recent termintation date for si peo or sf peo and documents it.
        -- If a policy is involved with a peo within the experience period, you will eventually reject that policy from getting quoted for group rating.


        -- Insert all policy_numbers and manual_numbers that are associated with a PEO LEASE
        INSERT INTO public.process_policy_experience_period_peos (
          representative_number,
          policy_type,
          policy_number,
          data_source,
          created_at,
          updated_at
        )
        (
          SELECT DISTINCT
               representative_number,
               predecessor_policy_type as policy_type,
               predecessor_policy_number as policy_number,
               'bwc' as data_source,
               run_date as created_at,
               run_date as updated_at
          FROM public.process_policy_combine_partial_to_full_leases
          where representative_number = process_representative
        );



        -- Self Insured  PEO LEASE INTO

         UPDATE public.process_policy_experience_period_peos mce SET
         (manual_class_si_peo_lease_effective_date, updated_at) = (t2.manual_class_si_peo_lease_effective_date, t2.updated_at)
         FROM
         (SELECT pcl.representative_number,
          pcl.predecessor_policy_number as policy_number,
          max(pcl.transfer_effective_date) as manual_class_si_peo_lease_effective_date,
          run_date as updated_at
         FROM public.process_policy_combine_partial_to_full_leases pcl
         -- Self Insured PEO
         WHERE pcl.successor_policy_type = 'private_self_insured' and pcl.successor_policy_number in (SELECT peo.policy_number FROM bwc_codes_peo_lists peo) and pcl.representative_number = process_representative
         GROUP BY pcl.representative_number,
          pcl.predecessor_policy_number
        ) t2
          WHERE mce.policy_number = t2.policy_number and mce.representative_number = t2.representative_number and (mce.representative_number is not null);

        --
        -- -- Self Insured PEO LEASE OUT
        --
        UPDATE public.process_policy_experience_period_peos mce SET
        (manual_class_si_peo_lease_termination_date, updated_at) = (t2.manual_class_si_peo_lease_termination_date, t2.updated_at)
        FROM
        ( SELECT pct.representative_number,
         pct.successor_policy_number as policy_number,
         max(pct.transfer_effective_date) as manual_class_si_peo_lease_termination_date,
         run_date as updated_at
        FROM public.process_policy_combination_lease_terminations pct
        WHERE pct.predecessor_policy_number in (SELECT peo.policy_number FROM bwc_codes_peo_lists peo) and pct.predecessor_policy_type = 'private_self_insured' and pct.representative_number = process_representative
        GROUP BY pct.representative_number,
         pct.successor_policy_number
        ) t2
        WHERE mce.policy_number = t2.policy_number and mce.representative_number = t2.representative_number and (mce.representative_number is not null);
        --
        -- -- State Fund PEO LEASE INTO
        --

     UPDATE public.process_policy_experience_period_peos mce SET
     (manual_class_sf_peo_lease_effective_date, updated_at) = (t2.manual_class_sf_peo_lease_effective_date, t2.updated_at)
     FROM
     (SELECT pcl.representative_number,
      pcl.predecessor_policy_number as policy_number,
      max(pcl.transfer_effective_date) as manual_class_sf_peo_lease_effective_date,
      run_date as updated_at
     FROM public.process_policy_combine_partial_to_full_leases pcl
     -- Self Insured PEO
     WHERE pcl.successor_policy_type != 'private_self_insured' and pcl.successor_policy_number in (SELECT peo.policy_number FROM bwc_codes_peo_lists peo) and pcl.representative_number = process_representative
     GROUP BY pcl.representative_number,
      pcl.predecessor_policy_number
    ) t2
      WHERE mce.policy_number = t2.policy_number and mce.representative_number = t2.representative_number and (mce.representative_number is not null);

    --
    -- -- Self Insured PEO LEASE OUT
    --
    UPDATE public.process_policy_experience_period_peos mce SET
    (manual_class_sf_peo_lease_termination_date, updated_at) = (t2.manual_class_sf_peo_lease_termination_date, t2.updated_at)
    FROM
    ( SELECT pct.representative_number,
     pct.successor_policy_number as policy_number,
     max(pct.transfer_effective_date) as manual_class_sf_peo_lease_termination_date,
     run_date as updated_at
    FROM public.process_policy_combination_lease_terminations pct
    WHERE pct.predecessor_policy_number in (SELECT peo.policy_number FROM bwc_codes_peo_lists peo) and pct.predecessor_policy_type != 'private_self_insured'and pct.representative_number = process_representative
    GROUP BY pct.representative_number,
     pct.successor_policy_number
    ) t2
    WHERE mce.policy_number = t2.policy_number and mce.representative_number = t2.representative_number and (mce.representative_number is not null);


    DELETE FROM process_policy_experience_period_peos
        WHERE id IN (SELECT id
           FROM (SELECT id, ROW_NUMBER() OVER (partition BY representative_number,
                          policy_type,
                          policy_number,
                          manual_class_sf_peo_lease_effective_date,
		          manual_class_sf_peo_lease_termination_date,
		          manual_class_si_peo_lease_effective_date,
		          manual_class_si_peo_lease_termination_date)
                          AS rnum
                          FROM process_policy_experience_period_peos) t
         WHERE t.rnum > 1);

    end;

      $$;


--
-- Name: proc_step_5(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_5(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

      DECLARE
        run_date timestamp := LOCALTIMESTAMP;
      BEGIN


      -- STEP 5A -- POLICY EXPERIENCE ROLLUPS

      -- INSERT THEN UPDATE STATEMENTS TO CREATE MORE SPEED.
      INSERT INTO public.final_policy_experience_calculations
      (
      representative_number,
      policy_number,
      valid_policy_number,
      data_source,
      created_at,
      updated_at
      )
      (SELECT DISTINCT representative_number,
             policy_number,
             valid_policy_number,
             'bwc' as data_source,
             run_date as created_at,
             run_date as updated_at
       FROM final_employer_demographics_informations
       where representative_number = process_representative
       );


      --  UPDATE policy_group_number

      UPDATE public.final_policy_experience_calculations pec SET (policy_group_number, updated_at) =
      (t2.policy_group_number, t2.updated_at)
      FROM
      (
       SELECT a.policy_number, a.group_code as policy_group_number,
       run_date as updated_at
       FROM final_employer_demographics_informations a
       where a.representative_number = process_representative
      ) t2
      WHERE pec.policy_number = t2.policy_number;


      -- UPDATE policy_role_ups
      UPDATE public.final_policy_experience_calculations pec SET (policy_total_four_year_payroll, policy_total_expected_losses, updated_at) = (t2.policy_four_year_payroll, t2.policy_total_expected_losses, t2.updated_at)
      FROM
      (SELECT policy_number,
       round(sum(manual_class_four_year_period_payroll)::numeric,2) as policy_four_year_payroll,
       round(sum(manual_class_expected_losses)::numeric,2) as policy_total_expected_losses,
       run_date as created_at,
       run_date as updated_at
       FROM public.final_manual_class_four_year_payroll_and_exp_losses
       WHERE representative_number = process_representative
       GROUP BY policy_number
      ) t2
      WHERE pec.policy_number = t2.policy_number;


      -- UPDATE industry_group




      ----------------------------
      -- Update policy_status

      UPDATE public.final_policy_experience_calculations a SET (policy_status, updated_at) = (t2.current_coverage_status, t2.updated_at)
      FROM
      (SELECT p.policy_number, p.current_coverage_status,
      run_date as updated_at
        FROM public.final_employer_demographics_informations p
        where p.representative_number = process_representative
      ) t2
      WHERE a.policy_number = t2.policy_number;

      ----------
      -- UPDATE policy_level credibilty_group

       UPDATE public.final_policy_experience_calculations a SET (policy_credibility_group, updated_at) = (t2.credibility_group, t2.updated_at)
      FROM
       (SELECT p.policy_number,
             (SELECT case when (min(bwc.credibility_group) - 1) is null THEN '22'
                    ELSE (min(bwc.credibility_group) - 1)
                       END
             as credibility_group
               FROM public.bwc_codes_credibility_max_losses bwc
                 WHERE (p.policy_total_expected_losses / expected_losses ) <= 1),
                 run_date as updated_at
         FROM public.final_policy_experience_calculations p
         WHERE p.representative_number = process_representative
        ) t2
        WHERE a.policy_number = t2.policy_number;


      --- Update Credibilty policy_credibility_percent and maximum_claim_value

      UPDATE public.final_policy_experience_calculations a SET (policy_credibility_percent, policy_maximum_claim_value, updated_at) = (t2.policy_credibility_percent, t2.policy_maximum_claim_value, t2.updated_at)
      FROM
      (
        SELECT
        p.policy_number,
       case when bwc.credibility_percent is null THEN '0.00'
       ELSE bwc.credibility_percent
       end as policy_credibility_percent,
        case when bwc.group_maximum_value is null THEN '250000'
       ELSE bwc.group_maximum_value
     end as policy_maximum_claim_value,
      run_date as updated_at

        from public.bwc_codes_credibility_max_losses bwc
        right Join public.final_policy_experience_calculations p
        ON bwc.credibility_group = p.policy_credibility_group
        WHERE p.representative_number = process_representative
      ) t2
      WHERE a.policy_number = t2.policy_number
      ;
      -- Update limited_loss_rate On Manual_class_level

      UPDATE public.final_manual_class_four_year_payroll_and_exp_losses a SET (manual_class_limited_loss_rate, updated_at) =
      (t2.limited_loss_rate, t2.updated_at)
      FROM

      (SELECT
        p.policy_number as policy_number,
        mc.manual_number as manual_number,
        bwc.limited_loss_ratio as limited_loss_rate,
        run_date as updated_at
      FROM public.final_policy_experience_calculations p
      RIGHT JOIN final_manual_class_four_year_payroll_and_exp_losses mc
      on p.policy_number = mc.policy_number
      RIGHT JOIN bwc_codes_limited_loss_ratios bwc
      ON  p.policy_credibility_group = bwc.credibility_group
       and mc.manual_class_industry_group = bwc.industry_group
      WHERE p.representative_number = process_representative
      ) t2
      WHERE t2.policy_number = a.policy_number and a.manual_number = t2.manual_number;





       -- Update Manual Class LImited Losses on the Manual Classes

      UPDATE public.final_manual_class_four_year_payroll_and_exp_losses a SET (manual_class_limited_losses, updated_at) =
      (t2.manual_class_limited_losses, t2.updated_at)
      FROM
      (
        SELECT
          b.policy_number as policy_number,
          b.manual_number as manual_number,
          round((manual_class_expected_losses * manual_class_limited_loss_rate)::numeric,2) as manual_class_limited_losses,
          run_date as updated_at
        FROM public.final_manual_class_four_year_payroll_and_exp_losses b
        WHERE b.representative_number = process_representative
      ) t2
      WHERE a.policy_number = t2.policy_number and a.manual_number = t2.manual_number;






      UPDATE public.final_policy_experience_calculations a SET (policy_total_limited_losses,updated_at) =
      (t2.policy_total_limited_losses, t2.updated_at)
      FROM
      (
        SELECT
        b.policy_number as policy_number,
        round(SUM(b.manual_class_limited_losses)::numeric,2) as policy_total_limited_losses,
        run_date as updated_at
        FROM public.final_manual_class_four_year_payroll_and_exp_losses b
        where b.representative_number = process_representative
        GROUP BY policy_number
      ) t2
      Where t2.policy_number = a.policy_number;



      end;

        $$;


--
-- Name: proc_step_500(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_500(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

          DECLARE
            run_date timestamp := LOCALTIMESTAMP;
          BEGIN

          -- STEP 6 -- CREATE CLAIMS TABLE

          INSERT INTO final_claim_cost_calculation_tables
            (
            representative_number,
            policy_type,
            policy_number,
            claim_number,
            claim_injury_date,
            claim_handicap_percent,
            claim_handicap_percent_effective_date,
            claim_manual_number,
            claimant_name,
            claimant_date_of_birth,
            claimant_date_of_death,
            claim_medical_paid,
            claim_mira_medical_reserve_amount,
            claim_mira_non_reducible_indemnity_paid,
            claim_mira_reducible_indemnity_paid,
            claim_mira_indemnity_reserve_amount,
            claim_mira_non_reducible_indemnity_paid_2,
            claim_total_subrogation_collected,
            claim_unlimited_limited_loss,
            data_source,
            created_at,
            updated_at,
            claim_combined,
            combined_into_claim_number,
            claim_rating_plan_indicator,
            claim_status,
            claim_status_effective_date,
            claim_type,
            claim_activity_status,
            claim_activity_status_effective_date,
            settled_claim,
            settlement_type,
            medical_settlement_date,
            indemnity_settlement_date,
            maximum_medical_improvement_date,
            claim_mira_ncci_injury_type

            )
            (SELECT
              a.representative_number,
              a.policy_type,
              a.policy_number,
              a.claim_number,
              a.claim_injury_date,
              round(a.claim_handicap_percent::numeric/100,2),
              a.claim_handicap_percent_effective_date,
              a.claim_manual_number,
              a.claimant_name,
              a.claimant_date_of_birth,
              a.claimant_date_of_death,
              a.claim_medical_paid,
              a.claim_mira_medical_reserve_amount,
              a.claim_mira_non_reducible_indemnity_paid,
              a.claim_mira_reducible_indemnity_paid,
              a.claim_mira_indemnity_reserve_amount,
              a.claim_mira_non_reducible_indemnity_paid_2,
              a.claim_total_subrogation_collected,
              (a.claim_medical_paid +
                a.claim_mira_medical_reserve_amount +
                a.claim_mira_non_reducible_indemnity_paid +
                a.claim_mira_reducible_indemnity_paid +
                a.claim_mira_indemnity_reserve_amount +
                a.claim_mira_non_reducible_indemnity_paid_2
              ) as "claim_unlimited_limited_loss",
              'bwc' as data_source,
              run_date as created_at,
              run_date as updated_at,
              a.claim_combined,
              a.combined_into_claim_number,
              a.claim_rating_plan_indicator,
              a.claim_status,
              a.claim_status_effective_date,
              a.claim_type,
              a.claim_activity_status,
              a.claim_activity_status_effective_date,
              a.settled_claim,
              a.settlement_type,
              a.medical_settlement_date,
              a.indemnity_settlement_date,
              a.maximum_medical_improvement_date,
              a.claim_mira_ncci_injury_type
              FROM public.democ_detail_records a
              WHERE a.representative_number = process_representative
              ORDER BY claim_unlimited_limited_loss desc
              );



          -- STEP 6B -- CALCULATION OF CLAIMS COSTS

          end;

            $$;


--
-- Name: proc_step_6(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_6(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

      DECLARE
        run_date timestamp := LOCALTIMESTAMP;
      BEGIN

      -- STEP 6 -- CREATE CLAIMS TABLE and Calculations

      INSERT INTO final_claim_cost_calculation_tables
        (
        representative_number,
        policy_type,
        policy_number,
        claim_number,
        claim_injury_date,
        claim_handicap_percent,
        claim_handicap_percent_effective_date,
        claim_manual_number,
        claimant_name,
        claimant_date_of_birth,
        claimant_date_of_death,
        claim_medical_paid,
        claim_mira_medical_reserve_amount,
        claim_mira_non_reducible_indemnity_paid,
        claim_mira_reducible_indemnity_paid,
        claim_mira_indemnity_reserve_amount,
        claim_mira_non_reducible_indemnity_paid_2,
        claim_total_subrogation_collected,
        claim_unlimited_limited_loss,
        policy_individual_maximum_claim_value,
        --claim_group_multiplier,
        --claim_individual_multiplier,
        -- claim_group_reduced_amount,
        -- claim_individual_reduced_amount,
        --claim_subrogation_percent,
        --claim_modified_losses_group_reduced
        --claim_modified_losses_individual_reduced,
        data_source,
        created_at,
        updated_at
        )
        (SELECT
          a.representative_number,
          a.policy_type,
          a.policy_number,
          a.claim_number,
          a.claim_injury_date,
          round(a.claim_handicap_percent::numeric/100,2),
          a.claim_handicap_percent_effective_date,
          a.claim_manual_number,
          a.claimant_name,
          a.claimant_date_of_birth,
          a.claimant_date_of_death,
          a.claim_medical_paid,
          a.claim_mira_medical_reserve_amount,
          a.claim_mira_non_reducible_indemnity_paid,
          a.claim_mira_reducible_indemnity_paid,
          a.claim_mira_indemnity_reserve_amount,
          a.claim_mira_non_reducible_indemnity_paid_2,
          a.claim_total_subrogation_collected,
          (a.claim_medical_paid +
            a.claim_mira_medical_reserve_amount +
            a.claim_mira_non_reducible_indemnity_paid +
            a.claim_mira_reducible_indemnity_paid +
            a.claim_mira_indemnity_reserve_amount +
            a.claim_mira_non_reducible_indemnity_paid_2
          ) as "claim_unlimited_limited_loss"
          /*(case when (a.claim_medical_paid +
            a.claim_mira_medical_reserve_amount +
            a.claim_mira_non_reducible_indemnity_paid +
            a.claim_mira_reducible_indemnity_paid +
            a.claim_mira_indemnity_reserve_amount +
            a.claim_mira_non_reducible_indemnity_paid_2
          ) < '25000' THEN '1'
            else '25000'/(a.claim_medical_paid +
              a.claim_mira_medical_reserve_amount +
              a.claim_mira_non_reducible_indemnity_paid +
              a.claim_mira_reducible_indemnity_paid +
              a.claim_mira_indemnity_reserve_amount +
              a.claim_mira_non_reducible_indemnity_paid_2
            )
            end)::numeric as "claim_group_multiplier",

            (case when (a.claim_medical_paid +
              a.claim_mira_medical_reserve_amount +
              a.claim_mira_non_reducible_indemnity_paid +
              a.claim_mira_reducible_indemnity_paid +
              a.claim_mira_indemnity_reserve_amount +
              a.claim_mira_non_reducible_indemnity_paid_2
            ) < (SELECT b.policy_maximum_claim_value FROM public.test_table b WHERE a.policy_sequence_number = b.policy_number) THEN '1'
              else (SELECT b.policy_maximum_claim_value FROM public.test_table b WHERE a.policy_sequence_number = b.policy_number)/(a.claim_medical_paid +
                a.claim_mira_medical_reserve_amount +
                a.claim_mira_non_reducible_indemnity_paid +
                a.claim_mira_reducible_indemnity_paid +
                a.claim_mira_indemnity_reserve_amount +
                a.claim_mira_non_reducible_indemnity_paid_2
              )
              end)::decimal as "claim_independent_multiplier" */
              ,(SELECT plec.policy_maximum_claim_value from final_policy_experience_calculations plec where a.policy_number = plec.policy_number) as "policy_individual_maximum_claim_value",
              'bwc' as data_source,
              run_date as created_at,
              run_date as updated_at
          FROM public.democ_detail_records a
          WHERE a.representative_number = process_representative
          ORDER BY claim_unlimited_limited_loss desc
          );



      -- STEP 6B -- CALCULATION OF CLAIMS COSTS



      -- Calculate out the claim_group_multiplier
        -- give employers figures on how much they are saving by being in a group.
      UPDATE public.final_claim_cost_calculation_tables SET claim_group_multiplier =

        ((CASE WHEN '250000' > claim_unlimited_limited_loss THEN '1'
              ELSE ('250000' / nullif(claim_unlimited_limited_loss, 0))
              END)::numeric);


      -- Calculate out the claim_individual_multiplier
        -- give employers figures on how much they are saving by being in a group.
      UPDATE public.final_claim_cost_calculation_tables SET claim_individual_multiplier =
        (CASE WHEN (policy_individual_maximum_claim_value is null or claim_unlimited_limited_loss is null) THEN '1'
              WHEN policy_individual_maximum_claim_value > claim_unlimited_limited_loss THEN '1'
              WHEN policy_individual_maximum_claim_value = '0.00' THEN '1'
              ELSE (policy_individual_maximum_claim_value / claim_unlimited_limited_loss)
              END)::numeric;




        -- claim_group_reduced_amount,
        -- claim_individual_reduced_amount,

      -- Calculate out the claim reducable cost
        -- [ NON-REDUCABLE AMOUNT * CLAIMS GROUP MULTIPLIER ] + [ ( REDUCIBLE AMOUNT ) * (CLAIMS GROUP MULTIPLIER * ( 1 - Handicapped Percent))]

      UPDATE public.final_claim_cost_calculation_tables SET claim_group_reduced_amount =
      (((claim_mira_non_reducible_indemnity_paid + claim_mira_non_reducible_indemnity_paid_2 ) * claim_group_multiplier ) + ((claim_medical_paid +
      claim_mira_medical_reserve_amount +
      claim_mira_reducible_indemnity_paid +
      claim_mira_indemnity_reserve_amount) * claim_group_multiplier * (1 - claim_handicap_percent)));



      -- Calculate out the claim reducable cost
        -- [ NON-REDUCABLE AMOUNT * CLAIMS INDIVIDUAL MULTIPLIER ] + [ ( REDUCIBLE AMOUNT ) * (CLAIMS INDIVIDUAL MULTIPLIER * ( 1 - Handicapped Percent))]

      UPDATE public.final_claim_cost_calculation_tables SET claim_individual_reduced_amount =
      (((claim_mira_non_reducible_indemnity_paid +
        claim_mira_non_reducible_indemnity_paid_2) * claim_individual_multiplier) +
      (
      (claim_medical_paid +
      claim_mira_medical_reserve_amount +
      claim_mira_reducible_indemnity_paid +
      claim_mira_indemnity_reserve_amount) * claim_individual_multiplier * ( 1 - claim_handicap_percent )));



      -- Calculate subrogation of case AMOUNT


      UPDATE public.final_claim_cost_calculation_tables SET claim_subrogation_percent =
      (
      case WHEN claim_total_subrogation_collected = '0' THEN '0'
           WHEN claim_total_subrogation_collected > claim_unlimited_limited_loss THEN '1'
           ELSE claim_total_subrogation_collected / claim_unlimited_limited_loss
           END
      );


      -- Calulate final claim cost if in group rating

      UPDATE public.final_claim_cost_calculation_tables SET claim_modified_losses_group_reduced =
      (
        round((claim_group_reduced_amount * (1 - claim_subrogation_percent))::numeric,2)
      );

      -- calculate final claim cost if individual not group.

      UPDATE public.final_claim_cost_calculation_tables SET claim_modified_losses_individual_reduced =
      (
        round((claim_individual_reduced_amount * (1 - claim_subrogation_percent))::numeric,2)
      );
      end;
        $$;


--
-- Name: proc_step_7(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_7(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

      DECLARE
        run_date timestamp := LOCALTIMESTAMP;
      BEGIN

      -- STEP 7A -- Calcualate FINAL POLICY EXPERIENCE

      --UPDATE Policy_level group modified losses from the claim_calculations table

      -- NEW QUERY FOR CALCULATED MOTIFIED LOSSES.

      UPDATE public.final_policy_experience_calculations c SET (policy_total_modified_losses_group_reduced, policy_total_modified_losses_individual_reduced, policy_total_claims_count, updated_at) = (t2.policy_total_modified_losses_group_reduced, t2.policy_total_modified_losses_individual_reduced, t2.policy_total_claims_count, t2.updated_at)
      FROM
      (SELECT
      	b.policy_number,
      	round(sum(b.claim_modified_losses_group_reduced)::numeric,2) as policy_total_modified_losses_group_reduced,
      	round(sum(b.claim_modified_losses_individual_reduced)::numeric,2) as policy_total_modified_losses_individual_reduced,
      	(CASE WHEN sum(b.claim_modified_losses_group_reduced) = 0 and sum(b.claim_modified_losses_individual_reduced) = 0 THEN '0'
      	ELSE count(b.policy_number)
      	END)::integer as policy_total_claims_count,
        run_date as updated_at
      from public.final_claim_cost_calculation_tables b
      WHERE b.claim_injury_date BETWEEN experience_period_lower_date and experience_period_upper_date
      and b.representative_number = process_representative
      GROUP BY b.policy_number) t2
      WHERE c.policy_number = t2.policy_number;





      -- UPDATE losses for companies without claims.

      UPDATE public.final_policy_experience_calculations c SET (policy_total_modified_losses_group_reduced, policy_total_modified_losses_individual_reduced, policy_total_claims_count, updated_at) = (t2.policy_total_modified_losses_group_reduced, t2.policy_total_modified_losses_individual_reduced, t2.policy_total_claims_count, t2.updated_at)
      FROM
      (SELECT
      	b.policy_number,
      	round(sum(b.claim_modified_losses_group_reduced)::numeric,2) as policy_total_modified_losses_group_reduced,
      	round(sum(b.claim_modified_losses_individual_reduced)::numeric,2) as policy_total_modified_losses_individual_reduced,
      	'0'::integer as policy_total_claims_count,
        run_date as updated_at
      from public.final_claim_cost_calculation_tables b
      WHERE b.claim_injury_date is null and b.representative_number = process_representative
      GROUP BY b.policy_number) t2
      where c.policy_number = t2.policy_number;
      --

      -- UPdate for companies with really old claims, to zero out null values
      	UPDATE public.final_policy_experience_calculations c SET (policy_total_modified_losses_group_reduced, policy_total_modified_losses_individual_reduced, policy_total_claims_count) = (round('0'::numeric,2),round('0'::numeric,2),round('0'::numeric,1))
      	where policy_total_claims_count is null;




        -- UPDATE policy_group_ratio using the policy_total_modified_losses_group_reduced / policy_total_expected_losses

        update public.final_policy_experience_calculations SET policy_group_ratio =
          (
            CASE WHEN policy_total_expected_losses = '0.00' and policy_total_modified_losses_group_reduced = '0.00' THEN '0.00'::numeric
                 WHEN policy_total_expected_losses > '0.00' and policy_total_modified_losses_group_reduced >= '0.00' THEN
                 round((policy_total_modified_losses_group_reduced / policy_total_expected_losses)::numeric, 4)
            END
          );




      -- Update policy_individual_total_modifier but subtracting total limited losses from total modified losses and dividing by the total limited Losses.  Then Multiplying by the policy_credibility_percent

      update public.final_policy_experience_calculations SET policy_individual_total_modifier =
        (
          CASE WHEN policy_total_limited_losses = '0.00' THEN '0.00'::numeric
          ELSE
          round(((((policy_total_modified_losses_individual_reduced - policy_total_limited_losses ) / policy_total_limited_losses) * policy_credibility_percent)::numeric),2)
          END
        );

      -- Update policy_individual_total_modifier but subtracting total limited losses from total modified losses and dividing by the total limited Losses.  Then Multiplying by the policy_credibility_percent and adding one


      update public.final_policy_experience_calculations SET policy_individual_experience_modified_rate =
      	(
      		CASE WHEN policy_total_limited_losses = '0' THEN '1'::numeric
      		ELSE
      		round((((((policy_total_modified_losses_individual_reduced - policy_total_limited_losses ) / policy_total_limited_losses) * policy_credibility_percent) + 1)::numeric),2)
      		END
      	);

        end;

          $$;


--
-- Name: proc_step_8(integer, date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_step_8(process_representative integer, experience_period_lower_date date, experience_period_upper_date date, current_payroll_period_lower_date date, current_payroll_period_upper_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$

      DECLARE
        run_date timestamp := LOCALTIMESTAMP;
      BEGIN

      -- STEP 8A -- CREATE FINAL POLICY PREMIUMS AND PROJECTIONS

      Insert into final_policy_group_rating_and_premium_projections
      (
        representative_number,
        policy_number,
        policy_status,
        data_source,
        created_at,
        updated_at
      )
      (Select
        representative_number,
        policy_number,
        policy_status,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
      FROM final_policy_experience_calculations
      WHERE representative_number = process_representative
      );


      -- STEP 8B -- CREATE MANUAL LEVEL GROUP RATING AND PREMIUM CALCULATIONS


      INSERT INTO final_manual_class_group_rating_and_premium_projections
      (
        representative_number,
        policy_number,
        manual_number,
        -- ADD ALL INDUSTRY_GROUP'S PAYROLL WITHIN A POLICY_NUMBER SURE TO UPDATE THIS AFTER GOING AF
        -- PAYROLL IS PREVIOUS EXPERIENCE YEARS PAYROLL FROM THE TRANSACTIONS TABLE 'July & January'
        manual_class_current_estimated_payroll,
        data_source,
        created_at,
        updated_at
      )
      (
        SELECT
          a.representative_number,
          a.policy_number,
          b.manual_number,
          round(sum(b.manual_class_payroll)::numeric,2) as manual_class_current_estimated_payroll,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.final_employer_demographics_informations a
        Inner Join public.process_payroll_all_transactions_breakdown_by_manual_classes b
        ON a.policy_number = b.policy_number
        WHERE (b.reporting_period_start_date >= current_payroll_period_lower_date) and a.representative_number = process_representative
        GROUP BY a.representative_number, a.policy_number, b.manual_number
      );



      -- UPDATE THE Industry_group
      update public.final_manual_class_group_rating_and_premium_projections mcgr SET (manual_class_industry_group, updated_at)  = (t1.manual_class_industry_group, t1.updated_at)
      FROM
      (SELECT
        a.policy_number as policy_number,
        a.manual_number as manual_number,
        c.industry_group as manual_class_industry_group,
        run_date as updated_at
      FROM public.final_manual_class_group_rating_and_premium_projections a
      LEFT JOIN public.bwc_codes_ncci_manual_classes c
      ON a.manual_number = c.ncci_manual_classification
      WHERE a.representative_number = process_representative
      ) t1
      WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_number = t1.manual_number
      ;


      -- Update base_rate of manual_cass
      update public.final_manual_class_group_rating_and_premium_projections mcgr SET (manual_class_base_rate, updated_at)  = (t1.manual_class_base_rate, t1.updated_at)
      FROM
      (SELECT
        a.policy_number as policy_number,
        a.manual_number as manual_number,
        b.base_rate as manual_class_base_rate,
        run_date as updated_at
      FROM public.final_manual_class_group_rating_and_premium_projections a
      LEFT JOIN public.bwc_codes_base_rates_exp_loss_rates b
      ON a.manual_number = b.class_code
      WHERE a.representative_number = process_representative
      ) t1
      WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_number = t1.manual_number;


      update public.final_manual_class_group_rating_and_premium_projections mcgr SET (manual_class_standard_premium, updated_at)  = (t1.manual_class_standard_premium, t1.updated_at)
      FROM
      (SELECT
        a.policy_number as policy_number,
        a.manual_number as manual_number,
        round((a.manual_class_base_rate * a.manual_class_current_estimated_payroll * pec.policy_individual_experience_modified_rate)::numeric,2) as manual_class_standard_premium,
        run_date as updated_at
      FROM public.final_manual_class_group_rating_and_premium_projections a
      LEFT JOIN public.final_policy_experience_calculations pec
      ON a.policy_number = pec.policy_number
      WHERE a.representative_number = process_representative
      ) t1
      WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_number = t1.manual_number;



      -- UPDATE manual_class industry_group PAYROLL totals
      update public.final_manual_class_group_rating_and_premium_projections mcgr SET
      (manual_class_industry_group_premium_total, updated_at) = (t1.manual_class_industry_group_premium_total, t1.updated_at)
      FROM
        (
      SELECT
      a.policy_number as policy_number,
      a.manual_class_industry_group as manual_class_industry_group,
      round(sum(a.manual_class_standard_premium)::numeric,2) as manual_class_industry_group_premium_total,
      run_date as updated_at
      FROM public.final_manual_class_group_rating_and_premium_projections a
      WHERE a.representative_number = process_representative
      GROUP BY a.policy_number, a.manual_class_industry_group
        ) t1
        WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_class_industry_group = t1.manual_class_industry_group
      ;



       update public.final_policy_group_rating_and_premium_projections pgr SET (policy_total_standard_premium, updated_at) =
       (t1.policy_total_standard_premium, t1.updated_at)
       FROM
       (SELECT
           a.policy_number as policy_number,
         sum(a.manual_class_standard_premium) as policy_total_standard_premium,
         run_date as updated_at
         FROM public.final_manual_class_group_rating_and_premium_projections a
         WHERE a.representative_number = process_representative
         GROUP BY a.policy_number
       ) t1
       WHERE pgr.policy_number = t1.policy_number;




      update public.final_policy_group_rating_and_premium_projections pgr SET (policy_total_current_payroll, updated_at) =
      (t1.policy_total_current_payroll, t1.updated_at)
      FROM
      (SELECT
          a.policy_number as policy_number,
        sum(a.manual_class_current_estimated_payroll) as policy_total_current_payroll,
        run_date as updated_at
        FROM public.final_manual_class_group_rating_and_premium_projections a
        WHERE a.representative_number = process_representative
        GROUP BY a.policy_number
      ) t1
      WHERE pgr.policy_number = t1.policy_number;




      --
      --
      --
       -- UPDATE manual_class_industry_group_payroll_percentage
       update public.final_manual_class_group_rating_and_premium_projections mcgr SET
       (manual_class_industry_group_premium_percentage, updated_at) = (t1.manual_class_industry_group_premium_percentage, t1.updated_at)
       FROM
       (SELECT mc.policy_number, mc.manual_number,
       round((CASE WHEN (p.policy_total_standard_premium is null) or (p.policy_total_standard_premium = '0') or (mc.manual_class_industry_group_premium_total = '0') or (mc.manual_class_industry_group_premium_total is null) THEN '0'
       	ELSE
       ( mc.manual_class_industry_group_premium_total / p.policy_total_standard_premium)
       END )::numeric,3) as manual_class_industry_group_premium_percentage,
       run_date as updated_at
       FROM public.final_manual_class_group_rating_and_premium_projections mc
       RIGHT JOIN public.final_policy_group_rating_and_premium_projections p
       ON mc.policy_number = p.policy_number
       WHERE p.representative_number = process_representative
       ) t1
       WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_number = t1.manual_number;


      -- UPDATE  modification rate
       update public.final_manual_class_group_rating_and_premium_projections mcgr SET
       (manual_class_modification_rate, updated_at) = (t1.manual_class_modification_rate, t1.updated_at)
       FROM
       (
         SELECT
         a.policy_number as policy_number,
         a.manual_number as manual_number,
         round((a.manual_class_base_rate * plec.policy_individual_experience_modified_rate)::numeric,4) as manual_class_modification_rate,
         run_date as updated_at
           FROM public.final_manual_class_group_rating_and_premium_projections a
           LEFT JOIN public.final_policy_experience_calculations plec
           ON a.policy_number = plec.policy_number
           WHERE a.representative_number = process_representative
         ) t1
         WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_number = t1.manual_number;



      -- update Individual Total Rate
      UPDATE public.final_manual_class_group_rating_and_premium_projections mcgr SET
      (manual_class_individual_total_rate) =
      (round((manual_class_modification_rate *  (1 + (SELECT rate from public.bwc_codes_constant_values
      where name = 'administrative_rate' and completed_date is null)))::numeric,6));


      -- ADDED Logic to find industry_group by using the Homogeneity File

      update public.final_policy_group_rating_and_premium_projections c SET
        (policy_industry_group, updated_at) = (t1.manual_class, t1.updated_at)
        FROM
        (SELECT a.policy_number as policy_number,
            	(SELECT cast_to_int(b.industry_code)
      	FROM public.phmgn_detail_records b
      	WHERE  b.policy_number = a.policy_number and cast_to_int(b.industry_code) != 0
             ORDER BY premium_percentage DESC NULLS LAST LIMIT 1) as manual_class,
             run_date as updated_at
        FROM final_policy_group_rating_and_premium_projections a
        ) t1
        WHERE c.policy_number = t1.policy_number;



      -- Update policy industry group based on highest payroll percentage by industry group of all manual classes.
        -- Adds up like manual classes if different manual classes for a policy belong to the same policy.


      update public.final_policy_group_rating_and_premium_projections c SET
        (policy_industry_group, updated_at) = (t1.manual_class, t1.updated_at)
        FROM
      (SELECT a.policy_number as policy_number,
      	(SELECT b.manual_class_industry_group
      	FROM final_manual_class_group_rating_and_premium_projections b
      	WHERE  b.policy_number = a.policy_number
              ORDER BY manual_class_industry_group_premium_percentage DESC NULLS LAST LIMIT 1) as manual_class,
              run_date as updated_at
      FROM final_policy_group_rating_and_premium_projections a
      WHERE a.representative_number = process_representative
        ) t1
        WHERE c.policy_number = t1.policy_number and c.policy_industry_group is null;



      -- ADD logic to update a  new industry_group when the industry_group is 10.

      -- LOGIC: query to find the policy_numbers that have an industry_group of 10 and a experience ratio between .05 and .86
              -- THEN find a manual_class within for a policy_number within that list that has a 20% or above premium for the policy_number
      UPDATE public.final_policy_group_rating_and_premium_projections c SET
        (policy_industry_group, updated_at) = (t1.manual_class_industry_group, t1.updated_at)
      FROM
      (SELECT l.policy_number, l.manual_class_industry_group, run_date as updated_at
          FROM public.final_manual_class_group_rating_and_premium_projections l
          WHERE policy_number in (SELECT fp.policy_number
          FROM public.final_policy_group_rating_and_premium_projections fp
          WHERE fp.policy_industry_group = '10' and fp.representative_number = process_representative) and policy_number in (SELECT fpe.policy_number FROM final_policy_experience_calculations fpe where fpe.policy_group_ratio between '.05' and '.86')
          and manual_class_industry_group != '10' and manual_class_industry_group_premium_percentage > '.2'
          and representative_number = process_representative
          GROUP BY representative_number, policy_number, manual_class_industry_group, manual_class_industry_group_premium_percentage
          ORDER BY manual_class_industry_group_premium_percentage
        ) t1
        WHERE c.policy_number = t1.policy_number;


      -- 06/06/2016 ADDED condition for creating group_rating_tier only when the policy_status is Active, ReInsured, or Lapse
      -- update group_rating_tier

      -- update public.final_policy_group_rating_and_premium_projections c SET
      -- (group_rating_tier, updated_at)	= (t1.group_rating_tier, t1.updated_at)
      -- FROM
      -- 	(SELECT
      -- 		a.policy_number,
      -- 		(SELECT (CASE WHEN (a.policy_group_ratio = '0') THEN '-.53'
      -- 					ELSE min(market_rate)
      -- 					END)  as group_rating_tier
      -- 				 FROM public.bwc_codes_industry_group_savings_ratio_criteria
      -- 				 WHERE (a.policy_group_ratio /ratio_criteria <= 1) and (industry_group = b.policy_industry_group)),
      --          run_date as updated_at
      -- 			FROM public.final_policy_experience_calculations a
      --       LEFT JOIN final_policy_group_rating_and_premium_projections b
      --       ON a.policy_number = b.policy_number
      --       WHERE a.representative_number = process_representative and a.policy_group_ratio is not null
      -- 			GROUP BY a.policy_number, a.policy_group_ratio, a.policy_status, b.policy_industry_group
      -- 		) t1
      -- WHERE c.policy_number = t1.policy_number;




      -- UPDATE public.final_manual_class_group_rating_and_premium_projections mcgr SET
      -- (manual_class_group_total_rate, updated_at) = (t1.manual_class_group_total_rate, t1.updated_at)
      -- FROM
      -- (
      --  SELECT a.policy_number as policy_number,
      --    a.manual_number as manual_number,
      --    ((1+ b.group_rating_tier) * a.manual_class_base_rate * (1 + (SELECT rate from public.bwc_codes_constant_values
      --    where name = 'administrative_rate' and completed_date is null))) as manual_class_group_total_rate,
      --    run_date as updated_at
      --  FROM public.final_manual_class_group_rating_and_premium_projections a
      --  Left Join public.final_policy_group_rating_and_premium_projections b
      --  ON a.policy_number = b.policy_number
      --  WHERE a.representative_number = process_representative
      -- ) t1
      -- WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_number = t1.manual_number;



      --Update Premium Values
           UPDATE public.final_manual_class_group_rating_and_premium_projections mcgr SET
           (
           manual_class_estimated_group_premium,
           manual_class_estimated_individual_premium) =
           (
           manual_class_current_estimated_payroll * manual_class_group_total_rate
           ,
           manual_class_current_estimated_payroll * manual_class_individual_total_rate
           );


      UPDATE public.final_policy_group_rating_and_premium_projections pgr SET (policy_total_individual_premium, updated_at) = (t1.policy_total_individual_premium, t1.updated_at)
      FROM
      (SELECT a.policy_number,
        round(SUM(a.manual_class_estimated_individual_premium)::numeric,2) as policy_total_individual_premium,
        run_date as updated_at
        FROM public.final_manual_class_group_rating_and_premium_projections a
        WHERE a.representative_number = process_representative
        Group BY a.policy_number
      ) t1
      WHERE pgr.policy_number = t1.policy_number;


      -- Update policy_total_group_savings
      -- UPDATE public.final_policy_group_rating_and_premium_projections pgr SET (policy_total_group_savings, updated_at) =
      -- (t1.policy_total_group_savings, t1.updated_at)
      -- FROM
      -- (SELECT a.policy_number,
      --   round((a.policy_total_individual_premium - a.policy_total_group_premium)::numeric,2) as policy_total_group_savings,
      --   run_date as updated_at
      -- FROM final_policy_group_rating_and_premium_projections a
      -- WHERE a.representative_number = process_representative
      --) t1
      --WHERE pgr.policy_number = t1.policy_number;


      DELETE FROM process_policy_experience_period_peos
      WHERE id IN (SELECT id
                   FROM (SELECT id,
                                  ROW_NUMBER() OVER (partition BY representative_number, policy_number, manual_class_sf_peo_lease_effective_date,
       manual_class_sf_peo_lease_termination_date, manual_class_si_peo_lease_effective_date,
       manual_class_si_peo_lease_termination_date, data_source ORDER BY id) AS rnum
                          FROM process_policy_experience_period_peos) t
                   WHERE t.rnum > 1);

      end;

        $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_programs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_programs (
    id integer NOT NULL,
    account_id integer,
    program_type integer,
    status integer,
    fees_amount double precision,
    paid_amount double precision,
    invoice_number character varying,
    quote_generated character varying,
    quote_date date,
    quote_sent_date date,
    effective_start_date date,
    effective_end_date date,
    ac2_signed_on date,
    ac26_signed_on date,
    u153_signed_on date,
    contract_signed_on date,
    questionnaire_signed_on date,
    invoice_received_on date,
    program_paid_on date,
    group_code character varying,
    check_number character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    quote_tier double precision
);


--
-- Name: account_programs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE account_programs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_programs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE account_programs_id_seq OWNED BY account_programs.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accounts (
    id integer NOT NULL,
    representative_id integer,
    name character varying,
    policy_number_entered integer,
    street_address character varying,
    street_address_2 character varying,
    city character varying,
    state character varying,
    zip_code character varying,
    business_phone_number bigint,
    business_email_address character varying,
    website_url character varying,
    group_rating_qualification integer,
    industry_group integer,
    group_rating_tier double precision,
    group_rating_group_number character varying,
    group_premium double precision,
    group_savings double precision,
    group_fees double precision,
    group_dues double precision,
    total_costs double precision,
    status integer DEFAULT 0,
    federal_identification_number character varying,
    cycle_date date,
    request_date date,
    quarterly_request boolean,
    weekly_request boolean,
    ac3_approval boolean,
    user_override boolean,
    group_retro_qualification character varying,
    group_retro_tier character varying,
    group_retro_group_number character varying,
    group_retro_premium double precision,
    group_retro_savings double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fee_override double precision,
    fee_change double precision
);


--
-- Name: accounts_affiliates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accounts_affiliates (
    id integer NOT NULL,
    account_id integer,
    affiliate_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: accounts_affiliates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_affiliates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_affiliates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_affiliates_id_seq OWNED BY accounts_affiliates.id;


--
-- Name: accounts_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accounts_contacts (
    id integer NOT NULL,
    account_id integer,
    contact_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: accounts_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_contacts_id_seq OWNED BY accounts_contacts.id;


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: affiliates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE affiliates (
    id integer NOT NULL,
    first_name character varying,
    last_name character varying,
    role integer DEFAULT 0,
    email_address character varying,
    salesforce_id character varying,
    representative_id integer,
    internal_external integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    external_id character varying,
    company_name character varying
);


--
-- Name: affiliates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE affiliates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: affiliates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE affiliates_id_seq OWNED BY affiliates.id;


--
-- Name: bwc_annual_manual_class_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_annual_manual_class_changes (
    id integer NOT NULL,
    manual_class_from integer,
    manual_class_to integer,
    policy_year integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bwc_annual_manual_class_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_annual_manual_class_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_annual_manual_class_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_annual_manual_class_changes_id_seq OWNED BY bwc_annual_manual_class_changes.id;


--
-- Name: bwc_codes_base_rates_exp_loss_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_base_rates_exp_loss_rates (
    id integer NOT NULL,
    class_code integer,
    base_rate double precision,
    expected_loss_rate double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_base_rates_exp_loss_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_base_rates_exp_loss_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_base_rates_exp_loss_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_base_rates_exp_loss_rates_id_seq OWNED BY bwc_codes_base_rates_exp_loss_rates.id;


--
-- Name: bwc_codes_constant_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_constant_values (
    id integer NOT NULL,
    name character varying,
    rate double precision,
    start_date date,
    completed_date date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_constant_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_constant_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_constant_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_constant_values_id_seq OWNED BY bwc_codes_constant_values.id;


--
-- Name: bwc_codes_credibility_max_losses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_credibility_max_losses (
    id integer NOT NULL,
    credibility_group integer,
    expected_losses integer,
    credibility_percent double precision,
    group_maximum_value integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_credibility_max_losses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_credibility_max_losses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_credibility_max_losses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_credibility_max_losses_id_seq OWNED BY bwc_codes_credibility_max_losses.id;


--
-- Name: bwc_codes_employer_representatives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_employer_representatives (
    id integer NOT NULL,
    rep_id integer,
    employer_rep_name character varying,
    rep_id_text character varying,
    representative_number integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_employer_representatives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_employer_representatives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_employer_representatives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_employer_representatives_id_seq OWNED BY bwc_codes_employer_representatives.id;


--
-- Name: bwc_codes_group_retro_tiers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_group_retro_tiers (
    id integer NOT NULL,
    industry_group integer,
    discount_tier double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bwc_codes_group_retro_tiers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_group_retro_tiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_group_retro_tiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_group_retro_tiers_id_seq OWNED BY bwc_codes_group_retro_tiers.id;


--
-- Name: bwc_codes_industry_group_savings_ratio_criteria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_industry_group_savings_ratio_criteria (
    id integer NOT NULL,
    industry_group integer,
    ratio_criteria double precision,
    average_ratio double precision,
    actual_decimal double precision,
    percent_value double precision,
    em double precision,
    market_rate double precision,
    market_em_rate double precision,
    sponsor character varying,
    ac26_group_level character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_industry_group_savings_ratio_criteria_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_industry_group_savings_ratio_criteria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_industry_group_savings_ratio_criteria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_industry_group_savings_ratio_criteria_id_seq OWNED BY bwc_codes_industry_group_savings_ratio_criteria.id;


--
-- Name: bwc_codes_limited_loss_ratios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_limited_loss_ratios (
    id integer NOT NULL,
    industry_group integer,
    credibility_group integer,
    limited_loss_ratio double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_limited_loss_ratios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_limited_loss_ratios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_limited_loss_ratios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_limited_loss_ratios_id_seq OWNED BY bwc_codes_limited_loss_ratios.id;


--
-- Name: bwc_codes_ncci_manual_classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_ncci_manual_classes (
    id integer NOT NULL,
    industry_group integer,
    ncci_manual_classification integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_ncci_manual_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_ncci_manual_classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_ncci_manual_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_ncci_manual_classes_id_seq OWNED BY bwc_codes_ncci_manual_classes.id;


--
-- Name: bwc_codes_peo_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_peo_lists (
    id integer NOT NULL,
    policy_type character varying,
    policy_number integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_peo_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_peo_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_peo_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_peo_lists_id_seq OWNED BY bwc_codes_peo_lists.id;


--
-- Name: bwc_codes_policy_effective_dates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_policy_effective_dates (
    id integer NOT NULL,
    policy_number integer,
    policy_original_effective_date date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_policy_effective_dates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_policy_effective_dates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_policy_effective_dates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_policy_effective_dates_id_seq OWNED BY bwc_codes_policy_effective_dates.id;


--
-- Name: bwc_group_accept_reject_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_group_accept_reject_lists (
    id integer NOT NULL,
    policy_number integer,
    name character varying,
    tpa character varying,
    bwc_rep_id character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_group_accept_reject_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_group_accept_reject_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_group_accept_reject_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_group_accept_reject_lists_id_seq OWNED BY bwc_group_accept_reject_lists.id;


--
-- Name: claim_calculations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE claim_calculations (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    policy_calculation_id integer,
    claim_number character varying,
    claim_injury_date date,
    claim_handicap_percent double precision,
    claim_handicap_percent_effective_date date,
    claimant_date_of_death date,
    claimant_date_of_birth date,
    claimant_name character varying,
    claim_manual_number integer,
    claim_medical_paid double precision,
    claim_mira_medical_reserve_amount double precision,
    claim_mira_non_reducible_indemnity_paid double precision,
    claim_mira_reducible_indemnity_paid double precision,
    claim_mira_indemnity_reserve_amount double precision,
    claim_mira_non_reducible_indemnity_paid_2 double precision,
    claim_total_subrogation_collected double precision,
    claim_unlimited_limited_loss double precision,
    policy_individual_maximum_claim_value double precision,
    claim_group_multiplier double precision,
    claim_individual_multiplier double precision,
    claim_group_reduced_amount double precision,
    claim_individual_reduced_amount double precision,
    claim_subrogation_percent double precision,
    claim_modified_losses_group_reduced double precision,
    claim_modified_losses_individual_reduced double precision,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    claim_combined character varying,
    combined_into_claim_number character varying,
    claim_rating_plan_indicator character varying,
    claim_status character varying,
    claim_status_effective_date date,
    claim_type character varying,
    claim_activity_status character varying,
    claim_activity_status_effective_date date,
    settled_claim character varying,
    settlement_type character varying,
    medical_settlement_date date,
    indemnity_settlement_date date,
    maximum_medical_improvement_date date,
    claim_mira_ncci_injury_type character varying
);


--
-- Name: claim_calculations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE claim_calculations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: claim_calculations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE claim_calculations_id_seq OWNED BY claim_calculations.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contacts (
    id integer NOT NULL,
    prefix integer DEFAULT 0,
    first_name character varying,
    middle_initial character varying,
    last_name character varying,
    suffix character varying,
    email_address character varying,
    phone_number character varying,
    phone_extension character varying,
    mobile_phone character varying,
    fax_number character varying,
    contact_type integer DEFAULT 1,
    salesforce_id character varying,
    title character varying,
    address_line_1 character varying,
    address_line_2 character varying,
    city character varying,
    state character varying,
    zip_code character varying,
    country character varying,
    created_by character varying,
    updated_by character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: democ_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE democ_detail_records (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    record_type integer,
    requestor_number integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    valid_policy_number character varying,
    current_policy_status character varying,
    current_policy_status_effective_date date,
    claimant_name character varying,
    policy_year integer,
    policy_year_rating_plan character varying,
    claim_indicator character varying,
    claim_number character varying,
    claim_injury_date date,
    claim_combined character varying,
    combined_into_claim_number character varying,
    claim_rating_plan_indicator character varying,
    claim_status character varying,
    claim_status_effective_date date,
    claim_manual_number integer,
    claim_sub_manual_number character varying,
    claim_type character varying,
    claimant_date_of_death date,
    claimant_date_of_birth date,
    claim_activity_status character varying,
    claim_activity_status_effective_date date,
    settled_claim character varying,
    settlement_type character varying,
    medical_settlement_date date,
    indemnity_settlement_date date,
    maximum_medical_improvement_date date,
    last_paid_medical_date date,
    last_paid_indemnity_date date,
    average_weekly_wage double precision,
    full_weekly_wage double precision,
    claim_handicap_percent character varying,
    claim_handicap_percent_effective_date date,
    claim_mira_ncci_injury_type character varying,
    claim_medical_paid integer,
    claim_mira_medical_reserve_amount integer,
    claim_mira_non_reducible_indemnity_paid integer,
    claim_mira_reducible_indemnity_paid integer,
    claim_mira_indemnity_reserve_amount integer,
    industrial_commission_appeal_indicator character varying,
    claim_mira_non_reducible_indemnity_paid_2 integer,
    claim_total_subrogation_collected integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: democ_detail_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE democ_detail_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: democ_detail_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE democ_detail_records_id_seq OWNED BY democ_detail_records.id;


--
-- Name: democs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE democs (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: democs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE democs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: democs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE democs_id_seq OWNED BY democs.id;


--
-- Name: exception_table_policy_combined_request_payroll_infos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE exception_table_policy_combined_request_payroll_infos (
    id integer NOT NULL,
    representative_number character varying,
    predecessor_policy_type character varying,
    predecessor_policy_number integer,
    successor_policy_type character varying,
    successor_policy_number integer,
    transfer_type character varying,
    transfer_effective_date date,
    transfer_creation_date date,
    payroll_origin character varying,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: exception_table_policy_combined_request_payroll_infos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE exception_table_policy_combined_request_payroll_infos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exception_table_policy_combined_request_payroll_infos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE exception_table_policy_combined_request_payroll_infos_id_seq OWNED BY exception_table_policy_combined_request_payroll_infos.id;


--
-- Name: final_claim_cost_calculation_tables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE final_claim_cost_calculation_tables (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    claim_number character varying,
    claim_injury_date date,
    claim_handicap_percent double precision,
    claimant_name character varying,
    claimant_date_of_birth date,
    claimant_date_of_death date,
    claim_handicap_percent_effective_date date,
    claim_manual_number integer,
    claim_medical_paid double precision,
    claim_mira_medical_reserve_amount double precision,
    claim_mira_non_reducible_indemnity_paid double precision,
    claim_mira_reducible_indemnity_paid double precision,
    claim_mira_indemnity_reserve_amount double precision,
    claim_mira_non_reducible_indemnity_paid_2 double precision,
    claim_total_subrogation_collected double precision,
    claim_unlimited_limited_loss double precision,
    policy_individual_maximum_claim_value double precision,
    claim_group_multiplier double precision,
    claim_individual_multiplier double precision,
    claim_group_reduced_amount double precision,
    claim_individual_reduced_amount double precision,
    claim_subrogation_percent double precision,
    claim_modified_losses_group_reduced double precision,
    claim_modified_losses_individual_reduced double precision,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    claim_combined character varying,
    combined_into_claim_number character varying,
    claim_rating_plan_indicator character varying,
    claim_status character varying,
    claim_status_effective_date date,
    claim_type character varying,
    claim_activity_status character varying,
    claim_activity_status_effective_date date,
    settled_claim character varying,
    settlement_type character varying,
    medical_settlement_date date,
    indemnity_settlement_date date,
    maximum_medical_improvement_date date,
    claim_mira_ncci_injury_type character varying
);


--
-- Name: final_claim_cost_calculation_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE final_claim_cost_calculation_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: final_claim_cost_calculation_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE final_claim_cost_calculation_tables_id_seq OWNED BY final_claim_cost_calculation_tables.id;


--
-- Name: final_employer_demographics_informations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE final_employer_demographics_informations (
    id integer NOT NULL,
    representative_number integer,
    policy_number integer,
    currently_assigned_representative_number integer,
    valid_policy_number character varying,
    current_coverage_status character varying,
    coverage_status_effective_date date,
    policy_creation_date date,
    federal_identification_number character varying,
    business_name character varying,
    trading_as_name character varying,
    valid_mailing_address character varying,
    mailing_address_line_1 character varying,
    mailing_address_line_2 character varying,
    mailing_city character varying,
    mailing_state character varying,
    mailing_zip_code integer,
    mailing_zip_code_plus_4 integer,
    mailing_country_code integer,
    mailing_county integer,
    valid_location_address character varying,
    location_address_line_1 character varying,
    location_address_line_2 character varying,
    location_city character varying,
    location_state character varying,
    location_zip_code integer,
    location_zip_code_plus_4 integer,
    location_country_code integer,
    location_county integer,
    currently_assigned_clm_representative_number integer,
    currently_assigned_risk_representative_number integer,
    currently_assigned_erc_representative_number integer,
    currently_assigned_grc_representative_number integer,
    immediate_successor_policy_number integer,
    immediate_successor_business_sequence_number integer,
    ultimate_successor_policy_number integer,
    ultimate_successor_business_sequence_number integer,
    employer_type character varying,
    coverage_type character varying,
    policy_coverage_type character varying,
    policy_employer_type character varying,
    merit_rate double precision,
    group_code character varying,
    minimum_premium_percentage character varying,
    rate_adjust_factor character varying,
    em_effective_date date,
    regular_balance_amount double precision,
    attorney_general_balance_amount double precision,
    appealed_balance_amount double precision,
    pending_balance_amount double precision,
    advance_deposit_amount double precision,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: final_employer_demographics_informations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE final_employer_demographics_informations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: final_employer_demographics_informations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE final_employer_demographics_informations_id_seq OWNED BY final_employer_demographics_informations.id;


--
-- Name: final_manual_class_four_year_payroll_and_exp_losses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE final_manual_class_four_year_payroll_and_exp_losses (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    manual_number integer,
    manual_class_type character varying,
    manual_class_four_year_period_payroll double precision,
    manual_class_expected_loss_rate double precision,
    manual_class_base_rate double precision,
    manual_class_expected_losses double precision,
    manual_class_industry_group integer,
    manual_class_limited_loss_rate double precision,
    manual_class_limited_losses double precision,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: final_manual_class_four_year_payroll_and_exp_losses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE final_manual_class_four_year_payroll_and_exp_losses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: final_manual_class_four_year_payroll_and_exp_losses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE final_manual_class_four_year_payroll_and_exp_losses_id_seq OWNED BY final_manual_class_four_year_payroll_and_exp_losses.id;


--
-- Name: final_manual_class_group_rating_and_premium_projections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE final_manual_class_group_rating_and_premium_projections (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    manual_number integer,
    manual_class_type character varying,
    manual_class_industry_group integer,
    manual_class_industry_group_premium_total double precision,
    manual_class_current_estimated_payroll double precision,
    manual_class_base_rate double precision,
    manual_class_industry_group_premium_percentage double precision,
    manual_class_modification_rate double precision,
    manual_class_individual_total_rate double precision,
    manual_class_group_total_rate double precision,
    manual_class_standard_premium double precision,
    manual_class_estimated_group_premium double precision,
    manual_class_estimated_individual_premium double precision,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: final_manual_class_group_rating_and_premium_projections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE final_manual_class_group_rating_and_premium_projections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: final_manual_class_group_rating_and_premium_projections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE final_manual_class_group_rating_and_premium_projections_id_seq OWNED BY final_manual_class_group_rating_and_premium_projections.id;


--
-- Name: final_policy_experience_calculations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE final_policy_experience_calculations (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    valid_policy_number character varying,
    policy_group_number character varying,
    policy_status character varying,
    policy_total_four_year_payroll double precision,
    policy_credibility_group integer,
    policy_maximum_claim_value integer,
    policy_credibility_percent double precision,
    policy_total_expected_losses double precision,
    policy_total_limited_losses double precision,
    policy_total_claims_count integer,
    policy_total_modified_losses_group_reduced double precision,
    policy_total_modified_losses_individual_reduced double precision,
    policy_group_ratio double precision,
    policy_individual_total_modifier double precision,
    policy_individual_experience_modified_rate double precision,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: final_policy_experience_calculations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE final_policy_experience_calculations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: final_policy_experience_calculations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE final_policy_experience_calculations_id_seq OWNED BY final_policy_experience_calculations.id;


--
-- Name: final_policy_group_rating_and_premium_projections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE final_policy_group_rating_and_premium_projections (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    policy_industry_group integer,
    policy_status character varying,
    group_rating_qualification character varying,
    group_rating_tier double precision,
    group_rating_group_number integer,
    policy_total_current_payroll double precision,
    policy_total_standard_premium double precision,
    policy_total_individual_premium double precision,
    policy_total_group_premium double precision,
    policy_total_group_savings double precision,
    policy_group_fees double precision,
    policy_group_dues double precision,
    policy_total_costs double precision,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: final_policy_group_rating_and_premium_projections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE final_policy_group_rating_and_premium_projections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: final_policy_group_rating_and_premium_projections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE final_policy_group_rating_and_premium_projections_id_seq OWNED BY final_policy_group_rating_and_premium_projections.id;


--
-- Name: group_rating_exceptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE group_rating_exceptions (
    id integer NOT NULL,
    account_id integer,
    representative_id integer,
    exception_reason character varying,
    resolved boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: group_rating_exceptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_rating_exceptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_rating_exceptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_rating_exceptions_id_seq OWNED BY group_rating_exceptions.id;


--
-- Name: group_rating_rejections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE group_rating_rejections (
    id integer NOT NULL,
    account_id integer,
    representative_id integer,
    reject_reason character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    program_type character varying
);


--
-- Name: group_rating_rejections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_rating_rejections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_rating_rejections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_rating_rejections_id_seq OWNED BY group_rating_rejections.id;


--
-- Name: group_ratings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE group_ratings (
    id integer NOT NULL,
    process_representative integer,
    status text,
    experience_period_lower_date date,
    experience_period_upper_date date,
    current_payroll_period_lower_date date,
    current_payroll_period_upper_date date,
    total_accounts_updated integer,
    total_policies_updated integer,
    total_manual_classes_updated integer,
    total_payrolls_updated integer,
    total_claims_updated integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    representative_id integer,
    current_payroll_year integer,
    program_year_lower_date date,
    program_year_upper_date date,
    program_year integer,
    quote_year_lower_date date,
    quote_year_upper_date date,
    quote_year integer
);


--
-- Name: group_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_ratings_id_seq OWNED BY group_ratings.id;


--
-- Name: imports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE imports (
    id integer NOT NULL,
    process_representative integer,
    group_rating_id integer,
    import_status text,
    parse_status text,
    democs_count integer,
    mrcls_count integer,
    mremps_count integer,
    pcombs_count integer,
    phmgns_count integer,
    sc220s_count integer,
    sc230s_count integer,
    rates_count integer,
    pdemos_count integer,
    pemhs_count integer,
    pcovgs_count integer,
    democ_detail_records_count integer,
    mrcl_detail_records_count integer,
    mremp_employee_experience_policy_levels_count integer,
    mremp_employee_experience_manual_class_levels_count integer,
    mremp_employee_experience_claim_levels_count integer,
    pcomb_detail_records_count integer,
    phmgn_detail_records_count integer,
    sc220_rec1_employer_demographics_count integer,
    sc220_rec2_employer_manual_level_payrolls_count integer,
    sc220_rec3_employer_ar_transactions_count integer,
    sc220_rec4_policy_not_founds_count integer,
    sc230_employer_demographics_count integer,
    sc230_claim_medical_payments_count integer,
    sc230_claim_indemnity_awards_count integer,
    rate_detail_records_count integer,
    pdemo_detail_records_count integer,
    pemh_detail_records_count integer,
    pcovg_detail_records_count integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    representative_id integer
);


--
-- Name: imports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: imports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE imports_id_seq OWNED BY imports.id;


--
-- Name: manual_class_calculations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE manual_class_calculations (
    id integer NOT NULL,
    representative_number integer,
    policy_calculation_id integer,
    policy_number integer,
    manual_class_type character varying,
    manual_number integer,
    manual_class_four_year_period_payroll double precision,
    manual_class_expected_loss_rate double precision,
    manual_class_base_rate double precision,
    manual_class_expected_losses double precision,
    manual_class_industry_group integer,
    manual_class_limited_loss_rate double precision,
    manual_class_limited_losses double precision,
    manual_class_industry_group_premium_total double precision,
    manual_class_current_estimated_payroll double precision,
    manual_class_industry_group_premium_percentage double precision,
    manual_class_modification_rate double precision,
    manual_class_individual_total_rate double precision,
    manual_class_group_total_rate double precision,
    manual_class_standard_premium double precision,
    manual_class_estimated_group_premium double precision,
    manual_class_estimated_individual_premium double precision,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: manual_class_calculations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE manual_class_calculations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: manual_class_calculations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE manual_class_calculations_id_seq OWNED BY manual_class_calculations.id;


--
-- Name: mrcl_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrcl_detail_records (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    record_type integer,
    requestor_number integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    valid_policy_number character varying,
    manual_reclassifications character varying,
    re_classed_from_manual_number integer,
    re_classed_to_manual_number integer,
    reclass_manual_coverage_type character varying,
    reclass_creation_date date,
    reclassed_payroll_information character varying,
    payroll_reporting_period_from_date date,
    payroll_reporting_period_to_date date,
    re_classed_to_manual_payroll_total double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: mrcl_detail_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrcl_detail_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mrcl_detail_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrcl_detail_records_id_seq OWNED BY mrcl_detail_records.id;


--
-- Name: mrcls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrcls (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: mrcls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrcls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mrcls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrcls_id_seq OWNED BY mrcls.id;


--
-- Name: mremp_employee_experience_claim_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mremp_employee_experience_claim_levels (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    record_type integer,
    manual_number integer,
    sub_manual_number character varying,
    claim_reserve_code character varying,
    claim_number character varying,
    injury_date date,
    claim_indemnity_paid_using_mira_rules integer,
    claim_indemnity_mira_reserve integer,
    claim_medical_paid integer,
    claim_medical_reserve integer,
    claim_indemnity_handicap_paid_using_mira_rules integer,
    claim_indemnity_handicap_mira_reserve integer,
    claim_medical_handicap_paid integer,
    claim_medical_handicap_reserve integer,
    claim_surplus_type character varying,
    claim_handicap_percent character varying,
    claim_over_policy_max_value_indicator character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mremp_employee_experience_claim_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mremp_employee_experience_claim_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mremp_employee_experience_claim_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mremp_employee_experience_claim_levels_id_seq OWNED BY mremp_employee_experience_claim_levels.id;


--
-- Name: mremp_employee_experience_manual_class_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mremp_employee_experience_manual_class_levels (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    record_type integer,
    manual_number integer,
    sub_manual_number character varying,
    claim_reserve_code character varying,
    claim_number character varying,
    experience_period_payroll integer,
    manual_class_base_rate double precision,
    manual_class_expected_loss_rate double precision,
    manual_class_expected_losses integer,
    merit_rated_flag character varying,
    policy_manual_status character varying,
    limited_loss_ratio double precision,
    limited_losses integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mremp_employee_experience_manual_class_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mremp_employee_experience_manual_class_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mremp_employee_experience_manual_class_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mremp_employee_experience_manual_class_levels_id_seq OWNED BY mremp_employee_experience_manual_class_levels.id;


--
-- Name: mremp_employee_experience_policy_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mremp_employee_experience_policy_levels (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    record_type integer,
    manual_number integer,
    sub_manual_number character varying,
    claim_reserve_code character varying,
    claim_number character varying,
    federal_id character varying,
    grand_total_modified_losses integer,
    grand_total_expected_losses integer,
    grand_total_limited_losses integer,
    policy_maximum_claim_size integer,
    policy_credibility double precision,
    policy_experience_modifier_percent double precision,
    employer_name character varying,
    doing_business_as_name character varying,
    referral_name character varying,
    address character varying,
    city character varying,
    state character varying,
    zip_code character varying,
    print_code character varying,
    policy_year integer,
    extract_date date,
    policy_year_exp_period_beginning_date date,
    policy_year_exp_period_ending_date date,
    green_year character varying,
    reserves_used_in_the_published_em character varying,
    risk_group_number character varying,
    em_capped_flag character varying,
    capped_em_percentage character varying,
    ocp_flag character varying,
    construction_cap_flag character varying,
    published_em_percentage double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mremp_employee_experience_policy_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mremp_employee_experience_policy_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mremp_employee_experience_policy_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mremp_employee_experience_policy_levels_id_seq OWNED BY mremp_employee_experience_policy_levels.id;


--
-- Name: mremps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mremps (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: mremps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mremps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mremps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mremps_id_seq OWNED BY mremps.id;


--
-- Name: payroll_calculations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE payroll_calculations (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    manual_class_type character varying,
    manual_number integer,
    manual_class_calculation_id integer,
    reporting_period_start_date date,
    reporting_period_end_date date,
    manual_class_payroll double precision,
    reporting_type character varying,
    number_of_employees integer,
    policy_transferred integer,
    transfer_creation_date date,
    process_payroll_all_transactions_breakdown_by_manual_class_id integer,
    payroll_origin character varying,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    manual_class_rate double precision,
    manual_class_transferred integer
);


--
-- Name: payroll_calculations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payroll_calculations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payroll_calculations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payroll_calculations_id_seq OWNED BY payroll_calculations.id;


--
-- Name: pcomb_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pcomb_detail_records (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    record_type integer,
    requestor_number integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    valid_policy_number character varying,
    policy_combinations character varying,
    predecessor_policy_type character varying,
    predecessor_policy_number integer,
    predecessor_filler character varying,
    predecessor_business_sequence_number character varying,
    successor_policy_type character varying,
    successor_policy_number integer,
    successor_filler character varying,
    successor_business_sequence_number character varying,
    transfer_type character varying,
    transfer_effective_date date,
    transfer_creation_date date,
    partial_transfer_due_to_labor_lease character varying,
    labor_lease_type character varying,
    partial_transfer_payroll_movement character varying,
    ncci_manual_number integer,
    manual_coverage_type character varying,
    payroll_reporting_period_from_date date,
    payroll_reporting_period_to_date date,
    manual_payroll double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pcomb_detail_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pcomb_detail_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pcomb_detail_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pcomb_detail_records_id_seq OWNED BY pcomb_detail_records.id;


--
-- Name: pcombs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pcombs (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: pcombs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pcombs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pcombs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pcombs_id_seq OWNED BY pcombs.id;


--
-- Name: pcovg_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pcovg_detail_records (
    id integer NOT NULL,
    representative_number integer,
    record_type integer,
    requestor_number integer,
    policy_number integer,
    business_sequence_number integer,
    valid_policy_number character varying,
    coverage_status character varying,
    coverage_status_effective_date date,
    coverage_status_end_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pcovg_detail_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pcovg_detail_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pcovg_detail_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pcovg_detail_records_id_seq OWNED BY pcovg_detail_records.id;


--
-- Name: pcovgs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pcovgs (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: pcovgs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pcovgs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pcovgs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pcovgs_id_seq OWNED BY pcovgs.id;


--
-- Name: pdemo_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pdemo_detail_records (
    id integer NOT NULL,
    representative_number integer,
    record_type integer,
    requestor_number integer,
    policy_number integer,
    business_sequence_number integer,
    valid_policy_number character varying,
    current_coverage_status character varying,
    coverage_status_effective_date date,
    federal_identification_number integer,
    business_name character varying,
    trading_as_name character varying,
    valid_mailing_address character varying,
    mailing_address_line_1 character varying,
    mailing_address_line_2 character varying,
    mailing_city character varying,
    mailing_state character varying,
    mailing_zip_code integer,
    mailing_zip_code_plus_4 integer,
    mailing_country_code integer,
    mailing_county integer,
    valid_location_address character varying,
    location_address_line_1 character varying,
    location_address_line_2 character varying,
    location_city character varying,
    location_state character varying,
    location_zip_code integer,
    location_zip_code_plus_4 integer,
    location_country_code integer,
    location_county integer,
    currently_assigned_clm_representative_number integer,
    currently_assigned_risk_representative_number integer,
    currently_assigned_erc_representative_number integer,
    currently_assigned_grc_representative_number integer,
    immediate_successor_policy_number integer,
    immediate_successor_business_sequence_number integer,
    ultimate_successor_policy_number integer,
    ultimate_successor_business_sequence_number integer,
    employer_type character varying,
    coverage_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pdemo_detail_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pdemo_detail_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pdemo_detail_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pdemo_detail_records_id_seq OWNED BY pdemo_detail_records.id;


--
-- Name: pdemos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pdemos (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: pdemos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pdemos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pdemos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pdemos_id_seq OWNED BY pdemos.id;


--
-- Name: pemh_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pemh_detail_records (
    id integer NOT NULL,
    representative_number integer,
    record_type integer,
    requestor_number integer,
    policy_number integer,
    business_sequence_number integer,
    valid_policy_number character varying,
    current_coverage_status character varying,
    coverage_status_effective_date date,
    experience_modifier_rate double precision,
    em_effective_date date,
    policy_year integer,
    reporting_period_start_date date,
    reporting_period_end_date date,
    group_participation_indicator character varying,
    group_code integer,
    group_type character varying,
    rrr_participation_indicator character varying,
    rrr_tier integer,
    rrr_policy_claim_limit integer,
    rrr_minimum_premium_percentage integer,
    deductible_participation_indicator character varying,
    deductible_level integer,
    deductible_stop_loss_indicator character varying,
    deductible_discount_percentage integer,
    ocp_participation_indicator character varying,
    ocp_participation integer,
    ocp_first_year_of_participation integer,
    grow_ohio_participation_indicator character varying,
    em_cap_participation_indicator character varying,
    drug_free_program_participation_indicator character varying,
    drug_free_program_type character varying,
    drug_free_program_participation_level character varying,
    drug_free_program_discount_eligiblity_indicator character varying,
    issp_participation_indicator character varying,
    issp_discount_eligibility_indicator character varying,
    twbns_participation_indicator character varying,
    twbns_discount_eligibility_indicator character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pemh_detail_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pemh_detail_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pemh_detail_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pemh_detail_records_id_seq OWNED BY pemh_detail_records.id;


--
-- Name: pemhs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pemhs (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: pemhs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pemhs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pemhs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pemhs_id_seq OWNED BY pemhs.id;


--
-- Name: phmgn_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE phmgn_detail_records (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    record_type integer,
    requestor_number integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    valid_policy_number character varying,
    experience_payroll_premium_information character varying,
    industry_code character varying,
    ncci_manual_number integer,
    manual_coverage_type character varying,
    manual_payroll double precision,
    manual_premium double precision,
    premium_percentage double precision,
    upcoming_policy_year integer,
    policy_year_extracted_for_experience_payroll_determining_premiu integer,
    policy_year_extracted_beginning_date date,
    policy_year_extracted_ending_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: phmgn_detail_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phmgn_detail_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phmgn_detail_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE phmgn_detail_records_id_seq OWNED BY phmgn_detail_records.id;


--
-- Name: phmgns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE phmgns (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: phmgns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phmgns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phmgns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE phmgns_id_seq OWNED BY phmgns.id;


--
-- Name: policy_calculations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE policy_calculations (
    id integer NOT NULL,
    representative_number integer,
    policy_number integer,
    policy_group_number character varying,
    policy_total_four_year_payroll double precision,
    policy_credibility_group integer,
    policy_maximum_claim_value integer,
    policy_credibility_percent double precision,
    policy_total_expected_losses double precision,
    policy_total_limited_losses double precision,
    policy_total_claims_count integer,
    policy_total_modified_losses_group_reduced double precision,
    policy_total_modified_losses_individual_reduced double precision,
    policy_group_ratio double precision,
    policy_individual_total_modifier double precision,
    policy_individual_experience_modified_rate double precision,
    policy_industry_group integer,
    policy_total_current_payroll double precision,
    policy_total_standard_premium double precision,
    policy_total_individual_premium double precision,
    currently_assigned_representative_number integer,
    valid_policy_number character varying,
    current_coverage_status character varying,
    coverage_status_effective_date date,
    policy_creation_date date,
    federal_identification_number character varying,
    business_name character varying,
    trading_as_name character varying,
    in_care_name_contact_name character varying,
    valid_mailing_address character varying,
    mailing_address_line_1 character varying,
    mailing_address_line_2 character varying,
    mailing_city character varying,
    mailing_state character varying,
    mailing_zip_code integer,
    mailing_zip_code_plus_4 integer,
    mailing_country_code integer,
    mailing_county integer,
    valid_location_address character varying,
    location_address_line_1 character varying,
    location_address_line_2 character varying,
    location_city character varying,
    location_state character varying,
    location_zip_code integer,
    location_zip_code_plus_4 integer,
    location_country_code integer,
    location_county integer,
    currently_assigned_clm_representative_number integer,
    currently_assigned_risk_representative_number integer,
    currently_assigned_erc_representative_number integer,
    currently_assigned_grc_representative_number integer,
    immediate_successor_policy_number integer,
    immediate_successor_business_sequence_number integer,
    ultimate_successor_policy_number integer,
    ultimate_successor_business_sequence_number integer,
    employer_type character varying,
    coverage_type character varying,
    policy_coverage_type character varying,
    policy_employer_type character varying,
    merit_rate double precision,
    group_code character varying,
    minimum_premium_percentage character varying,
    rate_adjust_factor character varying,
    em_effective_date date,
    regular_balance_amount double precision,
    attorney_general_balance_amount double precision,
    appealed_balance_amount double precision,
    pending_balance_amount double precision,
    advance_deposit_amount double precision,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    representative_id integer,
    account_id integer
);


--
-- Name: policy_calculations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE policy_calculations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: policy_calculations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE policy_calculations_id_seq OWNED BY policy_calculations.id;


--
-- Name: policy_coverage_status_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE policy_coverage_status_histories (
    id integer NOT NULL,
    policy_calculation_id integer,
    representative_id integer,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    coverage_effective_date date,
    coverage_end_date date,
    coverage_status character varying,
    lapse_days integer,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: policy_coverage_status_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE policy_coverage_status_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: policy_coverage_status_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE policy_coverage_status_histories_id_seq OWNED BY policy_coverage_status_histories.id;


--
-- Name: policy_program_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE policy_program_histories (
    id integer NOT NULL,
    policy_calculation_id integer,
    representative_id integer,
    representative_number integer,
    policy_number integer,
    business_sequence_number integer,
    experience_modifier_rate double precision,
    em_effective_date date,
    policy_year integer,
    reporting_period_start_date date,
    reporting_period_end_date date,
    group_participation_indicator character varying,
    group_code integer,
    group_type character varying,
    rrr_participation_indicator character varying,
    rrr_tier integer,
    rrr_policy_claim_limit integer,
    rrr_minimum_premium_percentage integer,
    deductible_participation_indicator character varying,
    deductible_level integer,
    deductible_stop_loss_indicator character varying,
    deductible_discount_percentage integer,
    ocp_participation_indicator character varying,
    ocp_participation integer,
    ocp_first_year_of_participation integer,
    grow_ohio_participation_indicator character varying,
    em_cap_participation_indicator character varying,
    drug_free_program_participation_indicator character varying,
    drug_free_program_type character varying,
    drug_free_program_participation_level character varying,
    drug_free_program_discount_eligiblity_indicator character varying,
    issp_participation_indicator character varying,
    issp_discount_eligibility_indicator character varying,
    twbns_participation_indicator character varying,
    twbns_discount_eligibility_indicator character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: policy_program_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE policy_program_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: policy_program_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE policy_program_histories_id_seq OWNED BY policy_program_histories.id;


--
-- Name: process_manual_class_four_year_payroll_with_conditions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE process_manual_class_four_year_payroll_with_conditions (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    manual_number integer,
    manual_class_type character varying,
    manual_class_four_year_period_payroll double precision,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: process_manual_class_four_year_payroll_with_conditions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE process_manual_class_four_year_payroll_with_conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: process_manual_class_four_year_payroll_with_conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE process_manual_class_four_year_payroll_with_conditions_id_seq OWNED BY process_manual_class_four_year_payroll_with_conditions.id;


--
-- Name: process_manual_class_four_year_payroll_without_conditions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE process_manual_class_four_year_payroll_without_conditions (
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    manual_number integer,
    manual_class_type character varying,
    manual_class_four_year_period_payroll double precision,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: process_manual_reclass_tables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE process_manual_reclass_tables (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    re_classed_from_manual_number integer,
    re_classed_to_manual_number integer,
    reclass_manual_coverage_type character varying,
    reclass_creation_date date,
    payroll_reporting_period_from_date date,
    payroll_reporting_period_to_date date,
    re_classed_to_manual_payroll_total double precision,
    payroll_origin character varying,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: process_manual_reclass_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE process_manual_reclass_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: process_manual_reclass_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE process_manual_reclass_tables_id_seq OWNED BY process_manual_reclass_tables.id;


--
-- Name: process_payroll_all_transactions_breakdown_by_manual_classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE process_payroll_all_transactions_breakdown_by_manual_classes (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    policy_status_effective_date date,
    policy_status character varying,
    manual_number integer,
    manual_class_type character varying,
    manual_class_description character varying,
    bwc_customer_id integer,
    reporting_period_start_date date,
    reporting_period_end_date date,
    manual_class_rate double precision,
    manual_class_payroll double precision,
    reporting_type character varying,
    number_of_employees integer,
    policy_transferred integer,
    transfer_creation_date date,
    payroll_origin character varying,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    manual_class_transferred integer
);


--
-- Name: process_payroll_all_transactions_breakdown_by_manual_cla_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE process_payroll_all_transactions_breakdown_by_manual_cla_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: process_payroll_all_transactions_breakdown_by_manual_cla_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE process_payroll_all_transactions_breakdown_by_manual_cla_id_seq OWNED BY process_payroll_all_transactions_breakdown_by_manual_classes.id;


--
-- Name: process_payroll_breakdown_by_manual_classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE process_payroll_breakdown_by_manual_classes (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    policy_status_effective_date date,
    policy_status character varying,
    manual_number integer,
    manual_class_type character varying,
    manual_class_description character varying,
    bwc_customer_id integer,
    reporting_period_start_date date,
    reporting_period_end_date date,
    manual_class_rate double precision,
    manual_class_payroll double precision,
    reporting_type character varying,
    number_of_employees integer,
    payroll_origin character varying,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    manual_class_transferred integer
);


--
-- Name: process_payroll_breakdown_by_manual_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE process_payroll_breakdown_by_manual_classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: process_payroll_breakdown_by_manual_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE process_payroll_breakdown_by_manual_classes_id_seq OWNED BY process_payroll_breakdown_by_manual_classes.id;


--
-- Name: process_policy_combination_lease_terminations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE process_policy_combination_lease_terminations (
    id integer NOT NULL,
    representative_number integer,
    valid_policy_number character varying,
    policy_combinations character varying,
    predecessor_policy_type character varying,
    predecessor_policy_number integer,
    successor_policy_type character varying,
    successor_policy_number integer,
    transfer_type character varying,
    transfer_effective_date date,
    transfer_creation_date date,
    partial_transfer_due_to_labor_lease character varying,
    labor_lease_type character varying,
    partial_transfer_payroll_movement character varying,
    ncci_manual_number integer,
    manual_coverage_type character varying,
    payroll_reporting_period_from_date date,
    payroll_reporting_period_to_date date,
    manual_payroll double precision,
    payroll_origin character varying,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: process_policy_combination_lease_terminations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE process_policy_combination_lease_terminations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: process_policy_combination_lease_terminations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE process_policy_combination_lease_terminations_id_seq OWNED BY process_policy_combination_lease_terminations.id;


--
-- Name: process_policy_combine_full_transfers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE process_policy_combine_full_transfers (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    manual_number integer,
    manual_class_type character varying,
    reporting_period_start_date date,
    reporting_period_end_date date,
    manual_class_rate double precision,
    manual_class_payroll double precision,
    manual_class_premium double precision,
    predecessor_policy_type character varying,
    predecessor_policy_number integer,
    successor_policy_type character varying,
    successor_policy_number integer,
    transfer_type character varying,
    transfer_effective_date date,
    transfer_creation_date date,
    payroll_origin character varying,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: process_policy_combine_full_transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE process_policy_combine_full_transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: process_policy_combine_full_transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE process_policy_combine_full_transfers_id_seq OWNED BY process_policy_combine_full_transfers.id;


--
-- Name: process_policy_combine_partial_to_full_leases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE process_policy_combine_partial_to_full_leases (
    id integer NOT NULL,
    representative_number integer,
    valid_policy_number character varying,
    policy_combinations character varying,
    predecessor_policy_type character varying,
    predecessor_policy_number integer,
    successor_policy_type character varying,
    successor_policy_number integer,
    transfer_type character varying,
    transfer_effective_date date,
    transfer_creation_date date,
    partial_transfer_due_to_labor_lease character varying,
    labor_lease_type character varying,
    partial_transfer_payroll_movement character varying,
    ncci_manual_number integer,
    manual_coverage_type character varying,
    payroll_reporting_period_from_date date,
    payroll_reporting_period_to_date date,
    manual_payroll double precision,
    payroll_origin character varying,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: process_policy_combine_partial_to_full_leases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE process_policy_combine_partial_to_full_leases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: process_policy_combine_partial_to_full_leases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE process_policy_combine_partial_to_full_leases_id_seq OWNED BY process_policy_combine_partial_to_full_leases.id;


--
-- Name: process_policy_combine_partial_transfer_no_leases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE process_policy_combine_partial_transfer_no_leases (
    id integer NOT NULL,
    representative_number integer,
    valid_policy_number character varying,
    policy_combinations character varying,
    predecessor_policy_type character varying,
    predecessor_policy_number integer,
    successor_policy_type character varying,
    successor_policy_number integer,
    transfer_type character varying,
    transfer_effective_date date,
    transfer_creation_date date,
    partial_transfer_due_to_labor_lease character varying,
    labor_lease_type character varying,
    partial_transfer_payroll_movement character varying,
    ncci_manual_number integer,
    manual_coverage_type character varying,
    payroll_reporting_period_from_date date,
    payroll_reporting_period_to_date date,
    manual_payroll double precision,
    payroll_origin character varying,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: process_policy_combine_partial_transfer_no_leases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE process_policy_combine_partial_transfer_no_leases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: process_policy_combine_partial_transfer_no_leases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE process_policy_combine_partial_transfer_no_leases_id_seq OWNED BY process_policy_combine_partial_transfer_no_leases.id;


--
-- Name: process_policy_coverage_status_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE process_policy_coverage_status_histories (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    coverage_effective_date date,
    coverage_end_date date,
    coverage_status character varying,
    lapse_days integer,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: process_policy_coverage_status_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE process_policy_coverage_status_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: process_policy_coverage_status_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE process_policy_coverage_status_histories_id_seq OWNED BY process_policy_coverage_status_histories.id;


--
-- Name: process_policy_experience_period_peos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE process_policy_experience_period_peos (
    id integer NOT NULL,
    representative_number integer,
    policy_type character varying,
    policy_number integer,
    manual_class_sf_peo_lease_effective_date date,
    manual_class_sf_peo_lease_termination_date date,
    manual_class_si_peo_lease_effective_date date,
    manual_class_si_peo_lease_termination_date date,
    data_source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: process_policy_experience_period_peos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE process_policy_experience_period_peos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: process_policy_experience_period_peos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE process_policy_experience_period_peos_id_seq OWNED BY process_policy_experience_period_peos.id;


--
-- Name: quotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE quotes (
    id integer NOT NULL,
    account_id integer,
    program_type integer,
    status integer,
    fees double precision,
    amount double precision,
    invoice_number character varying,
    quote_generated character varying,
    quote_date date,
    quote_sent_date date,
    effective_start_date date,
    effective_end_date date,
    ac2_signed_on date,
    ac26_signed_on date,
    u153_signed_on date,
    contract_signed_on date,
    questionnaire_signed_on date,
    invoice_signed_on date,
    group_code character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    questionnaire_question_1 boolean,
    questionnaire_question_2 boolean,
    questionnaire_question_3 boolean,
    questionnaire_question_4 boolean,
    questionnaire_question_5 boolean,
    quote character varying,
    quote_tier double precision,
    experience_period_lower_date date,
    experience_period_upper_date date,
    current_payroll_period_lower_date date,
    current_payroll_period_upper_date date,
    current_payroll_year integer,
    program_year_lower_date date,
    program_year_upper_date date,
    program_year integer,
    quote_year_lower_date date,
    quote_year_upper_date date,
    quote_year integer,
    paid_amount double precision,
    check_number character varying
);


--
-- Name: quotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quotes_id_seq OWNED BY quotes.id;


--
-- Name: rate_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE rate_detail_records (
    id integer NOT NULL,
    create_date date,
    representative_number integer,
    representative_name character varying,
    policy_number integer,
    business_sequence_number integer,
    policy_name character varying,
    tax_id integer,
    policy_status_effective_date date,
    policy_status character varying,
    reporting_period_start_date date,
    reporting_period_end_date date,
    manual_class integer,
    manual_class_type character varying,
    manual_class_description character varying,
    bwc_customer_id integer,
    individual_first_name character varying,
    individual_middle_name character varying,
    individual_last_name character varying,
    individual_tax_id integer,
    manual_class_rate double precision,
    reporting_type character varying,
    number_of_employees integer,
    payroll double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rate_detail_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rate_detail_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rate_detail_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rate_detail_records_id_seq OWNED BY rate_detail_records.id;


--
-- Name: rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE rates (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rates_id_seq OWNED BY rates.id;


--
-- Name: representatives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE representatives (
    id integer NOT NULL,
    representative_number integer,
    company_name character varying,
    abbreviated_name character varying,
    group_fees character varying,
    group_dues character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    logo character varying,
    zip_file character varying,
    experience_period_lower_date date,
    experience_period_upper_date date,
    current_payroll_period_lower_date date,
    current_payroll_period_upper_date date,
    current_payroll_year integer,
    program_year_lower_date date,
    program_year_upper_date date,
    program_year integer,
    quote_year_lower_date date,
    quote_year_upper_date date,
    quote_year integer
);


--
-- Name: representatives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE representatives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: representatives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE representatives_id_seq OWNED BY representatives.id;


--
-- Name: representatives_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE representatives_users (
    id integer NOT NULL,
    user_id integer,
    representative_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: representatives_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE representatives_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: representatives_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE representatives_users_id_seq OWNED BY representatives_users.id;


--
-- Name: sc220_rec1_employer_demographics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc220_rec1_employer_demographics (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    description_ar character varying,
    record_type integer,
    request_type integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    federal_identification_number character varying,
    business_name character varying,
    trading_as_name character varying,
    in_care_name_contact_name character varying,
    address_1 character varying,
    address_2 character varying,
    city character varying,
    state character varying,
    zip_code character varying,
    zip_code_plus_4 character varying,
    country_code character varying,
    county character varying,
    currently_assigned_representative_number integer,
    currently_assigned_representative_type character varying,
    successor_policy_number integer,
    successor_business_sequence_number integer,
    merit_rate double precision,
    group_code character varying,
    minimum_premium_percentage character varying,
    rate_adjust_factor character varying,
    em_effective_date date,
    n2nd_merit_rate double precision,
    n2nd_group_code character varying,
    n2nd_minimum_premium_percentage character varying,
    n2nd_rate_adjust_factor character varying,
    n2nd_em_effective_date date,
    n3rd_merit_rate double precision,
    n3rd_group_code character varying,
    n3rd_minimum_premium_percentage character varying,
    n3rd_rate_adjust_factor character varying,
    n3rd_em_effective_date date,
    n4th_merit_rate double precision,
    n4th_group_code character varying,
    n4th_minimum_premium_percentage character varying,
    n4th_rate_adjust_factor character varying,
    n4th_em_effective_date date,
    n5th_merit_rate double precision,
    n5th_group_code character varying,
    n5th_minimum_premium_percentage character varying,
    n5th_rate_adjust_factor character varying,
    n5th_em_effective_date date,
    n6th_merit_rate double precision,
    n6th_group_code character varying,
    n6th_minimum_premium_percentage character varying,
    n6th_rate_adjust_factor character varying,
    n6th_em_effective_date date,
    n7th_merit_rate double precision,
    n7th_group_code character varying,
    n7th_minimum_premium_percentage character varying,
    n7th_rate_adjust_factor character varying,
    n7th_em_effective_date date,
    n8th_merit_rate double precision,
    n8th_group_code character varying,
    n8th_minimum_premium_percentage character varying,
    n8th_rate_adjust_factor character varying,
    n8th_em_effective_date date,
    n9th_merit_rate double precision,
    n9th_group_code character varying,
    n9th_minimum_premium_percentage character varying,
    n9th_rate_adjust_factor character varying,
    n9th_em_effective_date date,
    n10th_merit_rate double precision,
    n10th_group_code character varying,
    n10th_minimum_premium_percentage character varying,
    n10th_rate_adjust_factor character varying,
    n10th_em_effective_date date,
    n11th_merit_rate double precision,
    n11th_group_code character varying,
    n11th_minimum_premium_percentage character varying,
    n11th_rate_adjust_factor character varying,
    n11th_em_effective_date date,
    n12th_merit_rate double precision,
    n12th_group_code character varying,
    n12th_minimum_premium_percentage character varying,
    n12th_rate_adjust_factor character varying,
    n12th_em_effective_date date,
    coverage_status character varying,
    coverage_effective_date date,
    coverage_end_date date,
    n2nd_coverage_status character varying,
    n2nd_coverage_effective_date date,
    n2nd_coverage_end_date date,
    n3rd_coverage_status character varying,
    n3rd_coverage_effective_date date,
    n3rd_coverage_end_date date,
    n4th_coverage_status character varying,
    n4th_coverage_effective_date date,
    n4th_coverage_end_date date,
    n5th_coverage_status character varying,
    n5th_coverage_effective_date date,
    n5th_coverage_end_date date,
    n6th_coverage_status character varying,
    n6th_coverage_effective_date date,
    n6th_coverage_end_date date,
    regular_balance_amount double precision,
    attorney_general_balance_amount double precision,
    appealed_balance_amount double precision,
    pending_balance_amount double precision,
    advance_deposit_amount double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc220_rec1_employer_demographics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc220_rec1_employer_demographics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc220_rec1_employer_demographics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc220_rec1_employer_demographics_id_seq OWNED BY sc220_rec1_employer_demographics.id;


--
-- Name: sc220_rec2_employer_manual_level_payrolls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc220_rec2_employer_manual_level_payrolls (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    description_ar character varying,
    record_type integer,
    request_type integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    manual_number integer,
    manual_type character varying,
    year_to_date_payroll double precision,
    manual_class_rate double precision,
    year_to_date_premium_billed double precision,
    manual_effective_date date,
    n2nd_year_to_date_payroll double precision,
    n2nd_manual_class_rate double precision,
    n2nd_year_to_date_premium_billed double precision,
    n2nd_manual_effective_date date,
    n3rd_year_to_date_payroll double precision,
    n3rd_manual_class_rate double precision,
    n3rd_year_to_date_premium_billed double precision,
    n3rd_manual_effective_date date,
    n4th_year_to_date_payroll double precision,
    n4th_manual_class_rate double precision,
    n4th_year_to_date_premium_billed double precision,
    n4th_manual_effective_date date,
    n5th_year_to_date_payroll double precision,
    n5th_manual_class_rate double precision,
    n5th_year_to_date_premium_billed double precision,
    n5th_manual_effective_date date,
    n6th_year_to_date_payroll double precision,
    n6th_manual_class_rate double precision,
    n6th_year_to_date_premium_billed double precision,
    n6th_manual_effective_date date,
    n7th_year_to_date_payroll double precision,
    n7th_manual_class_rate double precision,
    n7th_year_to_date_premium_billed double precision,
    n7th_manual_effective_date date,
    n8th_year_to_date_payroll double precision,
    n8th_manual_class_rate double precision,
    n8th_year_to_date_premium_billed double precision,
    n8th_manual_effective_date date,
    n9th_year_to_date_payroll double precision,
    n9th_manual_class_rate double precision,
    n9th_year_to_date_premium_billed double precision,
    n9th_manual_effective_date date,
    n10th_year_to_date_payroll double precision,
    n10th_manual_class_rate double precision,
    n10th_year_to_date_premium_billed double precision,
    n10th_manual_effective_date date,
    n11th_year_to_date_payroll double precision,
    n11th_manual_class_rate double precision,
    n11th_year_to_date_premium_billed double precision,
    n11th_manual_effective_date date,
    n12th_year_to_date_payroll double precision,
    n12th_manual_class_rate double precision,
    n12th_year_to_date_premium_billed double precision,
    n12th_manual_effective_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc220_rec2_employer_manual_level_payrolls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc220_rec2_employer_manual_level_payrolls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc220_rec2_employer_manual_level_payrolls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc220_rec2_employer_manual_level_payrolls_id_seq OWNED BY sc220_rec2_employer_manual_level_payrolls.id;


--
-- Name: sc220_rec3_employer_ar_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc220_rec3_employer_ar_transactions (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    descriptionar character varying,
    record_type integer,
    request_type integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    trans_date date,
    invoice_number character varying,
    billing_trans_status_code character varying,
    trans_amount double precision,
    trans_type character varying,
    paid_amount double precision,
    n2nd_trans_date date,
    n2nd_invoice_number character varying,
    n2nd_billing_trans_status_code character varying,
    n2nd_trans_amount double precision,
    n2nd_trans_type character varying,
    n2nd_paid_amount double precision,
    n3rd_trans_date date,
    n3rd_invoice_number character varying,
    n3rd_billing_trans_status_code character varying,
    n3rd_trans_amount double precision,
    n3rd_trans_type character varying,
    n3rd_paid_amount double precision,
    n4th_trans_date date,
    n4th_invoice_number character varying,
    n4th_billing_trans_status_code character varying,
    n4th_trans_amount double precision,
    n4th_trans_type character varying,
    n4th_paid_amount double precision,
    n5th_trans_date date,
    n5th_invoice_number character varying,
    n5th_billing_trans_status_code character varying,
    n5th_trans_amount double precision,
    n5th_trans_type character varying,
    n5th_paid_amount double precision,
    n6th_trans_date date,
    n6th_invoice_number character varying,
    n6th_billing_trans_status_code character varying,
    n6th_trans_amount double precision,
    n6th_trans_type character varying,
    n6th_paid_amount double precision,
    n7th_trans_date date,
    n7th_invoice_number character varying,
    n7th_billing_trans_status_code character varying,
    n7th_trans_amount double precision,
    n7th_trans_type character varying,
    n7th_paid_amount double precision,
    n8th_trans_date date,
    n8th_invoice_number character varying,
    n8th_billing_trans_status_code character varying,
    n8th_trans_amount double precision,
    n8th_trans_type character varying,
    n8th_paid_amount double precision,
    n9th_trans_date date,
    n9th_invoice_number character varying,
    n9th_billing_trans_status_code character varying,
    n9th_trans_amount double precision,
    n9th_trans_type character varying,
    n9th_paid_amount double precision,
    n10th_trans_date date,
    n10th_invoice_number character varying,
    n10th_billing_trans_status_code character varying,
    n10th_trans_amount double precision,
    n10th_trans_type character varying,
    n10th_paid_amount double precision,
    n11th_trans_date date,
    n11th_invoice_number character varying,
    n11th_billing_trans_status_code character varying,
    n11th_trans_amount double precision,
    n11th_trans_type character varying,
    n11th_paid_amount double precision,
    n12th_trans_date date,
    n12th_invoice_number character varying,
    n12th_billing_trans_status_code character varying,
    n12th_trans_amount double precision,
    n12th_trans_type character varying,
    n12th_paid_amount double precision,
    n13th_trans_date date,
    n13th_invoice_number character varying,
    n13th_billing_trans_status_code character varying,
    n13th_trans_amount double precision,
    n13th_trans_type character varying,
    n13th_paid_amount double precision,
    n14th_trans_date date,
    n14th_invoice_number character varying,
    n14th_billing_trans_status_code character varying,
    n14th_trans_amount double precision,
    n14th_trans_type character varying,
    n14th_paid_amount double precision,
    n15th_trans_date date,
    n15th_invoice_number character varying,
    n15th_billing_trans_status_code character varying,
    n15th_trans_amount double precision,
    n15th_trans_type character varying,
    n15th_paid_amount double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc220_rec3_employer_ar_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc220_rec3_employer_ar_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc220_rec3_employer_ar_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc220_rec3_employer_ar_transactions_id_seq OWNED BY sc220_rec3_employer_ar_transactions.id;


--
-- Name: sc220_rec4_policy_not_founds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc220_rec4_policy_not_founds (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    description character varying,
    record_type integer,
    request_type integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    error_message character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc220_rec4_policy_not_founds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc220_rec4_policy_not_founds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc220_rec4_policy_not_founds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc220_rec4_policy_not_founds_id_seq OWNED BY sc220_rec4_policy_not_founds.id;


--
-- Name: sc220s; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc220s (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: sc220s_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc220s_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc220s_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc220s_id_seq OWNED BY sc220s.id;


--
-- Name: sc230_claim_indemnity_awards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc230_claim_indemnity_awards (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    claim_manual_number integer,
    record_type character varying,
    claim_number character varying,
    hearing_date date,
    injury_date date,
    from_date date,
    to_date date,
    award_type character varying,
    number_of_weeks character varying,
    awarded_weekly_rate double precision,
    award_amount double precision,
    payment_amount integer,
    claimant_name character varying,
    payee_name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc230_claim_indemnity_awards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc230_claim_indemnity_awards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc230_claim_indemnity_awards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc230_claim_indemnity_awards_id_seq OWNED BY sc230_claim_indemnity_awards.id;


--
-- Name: sc230_claim_medical_payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc230_claim_medical_payments (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    claim_manual_number integer,
    record_type character varying,
    claim_number character varying,
    hearing_date date,
    injury_date date,
    from_date character varying,
    to_date character varying,
    award_type character varying,
    number_of_weeks character varying,
    awarded_weekly_rate character varying,
    award_amount integer,
    payment_amount double precision,
    claimant_name character varying,
    payee_name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc230_claim_medical_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc230_claim_medical_payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc230_claim_medical_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc230_claim_medical_payments_id_seq OWNED BY sc230_claim_medical_payments.id;


--
-- Name: sc230_employer_demographics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc230_employer_demographics (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    policy_type character varying,
    policy_number integer,
    business_sequence_number integer,
    claim_manual_number integer,
    record_type character varying,
    claim_number character varying,
    policy_name character varying,
    doing_business_as_name character varying,
    street_address character varying,
    city character varying,
    state character varying,
    zip_code integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc230_employer_demographics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc230_employer_demographics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc230_employer_demographics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc230_employer_demographics_id_seq OWNED BY sc230_employer_demographics.id;


--
-- Name: sc230s; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc230s (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: sc230s_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc230s_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc230s_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc230s_id_seq OWNED BY sc230s.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name character varying,
    last_name character varying,
    role integer DEFAULT 2
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object json,
    object_changes json,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_programs ALTER COLUMN id SET DEFAULT nextval('account_programs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts_affiliates ALTER COLUMN id SET DEFAULT nextval('accounts_affiliates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts_contacts ALTER COLUMN id SET DEFAULT nextval('accounts_contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY affiliates ALTER COLUMN id SET DEFAULT nextval('affiliates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_annual_manual_class_changes ALTER COLUMN id SET DEFAULT nextval('bwc_annual_manual_class_changes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_base_rates_exp_loss_rates ALTER COLUMN id SET DEFAULT nextval('bwc_codes_base_rates_exp_loss_rates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_constant_values ALTER COLUMN id SET DEFAULT nextval('bwc_codes_constant_values_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_credibility_max_losses ALTER COLUMN id SET DEFAULT nextval('bwc_codes_credibility_max_losses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_employer_representatives ALTER COLUMN id SET DEFAULT nextval('bwc_codes_employer_representatives_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_group_retro_tiers ALTER COLUMN id SET DEFAULT nextval('bwc_codes_group_retro_tiers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_industry_group_savings_ratio_criteria ALTER COLUMN id SET DEFAULT nextval('bwc_codes_industry_group_savings_ratio_criteria_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_limited_loss_ratios ALTER COLUMN id SET DEFAULT nextval('bwc_codes_limited_loss_ratios_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_ncci_manual_classes ALTER COLUMN id SET DEFAULT nextval('bwc_codes_ncci_manual_classes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_peo_lists ALTER COLUMN id SET DEFAULT nextval('bwc_codes_peo_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_policy_effective_dates ALTER COLUMN id SET DEFAULT nextval('bwc_codes_policy_effective_dates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_group_accept_reject_lists ALTER COLUMN id SET DEFAULT nextval('bwc_group_accept_reject_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY claim_calculations ALTER COLUMN id SET DEFAULT nextval('claim_calculations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY democ_detail_records ALTER COLUMN id SET DEFAULT nextval('democ_detail_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY democs ALTER COLUMN id SET DEFAULT nextval('democs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY exception_table_policy_combined_request_payroll_infos ALTER COLUMN id SET DEFAULT nextval('exception_table_policy_combined_request_payroll_infos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY final_claim_cost_calculation_tables ALTER COLUMN id SET DEFAULT nextval('final_claim_cost_calculation_tables_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY final_employer_demographics_informations ALTER COLUMN id SET DEFAULT nextval('final_employer_demographics_informations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY final_manual_class_four_year_payroll_and_exp_losses ALTER COLUMN id SET DEFAULT nextval('final_manual_class_four_year_payroll_and_exp_losses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY final_manual_class_group_rating_and_premium_projections ALTER COLUMN id SET DEFAULT nextval('final_manual_class_group_rating_and_premium_projections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY final_policy_experience_calculations ALTER COLUMN id SET DEFAULT nextval('final_policy_experience_calculations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY final_policy_group_rating_and_premium_projections ALTER COLUMN id SET DEFAULT nextval('final_policy_group_rating_and_premium_projections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_rating_exceptions ALTER COLUMN id SET DEFAULT nextval('group_rating_exceptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_rating_rejections ALTER COLUMN id SET DEFAULT nextval('group_rating_rejections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_ratings ALTER COLUMN id SET DEFAULT nextval('group_ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY imports ALTER COLUMN id SET DEFAULT nextval('imports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY manual_class_calculations ALTER COLUMN id SET DEFAULT nextval('manual_class_calculations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mrcl_detail_records ALTER COLUMN id SET DEFAULT nextval('mrcl_detail_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mrcls ALTER COLUMN id SET DEFAULT nextval('mrcls_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremp_employee_experience_claim_levels ALTER COLUMN id SET DEFAULT nextval('mremp_employee_experience_claim_levels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremp_employee_experience_manual_class_levels ALTER COLUMN id SET DEFAULT nextval('mremp_employee_experience_manual_class_levels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremp_employee_experience_policy_levels ALTER COLUMN id SET DEFAULT nextval('mremp_employee_experience_policy_levels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremps ALTER COLUMN id SET DEFAULT nextval('mremps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payroll_calculations ALTER COLUMN id SET DEFAULT nextval('payroll_calculations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcomb_detail_records ALTER COLUMN id SET DEFAULT nextval('pcomb_detail_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcombs ALTER COLUMN id SET DEFAULT nextval('pcombs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcovg_detail_records ALTER COLUMN id SET DEFAULT nextval('pcovg_detail_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcovgs ALTER COLUMN id SET DEFAULT nextval('pcovgs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pdemo_detail_records ALTER COLUMN id SET DEFAULT nextval('pdemo_detail_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pdemos ALTER COLUMN id SET DEFAULT nextval('pdemos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pemh_detail_records ALTER COLUMN id SET DEFAULT nextval('pemh_detail_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pemhs ALTER COLUMN id SET DEFAULT nextval('pemhs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY phmgn_detail_records ALTER COLUMN id SET DEFAULT nextval('phmgn_detail_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY phmgns ALTER COLUMN id SET DEFAULT nextval('phmgns_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY policy_calculations ALTER COLUMN id SET DEFAULT nextval('policy_calculations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY policy_coverage_status_histories ALTER COLUMN id SET DEFAULT nextval('policy_coverage_status_histories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY policy_program_histories ALTER COLUMN id SET DEFAULT nextval('policy_program_histories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_manual_class_four_year_payroll_with_conditions ALTER COLUMN id SET DEFAULT nextval('process_manual_class_four_year_payroll_with_conditions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_manual_reclass_tables ALTER COLUMN id SET DEFAULT nextval('process_manual_reclass_tables_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_payroll_all_transactions_breakdown_by_manual_classes ALTER COLUMN id SET DEFAULT nextval('process_payroll_all_transactions_breakdown_by_manual_cla_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_payroll_breakdown_by_manual_classes ALTER COLUMN id SET DEFAULT nextval('process_payroll_breakdown_by_manual_classes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_policy_combination_lease_terminations ALTER COLUMN id SET DEFAULT nextval('process_policy_combination_lease_terminations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_policy_combine_full_transfers ALTER COLUMN id SET DEFAULT nextval('process_policy_combine_full_transfers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_policy_combine_partial_to_full_leases ALTER COLUMN id SET DEFAULT nextval('process_policy_combine_partial_to_full_leases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_policy_combine_partial_transfer_no_leases ALTER COLUMN id SET DEFAULT nextval('process_policy_combine_partial_transfer_no_leases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_policy_coverage_status_histories ALTER COLUMN id SET DEFAULT nextval('process_policy_coverage_status_histories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_policy_experience_period_peos ALTER COLUMN id SET DEFAULT nextval('process_policy_experience_period_peos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quotes ALTER COLUMN id SET DEFAULT nextval('quotes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rate_detail_records ALTER COLUMN id SET DEFAULT nextval('rate_detail_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rates ALTER COLUMN id SET DEFAULT nextval('rates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY representatives ALTER COLUMN id SET DEFAULT nextval('representatives_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY representatives_users ALTER COLUMN id SET DEFAULT nextval('representatives_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec1_employer_demographics ALTER COLUMN id SET DEFAULT nextval('sc220_rec1_employer_demographics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec2_employer_manual_level_payrolls ALTER COLUMN id SET DEFAULT nextval('sc220_rec2_employer_manual_level_payrolls_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec3_employer_ar_transactions ALTER COLUMN id SET DEFAULT nextval('sc220_rec3_employer_ar_transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec4_policy_not_founds ALTER COLUMN id SET DEFAULT nextval('sc220_rec4_policy_not_founds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220s ALTER COLUMN id SET DEFAULT nextval('sc220s_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230_claim_indemnity_awards ALTER COLUMN id SET DEFAULT nextval('sc230_claim_indemnity_awards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230_claim_medical_payments ALTER COLUMN id SET DEFAULT nextval('sc230_claim_medical_payments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230_employer_demographics ALTER COLUMN id SET DEFAULT nextval('sc230_employer_demographics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230s ALTER COLUMN id SET DEFAULT nextval('sc230s_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: account_programs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_programs
    ADD CONSTRAINT account_programs_pkey PRIMARY KEY (id);


--
-- Name: accounts_affiliates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts_affiliates
    ADD CONSTRAINT accounts_affiliates_pkey PRIMARY KEY (id);


--
-- Name: accounts_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts_contacts
    ADD CONSTRAINT accounts_contacts_pkey PRIMARY KEY (id);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: affiliates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY affiliates
    ADD CONSTRAINT affiliates_pkey PRIMARY KEY (id);


--
-- Name: bwc_annual_manual_class_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_annual_manual_class_changes
    ADD CONSTRAINT bwc_annual_manual_class_changes_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_base_rates_exp_loss_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_base_rates_exp_loss_rates
    ADD CONSTRAINT bwc_codes_base_rates_exp_loss_rates_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_constant_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_constant_values
    ADD CONSTRAINT bwc_codes_constant_values_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_credibility_max_losses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_credibility_max_losses
    ADD CONSTRAINT bwc_codes_credibility_max_losses_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_employer_representatives_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_employer_representatives
    ADD CONSTRAINT bwc_codes_employer_representatives_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_group_retro_tiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_group_retro_tiers
    ADD CONSTRAINT bwc_codes_group_retro_tiers_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_industry_group_savings_ratio_criteria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_industry_group_savings_ratio_criteria
    ADD CONSTRAINT bwc_codes_industry_group_savings_ratio_criteria_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_limited_loss_ratios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_limited_loss_ratios
    ADD CONSTRAINT bwc_codes_limited_loss_ratios_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_ncci_manual_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_ncci_manual_classes
    ADD CONSTRAINT bwc_codes_ncci_manual_classes_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_peo_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_peo_lists
    ADD CONSTRAINT bwc_codes_peo_lists_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_policy_effective_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_policy_effective_dates
    ADD CONSTRAINT bwc_codes_policy_effective_dates_pkey PRIMARY KEY (id);


--
-- Name: bwc_group_accept_reject_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_group_accept_reject_lists
    ADD CONSTRAINT bwc_group_accept_reject_lists_pkey PRIMARY KEY (id);


--
-- Name: claim_calculations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY claim_calculations
    ADD CONSTRAINT claim_calculations_pkey PRIMARY KEY (id);


--
-- Name: contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: democ_detail_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY democ_detail_records
    ADD CONSTRAINT democ_detail_records_pkey PRIMARY KEY (id);


--
-- Name: democs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY democs
    ADD CONSTRAINT democs_pkey PRIMARY KEY (id);


--
-- Name: exception_table_policy_combined_request_payroll_infos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY exception_table_policy_combined_request_payroll_infos
    ADD CONSTRAINT exception_table_policy_combined_request_payroll_infos_pkey PRIMARY KEY (id);


--
-- Name: final_claim_cost_calculation_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY final_claim_cost_calculation_tables
    ADD CONSTRAINT final_claim_cost_calculation_tables_pkey PRIMARY KEY (id);


--
-- Name: final_employer_demographics_informations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY final_employer_demographics_informations
    ADD CONSTRAINT final_employer_demographics_informations_pkey PRIMARY KEY (id);


--
-- Name: final_manual_class_four_year_payroll_and_exp_losses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY final_manual_class_four_year_payroll_and_exp_losses
    ADD CONSTRAINT final_manual_class_four_year_payroll_and_exp_losses_pkey PRIMARY KEY (id);


--
-- Name: final_manual_class_group_rating_and_premium_projections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY final_manual_class_group_rating_and_premium_projections
    ADD CONSTRAINT final_manual_class_group_rating_and_premium_projections_pkey PRIMARY KEY (id);


--
-- Name: final_policy_experience_calculations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY final_policy_experience_calculations
    ADD CONSTRAINT final_policy_experience_calculations_pkey PRIMARY KEY (id);


--
-- Name: final_policy_group_rating_and_premium_projections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY final_policy_group_rating_and_premium_projections
    ADD CONSTRAINT final_policy_group_rating_and_premium_projections_pkey PRIMARY KEY (id);


--
-- Name: group_rating_exceptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_rating_exceptions
    ADD CONSTRAINT group_rating_exceptions_pkey PRIMARY KEY (id);


--
-- Name: group_rating_rejections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_rating_rejections
    ADD CONSTRAINT group_rating_rejections_pkey PRIMARY KEY (id);


--
-- Name: group_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_ratings
    ADD CONSTRAINT group_ratings_pkey PRIMARY KEY (id);


--
-- Name: imports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY imports
    ADD CONSTRAINT imports_pkey PRIMARY KEY (id);


--
-- Name: manual_class_calculations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY manual_class_calculations
    ADD CONSTRAINT manual_class_calculations_pkey PRIMARY KEY (id);


--
-- Name: mrcl_detail_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mrcl_detail_records
    ADD CONSTRAINT mrcl_detail_records_pkey PRIMARY KEY (id);


--
-- Name: mrcls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mrcls
    ADD CONSTRAINT mrcls_pkey PRIMARY KEY (id);


--
-- Name: mremp_employee_experience_claim_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremp_employee_experience_claim_levels
    ADD CONSTRAINT mremp_employee_experience_claim_levels_pkey PRIMARY KEY (id);


--
-- Name: mremp_employee_experience_manual_class_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremp_employee_experience_manual_class_levels
    ADD CONSTRAINT mremp_employee_experience_manual_class_levels_pkey PRIMARY KEY (id);


--
-- Name: mremp_employee_experience_policy_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremp_employee_experience_policy_levels
    ADD CONSTRAINT mremp_employee_experience_policy_levels_pkey PRIMARY KEY (id);


--
-- Name: mremps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremps
    ADD CONSTRAINT mremps_pkey PRIMARY KEY (id);


--
-- Name: payroll_calculations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY payroll_calculations
    ADD CONSTRAINT payroll_calculations_pkey PRIMARY KEY (id);


--
-- Name: pcomb_detail_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcomb_detail_records
    ADD CONSTRAINT pcomb_detail_records_pkey PRIMARY KEY (id);


--
-- Name: pcombs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcombs
    ADD CONSTRAINT pcombs_pkey PRIMARY KEY (id);


--
-- Name: pcovg_detail_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcovg_detail_records
    ADD CONSTRAINT pcovg_detail_records_pkey PRIMARY KEY (id);


--
-- Name: pcovgs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcovgs
    ADD CONSTRAINT pcovgs_pkey PRIMARY KEY (id);


--
-- Name: pdemo_detail_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pdemo_detail_records
    ADD CONSTRAINT pdemo_detail_records_pkey PRIMARY KEY (id);


--
-- Name: pdemos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pdemos
    ADD CONSTRAINT pdemos_pkey PRIMARY KEY (id);


--
-- Name: pemh_detail_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pemh_detail_records
    ADD CONSTRAINT pemh_detail_records_pkey PRIMARY KEY (id);


--
-- Name: pemhs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pemhs
    ADD CONSTRAINT pemhs_pkey PRIMARY KEY (id);


--
-- Name: phmgn_detail_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY phmgn_detail_records
    ADD CONSTRAINT phmgn_detail_records_pkey PRIMARY KEY (id);


--
-- Name: phmgns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY phmgns
    ADD CONSTRAINT phmgns_pkey PRIMARY KEY (id);


--
-- Name: policy_calculations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY policy_calculations
    ADD CONSTRAINT policy_calculations_pkey PRIMARY KEY (id);


--
-- Name: policy_coverage_status_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY policy_coverage_status_histories
    ADD CONSTRAINT policy_coverage_status_histories_pkey PRIMARY KEY (id);


--
-- Name: policy_program_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY policy_program_histories
    ADD CONSTRAINT policy_program_histories_pkey PRIMARY KEY (id);


--
-- Name: process_manual_class_four_year_payroll_with_conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_manual_class_four_year_payroll_with_conditions
    ADD CONSTRAINT process_manual_class_four_year_payroll_with_conditions_pkey PRIMARY KEY (id);


--
-- Name: process_manual_reclass_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_manual_reclass_tables
    ADD CONSTRAINT process_manual_reclass_tables_pkey PRIMARY KEY (id);


--
-- Name: process_payroll_all_transactions_breakdown_by_manual_class_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_payroll_all_transactions_breakdown_by_manual_classes
    ADD CONSTRAINT process_payroll_all_transactions_breakdown_by_manual_class_pkey PRIMARY KEY (id);


--
-- Name: process_payroll_breakdown_by_manual_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_payroll_breakdown_by_manual_classes
    ADD CONSTRAINT process_payroll_breakdown_by_manual_classes_pkey PRIMARY KEY (id);


--
-- Name: process_policy_combination_lease_terminations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_policy_combination_lease_terminations
    ADD CONSTRAINT process_policy_combination_lease_terminations_pkey PRIMARY KEY (id);


--
-- Name: process_policy_combine_full_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_policy_combine_full_transfers
    ADD CONSTRAINT process_policy_combine_full_transfers_pkey PRIMARY KEY (id);


--
-- Name: process_policy_combine_partial_to_full_leases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_policy_combine_partial_to_full_leases
    ADD CONSTRAINT process_policy_combine_partial_to_full_leases_pkey PRIMARY KEY (id);


--
-- Name: process_policy_combine_partial_transfer_no_leases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_policy_combine_partial_transfer_no_leases
    ADD CONSTRAINT process_policy_combine_partial_transfer_no_leases_pkey PRIMARY KEY (id);


--
-- Name: process_policy_coverage_status_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_policy_coverage_status_histories
    ADD CONSTRAINT process_policy_coverage_status_histories_pkey PRIMARY KEY (id);


--
-- Name: process_policy_experience_period_peos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY process_policy_experience_period_peos
    ADD CONSTRAINT process_policy_experience_period_peos_pkey PRIMARY KEY (id);


--
-- Name: quotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY quotes
    ADD CONSTRAINT quotes_pkey PRIMARY KEY (id);


--
-- Name: rate_detail_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rate_detail_records
    ADD CONSTRAINT rate_detail_records_pkey PRIMARY KEY (id);


--
-- Name: rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rates
    ADD CONSTRAINT rates_pkey PRIMARY KEY (id);


--
-- Name: representatives_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY representatives
    ADD CONSTRAINT representatives_pkey PRIMARY KEY (id);


--
-- Name: representatives_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY representatives_users
    ADD CONSTRAINT representatives_users_pkey PRIMARY KEY (id);


--
-- Name: sc220_rec1_employer_demographics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec1_employer_demographics
    ADD CONSTRAINT sc220_rec1_employer_demographics_pkey PRIMARY KEY (id);


--
-- Name: sc220_rec2_employer_manual_level_payrolls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec2_employer_manual_level_payrolls
    ADD CONSTRAINT sc220_rec2_employer_manual_level_payrolls_pkey PRIMARY KEY (id);


--
-- Name: sc220_rec3_employer_ar_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec3_employer_ar_transactions
    ADD CONSTRAINT sc220_rec3_employer_ar_transactions_pkey PRIMARY KEY (id);


--
-- Name: sc220_rec4_policy_not_founds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec4_policy_not_founds
    ADD CONSTRAINT sc220_rec4_policy_not_founds_pkey PRIMARY KEY (id);


--
-- Name: sc220s_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220s
    ADD CONSTRAINT sc220s_pkey PRIMARY KEY (id);


--
-- Name: sc230_claim_indemnity_awards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230_claim_indemnity_awards
    ADD CONSTRAINT sc230_claim_indemnity_awards_pkey PRIMARY KEY (id);


--
-- Name: sc230_claim_medical_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230_claim_medical_payments
    ADD CONSTRAINT sc230_claim_medical_payments_pkey PRIMARY KEY (id);


--
-- Name: sc230_employer_demographics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230_employer_demographics
    ADD CONSTRAINT sc230_employer_demographics_pkey PRIMARY KEY (id);


--
-- Name: sc230s_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230s
    ADD CONSTRAINT sc230s_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: index_account_programs_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_programs_on_account_id ON account_programs USING btree (account_id);


--
-- Name: index_accounts_affiliates_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_affiliates_on_account_id ON accounts_affiliates USING btree (account_id);


--
-- Name: index_accounts_affiliates_on_affiliate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_affiliates_on_affiliate_id ON accounts_affiliates USING btree (affiliate_id);


--
-- Name: index_accounts_contacts_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_contacts_on_account_id ON accounts_contacts USING btree (account_id);


--
-- Name: index_accounts_contacts_on_contact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_contacts_on_contact_id ON accounts_contacts USING btree (contact_id);


--
-- Name: index_accounts_on_representative_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_representative_id ON accounts USING btree (representative_id);


--
-- Name: index_affiliates_on_representative_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_affiliates_on_representative_id ON affiliates USING btree (representative_id);


--
-- Name: index_bwc_codes_policy_effective_dates_on_policy_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bwc_codes_policy_effective_dates_on_policy_number ON bwc_codes_policy_effective_dates USING btree (policy_number);


--
-- Name: index_cl_pol_num_and_rep; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cl_pol_num_and_rep ON final_claim_cost_calculation_tables USING btree (policy_number, representative_number);


--
-- Name: index_claim_calc_on_pol_num_and_claim_num; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_claim_calc_on_pol_num_and_claim_num ON claim_calculations USING btree (policy_number, claim_number);


--
-- Name: index_claim_calculations_on_policy_calculation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_claim_calculations_on_policy_calculation_id ON claim_calculations USING btree (policy_calculation_id);


--
-- Name: index_emp_demo_pol_num_and_man_num; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_emp_demo_pol_num_and_man_num ON final_employer_demographics_informations USING btree (policy_number, representative_number);


--
-- Name: index_fin_man_pr_pol_num_and_man_num_rep; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fin_man_pr_pol_num_and_man_num_rep ON final_manual_class_group_rating_and_premium_projections USING btree (policy_number, manual_number, representative_number);


--
-- Name: index_group_rating_exceptions_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_rating_exceptions_on_account_id ON group_rating_exceptions USING btree (account_id);


--
-- Name: index_group_rating_exceptions_on_representative_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_rating_exceptions_on_representative_id ON group_rating_exceptions USING btree (representative_id);


--
-- Name: index_group_rating_rejections_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_rating_rejections_on_account_id ON group_rating_rejections USING btree (account_id);


--
-- Name: index_group_rating_rejections_on_representative_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_rating_rejections_on_representative_id ON group_rating_rejections USING btree (representative_id);


--
-- Name: index_group_ratings_on_representative_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_ratings_on_representative_id ON group_ratings USING btree (representative_id);


--
-- Name: index_imports_on_group_rating_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_imports_on_group_rating_id ON imports USING btree (group_rating_id);


--
-- Name: index_imports_on_representative_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_imports_on_representative_id ON imports USING btree (representative_id);


--
-- Name: index_man_class_calc_pol_num_and_man_num; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_man_class_calc_pol_num_and_man_num ON manual_class_calculations USING btree (policy_number, manual_number);


--
-- Name: index_man_pr_pol_num_and_man_num_rep; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_man_pr_pol_num_and_man_num_rep ON final_manual_class_four_year_payroll_and_exp_losses USING btree (policy_number, manual_number, representative_number);


--
-- Name: index_manual_class_calculations_on_policy_calculation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_manual_class_calculations_on_policy_calculation_id ON manual_class_calculations USING btree (policy_calculation_id);


--
-- Name: index_payroll_calc_on_pol_num_and_man_num; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payroll_calc_on_pol_num_and_man_num ON payroll_calculations USING btree (policy_number, manual_number);


--
-- Name: index_payroll_calculations_on_manual_class_calculation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payroll_calculations_on_manual_class_calculation_id ON payroll_calculations USING btree (manual_class_calculation_id);


--
-- Name: index_pol_exp_pol_num_and_man_num_rep; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pol_exp_pol_num_and_man_num_rep ON final_policy_experience_calculations USING btree (policy_number, representative_number);


--
-- Name: index_pol_prem_pol_num_and_rep; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pol_prem_pol_num_and_rep ON final_policy_group_rating_and_premium_projections USING btree (policy_number, representative_number);


--
-- Name: index_policy_calculations_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policy_calculations_on_account_id ON policy_calculations USING btree (account_id);


--
-- Name: index_policy_calculations_on_pol_num; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policy_calculations_on_pol_num ON policy_calculations USING btree (policy_number);


--
-- Name: index_policy_calculations_on_representative_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policy_calculations_on_representative_id ON policy_calculations USING btree (representative_id);


--
-- Name: index_policy_coverage_status_histories_on_policy_calculation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policy_coverage_status_histories_on_policy_calculation_id ON policy_coverage_status_histories USING btree (policy_calculation_id);


--
-- Name: index_policy_coverage_status_histories_on_representative_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policy_coverage_status_histories_on_representative_id ON policy_coverage_status_histories USING btree (representative_id);


--
-- Name: index_policy_program_histories_on_policy_calculation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policy_program_histories_on_policy_calculation_id ON policy_program_histories USING btree (policy_calculation_id);


--
-- Name: index_policy_program_histories_on_representative_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policy_program_histories_on_representative_id ON policy_program_histories USING btree (representative_id);


--
-- Name: index_pr_pol_num_and_man_num_rep; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pr_pol_num_and_man_num_rep ON process_payroll_all_transactions_breakdown_by_manual_classes USING btree (policy_number, manual_number, representative_number);


--
-- Name: index_proc_pr_by_man_cl_on_pol_and_man_rep; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_proc_pr_by_man_cl_on_pol_and_man_rep ON process_payroll_breakdown_by_manual_classes USING btree (policy_number, manual_number, representative_number);


--
-- Name: index_process_policy_coverage_status_histories_on_policy_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_process_policy_coverage_status_histories_on_policy_number ON process_policy_coverage_status_histories USING btree (policy_number);


--
-- Name: index_process_policy_experience_period_peos_on_policy_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_process_policy_experience_period_peos_on_policy_number ON process_policy_experience_period_peos USING btree (policy_number);


--
-- Name: index_quotes_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_account_id ON quotes USING btree (account_id);


--
-- Name: index_representatives_users_on_representative_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_representatives_users_on_representative_id ON representatives_users USING btree (representative_id);


--
-- Name: index_representatives_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_representatives_users_on_user_id ON representatives_users USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_040ed49e64; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY manual_class_calculations
    ADD CONSTRAINT fk_rails_040ed49e64 FOREIGN KEY (policy_calculation_id) REFERENCES policy_calculations(id);


--
-- Name: fk_rails_05a693ad72; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT fk_rails_05a693ad72 FOREIGN KEY (representative_id) REFERENCES representatives(id);


--
-- Name: fk_rails_0b4b078a08; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY representatives_users
    ADD CONSTRAINT fk_rails_0b4b078a08 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_0c7708bfbc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY payroll_calculations
    ADD CONSTRAINT fk_rails_0c7708bfbc FOREIGN KEY (manual_class_calculation_id) REFERENCES manual_class_calculations(id);


--
-- Name: fk_rails_1706ec48e7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY imports
    ADD CONSTRAINT fk_rails_1706ec48e7 FOREIGN KEY (representative_id) REFERENCES representatives(id);


--
-- Name: fk_rails_19f9bc6433; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts_affiliates
    ADD CONSTRAINT fk_rails_19f9bc6433 FOREIGN KEY (affiliate_id) REFERENCES affiliates(id);


--
-- Name: fk_rails_1e80e7d41e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY policy_program_histories
    ADD CONSTRAINT fk_rails_1e80e7d41e FOREIGN KEY (policy_calculation_id) REFERENCES policy_calculations(id);


--
-- Name: fk_rails_216ba210c3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts_contacts
    ADD CONSTRAINT fk_rails_216ba210c3 FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: fk_rails_23828ba563; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts_contacts
    ADD CONSTRAINT fk_rails_23828ba563 FOREIGN KEY (contact_id) REFERENCES contacts(id);


--
-- Name: fk_rails_2fcfb189de; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts_affiliates
    ADD CONSTRAINT fk_rails_2fcfb189de FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: fk_rails_35addb0042; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_ratings
    ADD CONSTRAINT fk_rails_35addb0042 FOREIGN KEY (representative_id) REFERENCES representatives(id);


--
-- Name: fk_rails_36d54169fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY quotes
    ADD CONSTRAINT fk_rails_36d54169fc FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: fk_rails_3fd03272a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY policy_calculations
    ADD CONSTRAINT fk_rails_3fd03272a6 FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: fk_rails_4b61f12937; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_programs
    ADD CONSTRAINT fk_rails_4b61f12937 FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: fk_rails_8b39e94061; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY imports
    ADD CONSTRAINT fk_rails_8b39e94061 FOREIGN KEY (group_rating_id) REFERENCES group_ratings(id);


--
-- Name: fk_rails_96963e09a8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY policy_program_histories
    ADD CONSTRAINT fk_rails_96963e09a8 FOREIGN KEY (representative_id) REFERENCES representatives(id);


--
-- Name: fk_rails_ab01499540; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY representatives_users
    ADD CONSTRAINT fk_rails_ab01499540 FOREIGN KEY (representative_id) REFERENCES representatives(id);


--
-- Name: fk_rails_bba45d7002; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_rating_rejections
    ADD CONSTRAINT fk_rails_bba45d7002 FOREIGN KEY (representative_id) REFERENCES representatives(id);


--
-- Name: fk_rails_bd17fdc162; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_rating_exceptions
    ADD CONSTRAINT fk_rails_bd17fdc162 FOREIGN KEY (representative_id) REFERENCES representatives(id);


--
-- Name: fk_rails_d66971042d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY policy_coverage_status_histories
    ADD CONSTRAINT fk_rails_d66971042d FOREIGN KEY (policy_calculation_id) REFERENCES policy_calculations(id);


--
-- Name: fk_rails_ee74209c96; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY affiliates
    ADD CONSTRAINT fk_rails_ee74209c96 FOREIGN KEY (representative_id) REFERENCES representatives(id);


--
-- Name: fk_rails_f4817e19cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_rating_rejections
    ADD CONSTRAINT fk_rails_f4817e19cc FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: fk_rails_f48992ad9e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY claim_calculations
    ADD CONSTRAINT fk_rails_f48992ad9e FOREIGN KEY (policy_calculation_id) REFERENCES policy_calculations(id);


--
-- Name: fk_rails_fb29362929; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_rating_exceptions
    ADD CONSTRAINT fk_rails_fb29362929 FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: fk_rails_fc6071f47a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY policy_coverage_status_histories
    ADD CONSTRAINT fk_rails_fc6071f47a FOREIGN KEY (representative_id) REFERENCES representatives(id);


--
-- Name: fk_rails_fd78fc6eb3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY policy_calculations
    ADD CONSTRAINT fk_rails_fd78fc6eb3 FOREIGN KEY (representative_id) REFERENCES representatives(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20160728185130');

INSERT INTO schema_migrations (version) VALUES ('20160802135624');

INSERT INTO schema_migrations (version) VALUES ('20160808140315');

INSERT INTO schema_migrations (version) VALUES ('20160808140430');

INSERT INTO schema_migrations (version) VALUES ('20160808140646');

INSERT INTO schema_migrations (version) VALUES ('20160808140724');

INSERT INTO schema_migrations (version) VALUES ('20160808140739');

INSERT INTO schema_migrations (version) VALUES ('20160808140800');

INSERT INTO schema_migrations (version) VALUES ('20160808184958');

INSERT INTO schema_migrations (version) VALUES ('20160809110941');

INSERT INTO schema_migrations (version) VALUES ('20160809113231');

INSERT INTO schema_migrations (version) VALUES ('20160809113754');

INSERT INTO schema_migrations (version) VALUES ('20160809125215');

INSERT INTO schema_migrations (version) VALUES ('20160809131406');

INSERT INTO schema_migrations (version) VALUES ('20160809134044');

INSERT INTO schema_migrations (version) VALUES ('20160809142452');

INSERT INTO schema_migrations (version) VALUES ('20160809144921');

INSERT INTO schema_migrations (version) VALUES ('20160809151108');

INSERT INTO schema_migrations (version) VALUES ('20160809155448');

INSERT INTO schema_migrations (version) VALUES ('20160809160103');

INSERT INTO schema_migrations (version) VALUES ('20160809160550');

INSERT INTO schema_migrations (version) VALUES ('20160810174935');

INSERT INTO schema_migrations (version) VALUES ('20160811100413');

INSERT INTO schema_migrations (version) VALUES ('20160811112748');

INSERT INTO schema_migrations (version) VALUES ('20160811115912');

INSERT INTO schema_migrations (version) VALUES ('20160811124541');

INSERT INTO schema_migrations (version) VALUES ('20160811125428');

INSERT INTO schema_migrations (version) VALUES ('20160811134525');

INSERT INTO schema_migrations (version) VALUES ('20160811143921');

INSERT INTO schema_migrations (version) VALUES ('20160814173856');

INSERT INTO schema_migrations (version) VALUES ('20160814175421');

INSERT INTO schema_migrations (version) VALUES ('20160814175816');

INSERT INTO schema_migrations (version) VALUES ('20160814175945');

INSERT INTO schema_migrations (version) VALUES ('20160814180111');

INSERT INTO schema_migrations (version) VALUES ('20160814180310');

INSERT INTO schema_migrations (version) VALUES ('20160814180427');

INSERT INTO schema_migrations (version) VALUES ('20160814180652');

INSERT INTO schema_migrations (version) VALUES ('20160814183144');

INSERT INTO schema_migrations (version) VALUES ('20160814184044');

INSERT INTO schema_migrations (version) VALUES ('20160814184408');

INSERT INTO schema_migrations (version) VALUES ('20160814184901');

INSERT INTO schema_migrations (version) VALUES ('20160814190226');

INSERT INTO schema_migrations (version) VALUES ('20160814190350');

INSERT INTO schema_migrations (version) VALUES ('20160814191259');

INSERT INTO schema_migrations (version) VALUES ('20160814191446');

INSERT INTO schema_migrations (version) VALUES ('20160814191649');

INSERT INTO schema_migrations (version) VALUES ('20160814191839');

INSERT INTO schema_migrations (version) VALUES ('20160814192036');

INSERT INTO schema_migrations (version) VALUES ('20160814192236');

INSERT INTO schema_migrations (version) VALUES ('20160814192355');

INSERT INTO schema_migrations (version) VALUES ('20160814192453');

INSERT INTO schema_migrations (version) VALUES ('20160814192538');

INSERT INTO schema_migrations (version) VALUES ('20160814192804');

INSERT INTO schema_migrations (version) VALUES ('20160814193131');

INSERT INTO schema_migrations (version) VALUES ('20160814193318');

INSERT INTO schema_migrations (version) VALUES ('20160815131855');

INSERT INTO schema_migrations (version) VALUES ('20160815135347');

INSERT INTO schema_migrations (version) VALUES ('20160815205101');

INSERT INTO schema_migrations (version) VALUES ('20160816120630');

INSERT INTO schema_migrations (version) VALUES ('20160816143616');

INSERT INTO schema_migrations (version) VALUES ('20160816154538');

INSERT INTO schema_migrations (version) VALUES ('20160816160133');

INSERT INTO schema_migrations (version) VALUES ('20160816164855');

INSERT INTO schema_migrations (version) VALUES ('20160816170044');

INSERT INTO schema_migrations (version) VALUES ('20160816180824');

INSERT INTO schema_migrations (version) VALUES ('20160816182146');

INSERT INTO schema_migrations (version) VALUES ('20160822105403');

INSERT INTO schema_migrations (version) VALUES ('20160823184229');

INSERT INTO schema_migrations (version) VALUES ('20160829130503');

INSERT INTO schema_migrations (version) VALUES ('20160830140433');

INSERT INTO schema_migrations (version) VALUES ('20160831122718');

INSERT INTO schema_migrations (version) VALUES ('20160902120955');

INSERT INTO schema_migrations (version) VALUES ('20160902121250');

INSERT INTO schema_migrations (version) VALUES ('20160902121319');

INSERT INTO schema_migrations (version) VALUES ('20160926143428');

INSERT INTO schema_migrations (version) VALUES ('20160926150157');

INSERT INTO schema_migrations (version) VALUES ('20161010135709');

INSERT INTO schema_migrations (version) VALUES ('20161010144227');

INSERT INTO schema_migrations (version) VALUES ('20161020184006');

INSERT INTO schema_migrations (version) VALUES ('20161020184132');

INSERT INTO schema_migrations (version) VALUES ('20161020184549');

INSERT INTO schema_migrations (version) VALUES ('20161031172343');

INSERT INTO schema_migrations (version) VALUES ('20161031191723');

INSERT INTO schema_migrations (version) VALUES ('20161031191940');

INSERT INTO schema_migrations (version) VALUES ('20161101161501');

INSERT INTO schema_migrations (version) VALUES ('20161121192918');

INSERT INTO schema_migrations (version) VALUES ('20161205121232');

INSERT INTO schema_migrations (version) VALUES ('20161205122049');

INSERT INTO schema_migrations (version) VALUES ('20161205130251');

INSERT INTO schema_migrations (version) VALUES ('20161205152859');

INSERT INTO schema_migrations (version) VALUES ('20161205152952');

INSERT INTO schema_migrations (version) VALUES ('20161205154857');

INSERT INTO schema_migrations (version) VALUES ('20161205181316');

INSERT INTO schema_migrations (version) VALUES ('20161205181412');

INSERT INTO schema_migrations (version) VALUES ('20161205181641');

INSERT INTO schema_migrations (version) VALUES ('20161205190813');

INSERT INTO schema_migrations (version) VALUES ('20161206001323');

INSERT INTO schema_migrations (version) VALUES ('20161212084959');

INSERT INTO schema_migrations (version) VALUES ('20161212085100');

INSERT INTO schema_migrations (version) VALUES ('20161212085207');

INSERT INTO schema_migrations (version) VALUES ('20161212085259');

INSERT INTO schema_migrations (version) VALUES ('20161212085537');

INSERT INTO schema_migrations (version) VALUES ('20161212090511');

INSERT INTO schema_migrations (version) VALUES ('20161212143541');

INSERT INTO schema_migrations (version) VALUES ('20161212145717');

INSERT INTO schema_migrations (version) VALUES ('20161212160309');

INSERT INTO schema_migrations (version) VALUES ('20161212162433');

INSERT INTO schema_migrations (version) VALUES ('20161212202044');

INSERT INTO schema_migrations (version) VALUES ('20161220120712');

INSERT INTO schema_migrations (version) VALUES ('20161227211225');

INSERT INTO schema_migrations (version) VALUES ('20170104152306');

INSERT INTO schema_migrations (version) VALUES ('20170117124243');

INSERT INTO schema_migrations (version) VALUES ('20170117135428');

INSERT INTO schema_migrations (version) VALUES ('20170119161701');

INSERT INTO schema_migrations (version) VALUES ('20170120191100');

INSERT INTO schema_migrations (version) VALUES ('20170125140530');

INSERT INTO schema_migrations (version) VALUES ('20170125160723');

INSERT INTO schema_migrations (version) VALUES ('20170223191826');

INSERT INTO schema_migrations (version) VALUES ('20170224151532');

INSERT INTO schema_migrations (version) VALUES ('20170228154737');

INSERT INTO schema_migrations (version) VALUES ('20170228164401');

INSERT INTO schema_migrations (version) VALUES ('20170301181011');

INSERT INTO schema_migrations (version) VALUES ('20170302164335');

INSERT INTO schema_migrations (version) VALUES ('20170306130853');

INSERT INTO schema_migrations (version) VALUES ('20170327172810');

INSERT INTO schema_migrations (version) VALUES ('20170411144444');

INSERT INTO schema_migrations (version) VALUES ('20170417160824');

INSERT INTO schema_migrations (version) VALUES ('20170417172954');

INSERT INTO schema_migrations (version) VALUES ('20170418111625');

INSERT INTO schema_migrations (version) VALUES ('20170426005317');

INSERT INTO schema_migrations (version) VALUES ('20170427104751');

INSERT INTO schema_migrations (version) VALUES ('20170428111101');

INSERT INTO schema_migrations (version) VALUES ('20170501110357');

INSERT INTO schema_migrations (version) VALUES ('20170512104407');

INSERT INTO schema_migrations (version) VALUES ('20170512111224');

INSERT INTO schema_migrations (version) VALUES ('20170512111623');

INSERT INTO schema_migrations (version) VALUES ('20170512112035');

INSERT INTO schema_migrations (version) VALUES ('20170512152432');

INSERT INTO schema_migrations (version) VALUES ('20170529174752');

INSERT INTO schema_migrations (version) VALUES ('20170529174917');

