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
    LANGUAGE plpgsql IMMUTABLE
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
-- Name: proc_process_flat_democ(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_democ() RETURNS void
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
    --claimant_name,
    claim_manual_number,
    claim_sub_manual_number,
    claim_type,
    --claimant_date_of_birth,
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
    cast_to_int(substring(single_rec,15,1)),   /*  policy_type  */
    cast_to_int(substring(single_rec,16,7)),   /*  policy_number  */
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
    -- substring(single_rec,91,20),   /*  claimant_name  */
    cast_to_int(substring(single_rec,111,4)),   /*  claim_manual_number  */
    substring(single_rec,115,2),   /*  claim_sub_manual_number  */
    substring(single_rec,117,4),   /*  claim_type  */
    -- case when substring(single_rec,121,8) > '00000000' THEN to_date(substring(single_rec,121,8), 'YYYYMMDD')
    --   else null
    -- end,  /*  claimant_date_of_birth  */
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
 cast_to_int(substring(single_rec,15,1)),   /*  policy_type  */
 cast_to_int(substring(single_rec,16,7)),   /*  policy_sequence_number  */
 cast_to_int(substring(single_rec,24,3)),   /*  business_sequence_number  */
 substring(single_rec,27,1),   /*  valid_policy_number  */
 substring(single_rec,28,1),   /*  manual_reclassifications  */
 cast_to_int(substring(single_rec,29,5)),   /*  re-classed_from_manual_number  */
 cast_to_int(substring(single_rec,34,5)),   /*  re-classed_to_manual_number  */
 substring(single_rec,39,3),   /*  reclass_manual_coverage_type  */
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
-- Name: proc_process_flat_mremp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_mremp() RETURNS void
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
          cast_to_int(substring(single_rec,10,1)),  /* policy_type */
          cast_to_int(substring(single_rec,11,7)),  /* policy_number  */
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
-- Name: proc_process_flat_pcomb(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_pcomb() RETURNS void
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
        cast_to_int(substring(single_rec,15,1)),   /*  policy_type  */
        cast_to_int(substring(single_rec,16,7)),   /*  policy_sequence_number  */
        cast_to_int(substring(single_rec,24,3)),   /*  business_sequence_number  */
        substring(single_rec,27,1),   /*  valid_policy_number  */
        substring(single_rec,28,1),   /*  policy_combinations  */
        substring(single_rec,29,1),   /*  predecessor_policy_type  */
        cast_to_int(substring(single_rec,30,7)),   /*  predecessor_policy_sequence_number  */
        substring(single_rec,37,1),   /*  predecessor_filler  */
        substring(single_rec,38,3),   /*  predecessor_business_sequence_number  */
        substring(single_rec,41,1),   /*  successor_policy_type  */
        cast_to_int(substring(single_rec,42,7)),   /*  successor_policy_sequence_number  */
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
        substring(single_rec,83,3),   /*  manual_coverage_type  */
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
-- Name: proc_process_flat_phmgn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_phmgn() RETURNS void
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
        cast_to_int(substring(single_rec,15,1)),   /*  policy_type  */
        cast_to_int(substring(single_rec,16,7)),   /*  policy_sequence_number  */
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
-- Name: proc_process_flat_sc220(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_sc220() RETURNS void
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
          cast_to_int(substring(single_rec,15,1)),     -- policy_type char(1),
          cast_to_int(substring(single_rec,16,7)),     -- policy_number char(7),
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
          substring(single_rec,755,12)::numeric/100,   -- regular_balance_amount char(13),
          substring(single_rec,768,12)::numeric/100,   -- attorney_general_balance_amount char(13),
          substring(single_rec,781,12)::numeric/100,   -- appealed_balance_amount char(13),
          substring(single_rec,794,12)::numeric/100,   -- pending_balance_amount char(13),
          substring(single_rec,807,10)::numeric/100,   -- advance_deposit_amount numeric
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
          cast_to_int(substring(single_rec,15,1)),      -- policy_type
          cast_to_int(substring(single_rec,16,7)),      -- policy_number
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
    cast_to_int(substring(single_rec,15,1)),     -- policy_type char(1),
    cast_to_int(substring(single_rec,16,7)),     -- policy_number char(7),
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
    cast_to_int(substring(single_rec,15,1)),     -- policy_type char(1),
    cast_to_int(substring(single_rec,16,7)),     -- policy_number char(7),
    cast_to_int(substring(single_rec,23,3)),      -- business_sequence_number
    substring(single_rec,26,25),     -- error_message
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
from sc220s where substring(single_rec,11,1) = '4');


 /*************** END OF SC220 FILE CONVERSION ***************/

 end;

   $$;


--
-- Name: proc_process_flat_sc230(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_process_flat_sc230() RETURNS void
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
        cast_to_int(substring(single_rec,10,1)),   /*  policy_type  */
        cast_to_int(substring(single_rec,11,7)),   /*  policy_sequence_number  */
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
(select substring(single_rec,1,6)::integer,   /*  representative_number  */
        substring(single_rec,8,2),   /*  representative_type  */
        substring(single_rec,10,1),   /*  policy_type  */
        substring(single_rec,11,7)::integer,   /*  policy_sequence_number  */
        substring(single_rec,19,3),   /*  business_sequence_number  */
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
        substring(single_rec,76,9)::integer,   /*  award_amount  */
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
(select substring(single_rec,1,6)::integer,   /*  representative_number  */
        substring(single_rec,8,2),   /*  representative_type  */
        substring(single_rec,10,1),   /*  policy_type  */
        substring(single_rec,11,7)::integer,   /*  policy_sequence_number  */
        substring(single_rec,19,3),   /*  business_sequence_number  */
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
        substring(single_rec,86,9)::integer,   /*  payment_amount  */
        substring(single_rec,96,26),   /*  claimant_name  */
        substring(single_rec,122,24),   /*  payee_name  */
        current_timestamp::timestamp as created_at,
        current_timestamp::timestamp as updated_at
from sc230s WHERE substring(single_rec,26,2) = '03');





end;

  $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: democ_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE democ_detail_records (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    record_type integer,
    requestor_number integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    valid_policy_number character varying,
    current_policy_status character varying,
    current_policy_status_effective_date date,
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
-- Name: mrcl_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrcl_detail_records (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    record_type integer,
    requestor_number integer,
    policy_type integer,
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
    policy_type integer,
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
    policy_type integer,
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
    policy_type integer,
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
-- Name: pcomb_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pcomb_detail_records (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    record_type integer,
    requestor_number integer,
    policy_type integer,
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
-- Name: phmgn_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE phmgn_detail_records (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    record_type integer,
    requestor_number integer,
    policy_type integer,
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
-- Name: sc220_rec1_employer_demographics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc220_rec1_employer_demographics (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    description_ar character varying,
    record_type integer,
    request_type integer,
    policy_type integer,
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
    policy_type integer,
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
    policy_type integer,
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
    policy_type integer,
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
    policy_type integer,
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
    policy_type integer,
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
    policy_type integer,
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

ALTER TABLE ONLY pcomb_detail_records ALTER COLUMN id SET DEFAULT nextval('pcomb_detail_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcombs ALTER COLUMN id SET DEFAULT nextval('pcombs_id_seq'::regclass);


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
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


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

