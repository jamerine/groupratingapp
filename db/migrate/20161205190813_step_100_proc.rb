class Step100Proc < ActiveRecord::Migration
  def up
    connection.execute(%q{
    CREATE OR REPLACE FUNCTION public.proc_step_100(
        process_representative integer,
        experience_period_lower_date date,
        experience_period_upper_date date,
        current_payroll_period_lower_date date,
        current_payroll_period_upper_date date)
      RETURNS void AS
    $BODY$

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
          current_coverage_status,
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
          $BODY$
      LANGUAGE plpgsql;
    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_step_100(integer, date, date, date, date);
    })
  end

end
