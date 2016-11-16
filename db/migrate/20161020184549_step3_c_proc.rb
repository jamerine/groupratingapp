class Step3CProc < ActiveRecord::Migration
    def up
      connection.execute(%q{
        -- Function: public.proc_step_3_c(integer, date, date, date)

    -- DROP FUNCTION public.proc_step_3_c(integer, date, date, date);

    CREATE OR REPLACE FUNCTION public.proc_step_3_c(
        process_representative integer,
        experience_period_lower_date date,
        experience_period_upper_date date,
        current_payroll_period_lower_date date)
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
        manual_type,
        manual_number,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
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
        manual_coverage_type as manual_type,
        ncci_manual_number as "manual_number",
        payroll_reporting_period_from_date as "reporting_period_start_date",
        payroll_reporting_period_to_date as "reporting_period_end_date",
        (-manual_payroll) as "manual_payroll",
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
        manual_type,
        manual_number,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
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
        manual_coverage_type as manual_type,
        ncci_manual_number as "manual_number",
        payroll_reporting_period_from_date as "reporting_period_start_date",
        payroll_reporting_period_to_date as "reporting_period_end_date",
        manual_payroll as "manual_class_payroll",
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
        manual_type,
        manual_number,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
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
        manual_coverage_type as manual_type,
        ncci_manual_number as "manual_number",
        payroll_reporting_period_from_date as "reporting_period_start_date",
        payroll_reporting_period_to_date as "reporting_period_end_date",
        (-manual_payroll) as "manual_class_payroll",
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
        manual_type,
        manual_number,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
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
          reclass_manual_coverage_type as manual_type,
          re_classed_from_manual_number as "manual_number",
          payroll_reporting_period_from_date as "payroll_reporting_period_from_date",
          payroll_reporting_period_to_date as "payroll_reporting_period_to_date",
          (-re_classed_to_manual_payroll_total) as "manual_payroll",
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
        manual_type,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
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
          reclass_manual_coverage_type as manual_type,
          payroll_reporting_period_from_date as "payroll_reporting_period_from_date",
          payroll_reporting_period_to_date as "payroll_reporting_period_to_date",
          (re_classed_to_manual_payroll_total) as "manual_payroll",
          policy_number as "policy_transferred",
          reclass_creation_date as "transfer_creation_date",
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
                           ROW_NUMBER() OVER (partition BY representative_number, policy_type, policy_number, manual_type, manual_number, reporting_period_start_date,
                           reporting_period_end_date,
                           manual_class_payroll,
                           policy_transferred,
                           transfer_creation_date,
                           data_source, created_at,
                           updated_at ORDER BY id) AS rnum
                   FROM public.process_payroll_all_transactions_breakdown_by_manual_classes) t
          WHERE t.rnum > 1);
    end;
        $BODY$
        LANGUAGE plpgsql;


    })
  end

  def down
    connection.execute(%q{
    DROP FUNCTION public.proc_step_3_c(integer, date, date, date);
    })
  end
end
