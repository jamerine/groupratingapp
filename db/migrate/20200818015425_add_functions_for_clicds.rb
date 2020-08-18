class AddFunctionsForClicds < ActiveRecord::Migration
  def up
    connection.execute(%q{
    CREATE OR REPLACE FUNCTION public.new_clicd_record(clicd_record public.clicds) RETURNS void AS $$
BEGIN

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
      ) VALUES
      (
        cast_to_int(substring(clicd_record.single_rec,1,6)) /* representative_number */,
        cast_to_int(substring(clicd_record.single_rec,10,2)) /* record_type */,
        cast_to_int(substring(clicd_record.single_rec,12,3)) /* requestor_number */,
        cast_to_int(substring(clicd_record.single_rec,15,1) || substring(clicd_record.single_rec,16,7)) /* policy_number */,
        cast_to_int(substring(clicd_record.single_rec,24,3)) /* business_sequence_number */,
        substring(clicd_record.single_rec,27,1) /* valid_policy_number */,
        substring(clicd_record.single_rec,28,5) /* current_policy_status */,
        CASE WHEN substring(clicd_record.single_rec,33,8) > '00000000' THEN to_date(substring(clicd_record.single_rec,33,8), 'YYYYMMDD')
            ELSE null
        END /* current_policy_status_effective_date */,
        cast_to_int(substring(clicd_record.single_rec,41,4)) /* policy_year */,
        substring(clicd_record.single_rec,45,5) /* policy_year_rating_plan */,
        substring(clicd_record.single_rec,50,1) /* claim_indicator */,
        substring(clicd_record.single_rec,51,10) /* claim_number */,
        substring(clicd_record.single_rec,61,1) /* icd_codes_assigned */,
        substring(clicd_record.single_rec,62,7) /* icd_code */,
        substring(clicd_record.single_rec,69,2) /* icd_status */,
        CASE WHEN substring(clicd_record.single_rec,71,8) > '00000000' THEN to_date(substring(clicd_record.single_rec,71,8), 'YYYYMMDD')
            ELSE null
        END /* icd_status_effective_date */,
        substring(clicd_record.single_rec,79,1) /* icd_injury_location_code */,
        substring(clicd_record.single_rec,80,2) /* icd_digit_tooth_number */,
        substring(clicd_record.single_rec,82,1) /* primary_icd */,
        current_timestamp::timestamp,
        current_timestamp::timestamp);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.update_clicd_record(clicd_record public.clicds) RETURNS void AS $$
BEGIN

UPDATE clicd_detail_records
SET (
	valid_policy_number,
	current_policy_status,
	current_policy_status_effective_date,
	policy_year,
	policy_year_rating_plan,
	claim_indicator,
	icd_codes_assigned,
	icd_status,
	icd_status_effective_date,
	icd_injury_location_code,
	icd_digit_tooth_number,
	primary_icd,
	updated_at
) = (
	substring(clicd_record.single_rec,27,1) /* valid_policy_number */,
	substring(clicd_record.single_rec,28,5) /* current_policy_status */,
	CASE WHEN substring(clicd_record.single_rec,33,8) > '00000000' THEN to_date(substring(clicd_record.single_rec,33,8), 'YYYYMMDD')
		ELSE null
	END /* current_policy_status_effective_date */,
	cast_to_int(substring(clicd_record.single_rec,41,4)) /* policy_year */,
	substring(clicd_record.single_rec,45,5) /* policy_year_rating_plan */,
	substring(clicd_record.single_rec,50,1) /* claim_indicator */,
	substring(clicd_record.single_rec,61,1) /* icd_codes_assigned */,
	substring(clicd_record.single_rec,69,2) /* icd_status */,
	CASE WHEN substring(clicd_record.single_rec,71,8) > '00000000' THEN to_date(substring(clicd_record.single_rec,71,8), 'YYYYMMDD')
		ELSE null
	END /* icd_status_effective_date */,
	substring(clicd_record.single_rec,79,1) /* icd_injury_location_code */,
	substring(clicd_record.single_rec,80,2) /* icd_digit_tooth_number */,
	substring(clicd_record.single_rec,82,1) /* primary_icd */,
	current_timestamp::timestamp)
WHERE (clicd_detail_records.representative_number,
	  clicd_detail_records.record_type,
	  clicd_detail_records.requestor_number,
	  clicd_detail_records.policy_number,
	  clicd_detail_records.business_sequence_number,
	  clicd_detail_records.claim_number,
	  clicd_detail_records.icd_code) = (
		cast_to_int(substring(clicd_record.single_rec,1,6)) /* representative_number */,
		cast_to_int(substring(clicd_record.single_rec,10,2)) /* record_type */,
		cast_to_int(substring(clicd_record.single_rec,12,3)) /* requestor_number */,
		cast_to_int(substring(clicd_record.single_rec,15,1) || substring(clicd_record.single_rec,16,7)) /* policy_number */,
		cast_to_int(substring(clicd_record.single_rec,24,3)) /* business_sequence_number */,
		substring(clicd_record.single_rec,51,10) /* claim_number */,
		substring(clicd_record.single_rec,62,7));

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.proc_process_flat_clicds() RETURNS void AS $$
DECLARE
    clicd public.clicds;
BEGIN

FOR clicd IN
    SELECT * FROM clicds
LOOP
	IF NOT EXISTS (SELECT 1 FROM clicd_detail_records
				   WHERE (clicd_detail_records.representative_number,
						  clicd_detail_records.record_type,
						  clicd_detail_records.requestor_number,
						  clicd_detail_records.policy_number,
						  clicd_detail_records.business_sequence_number,
						  clicd_detail_records.claim_number,
						  clicd_detail_records.icd_code) = (
								cast_to_int(substring(clicd.single_rec,1,6)) /* representative_number */,
								cast_to_int(substring(clicd.single_rec,10,2)) /* record_type */,
								cast_to_int(substring(clicd.single_rec,12,3)) /* requestor_number */,
								cast_to_int(substring(clicd.single_rec,15,1) || substring(clicd.single_rec,16,7)) /* policy_number */,
								cast_to_int(substring(clicd.single_rec,24,3)) /* business_sequence_number */,
								substring(clicd.single_rec,51,10) /* claim_number */,
								substring(clicd.single_rec,62,7))
				  ) THEN
		PERFORM new_clicd_record(clicd);
	ELSE
		PERFORM update_clicd_record(clicd);
	END IF;

END LOOP;
END;
$$ LANGUAGE plpgsql;
   })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.new_clicd_record();
      DROP FUNCTION public.update_clicd_record();
      DROP FUNCTION public.proc_process_flat_clicds();
    })
  end
end
