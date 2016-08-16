class Step1Proc < ActiveRecord::Migration
  def up
    connection.execute(%q{
    CREATE OR REPLACE FUNCTION public.proc_step_1(
        process_representative integer,
        experience_period_lower_date date,
        experience_period_upper_date date,
        current_payroll_period_lower_date date)
      RETURNS void AS
    $BODY$

        DECLARE
          run_date date := CURRENT_DATE;
        BEGIN


        /*  BEGIN GROUP RATING PROCESS OF INSERTING RECORDS FROM FLAT FILES INTO THE NEWLY CREATED PROCESS AND FINAL TABLES        */

        -- STEP 1 A -- CREATE FINAL EMPLOYER DEMOGRAPHICS

        INSERT INTO final_employer_demographics_informations (
          representative_number,
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
          a.policy_number,
          a.coverage_effective_date,
          a.coverage_end_date,
          a.coverage_status,
          (CASE WHEN a.coverage_status = 'LAPSE' and a.coverage_end_date is not null Then (a.coverage_end_date - a.coverage_effective_date)
               WHEN a.coverage_status = 'LAPSE' and a.coverage_end_date is null THEN (run_date - a.coverage_effective_date)
               ELSE '0'::integer END) as lapse_days,
           run_date as updated_at
          FROM public.process_policy_coverage_status_histories a
          WHERE a.representative_number = process_representative
        ) t2
        WHERE pcsh.representative_number = t2.representative_number and pcsh.policy_number = t2.policy_number and pcsh.coverage_effective_date = t2.coverage_effective_date and pcsh.coverage_end_date = t2.coverage_end_date and pcsh.coverage_status = t2.coverage_status;


        Update public.process_policy_coverage_status_histories pcsh set (lapse_days, updated_at) = (t2.lapse_days, t2.updated_at)
        FROM
        (SELECT a.representative_number,
          a.policy_number,
          a.coverage_effective_date,
          a.coverage_end_date,
          a.coverage_status,
          (run_date - a.coverage_effective_date) as lapse_days,
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
          $BODY$
      LANGUAGE plpgsql;
    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_step_1(integer, date, date, date);
    })
  end

end
