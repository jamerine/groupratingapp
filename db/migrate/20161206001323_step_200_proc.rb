class Step200Proc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_step_200(
        process_representative integer,
        experience_period_lower_date date,
        experience_period_upper_date date,
        current_payroll_period_lower_date date,
        current_payroll_period_upper_date date
      )
        RETURNS void AS
      $BODY$

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

        $BODY$
      LANGUAGE plpgsql;
    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_step_200(integer, date, date, date, date);
    })
  end
end
