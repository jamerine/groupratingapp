class Step302Proc3 < ActiveRecord::Migration
      def up
        connection.execute(%q{
          -- Function: public.proc_step_302(integer, date, date, date)

      -- DROP FUNCTION public.proc_step_302(integer, date, date, date);

      CREATE OR REPLACE FUNCTION public.proc_step_302(
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
            'man_reclass' || '_' || a.payroll_origin as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
        FROM public.process_payroll_all_transactions_breakdown_by_manual_classes a
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
          $BODY$
          LANGUAGE plpgsql;


      })
    end

    def down
      connection.execute(%q{
      DROP FUNCTION public.proc_step_302(integer, date, date, date, date);
      })
    end


end
