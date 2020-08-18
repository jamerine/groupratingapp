class UpdateFlatProcForClicds < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_process_flat_clicds()
        RETURNS void AS
      $BODY$

      BEGIN
      /***************************************************************************/
      -- START OF clicd
      /* Detail Record Type 02 */
      INSERT INTO clicd_detail_records (
        representative_number,
        record_type,
        requestor_number,
        policy_number,
        business_sequence_number,
        valid_policy_number,
        current_policy_status,
        current_policy_status_effective_date,
        policy_year,
        policy_year_rating_plan,
        claim_indicator,
        claim_number,
        icd_codes_assigned,
        icd_code,
        icd_status,
        icd_status_effective_date,
        icd_injury_location_code,
        icd_digit_tooth_number,
        primary_icd,
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
        substring(single_rec,28,5) /* current_policy_status */,
        CASE WHEN substring(single_rec,33,8) > '00000000' THEN to_date(substring(single_rec,33,8), 'YYYYMMDD')
            ELSE null
        END /* current_policy_status_effective_date */,
        cast_to_int(substring(single_rec,41,4)) /* policy_year */,
        substring(single_rec,45,5) /* policy_year_rating_plan */,
        substring(single_rec,50,1) /* claim_indicator */,
        substring(single_rec,51,10) /* claim_number */,
        substring(single_rec,61,1) /* icd_codes_assigned */,
        substring(single_rec,62,7) /* icd_code */,
        substring(single_rec,69,2) /* icd_status */,
        CASE WHEN substring(single_rec,71,8) > '00000000' THEN to_date(substring(single_rec,71,8), 'YYYYMMDD')
            ELSE null
        END /* icd_status_effective_date */,
        substring(single_rec,79,1) /* icd_injury_location_code */,
        substring(single_rec,80,2) /* icd_digit_tooth_number */,
        substring(single_rec,82,1) /* primary_icd */,
        current_timestamp::timestamp as created_at,
        current_timestamp::timestamp as updated_at

       FROM clicds WHERE substring(single_rec,10,2) = '02')
       ON CONFLICT ON CONSTRAINT unique_records_for_clicds
       DO UPDATE
        SET (representative_number,
             record_type,
             requestor_number,
             policy_number,
             business_sequence_number,
             valid_policy_number,
             current_policy_status,
             current_policy_status_effective_date,
             policy_year,
             policy_year_rating_plan,
             claim_indicator,
             claim_number,
             icd_codes_assigned,
             icd_code,
             icd_status,
             icd_status_effective_date,
             icd_injury_location_code,
             icd_digit_tooth_number,
             primary_icd,
             updated_at) = (excluded.representative_number,
                            excluded.record_type,
                            excluded.requestor_number,
                            excluded.policy_number,
                            excluded.business_sequence_number,
                            excluded.valid_policy_number,
                            excluded.current_policy_status,
                            excluded.current_policy_status_effective_date,
                            excluded.policy_year,
                            excluded.policy_year_rating_plan,
                            excluded.claim_indicator,
                            excluded.claim_number,
                            excluded.icd_codes_assigned,
                            excluded.icd_code,
                            excluded.icd_status,
                            excluded.icd_status_effective_date,
                            excluded.icd_injury_location_code,
                            excluded.icd_digit_tooth_number,
                            excluded.primary_icd,
                            current_timestamp::timestamp);
       end;

       $BODY$
       LANGUAGE plpgsql;
      })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_process_flat_clicds();
    })
  end
end
