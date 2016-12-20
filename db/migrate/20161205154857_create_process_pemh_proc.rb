class CreateProcessPemhProc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_process_flat_pemhs()
       RETURNS void AS
      $BODY$

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

         $BODY$
       LANGUAGE plpgsql ;
    })
  end

  def down
    connection.execute(%q{
        DROP FUNCTION public.proc_process_flat_pemhs();
    })
  end
end
