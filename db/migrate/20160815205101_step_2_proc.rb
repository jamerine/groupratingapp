class Step2Proc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_step_2(
        process_representative integer,
        experience_period_lower_date date,
        experience_period_upper_date date,
        current_payroll_period_lower_date date
      )
        RETURNS void AS
      $BODY$

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

        $BODY$
      LANGUAGE plpgsql;
    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_step_2(integer, date, date, date);
    })
  end
end
