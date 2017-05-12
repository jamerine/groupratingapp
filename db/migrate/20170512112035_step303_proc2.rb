class Step303Proc2 < ActiveRecord::Migration
    def up
      connection.execute(%q{
        -- Function: public.proc_step_303(integer, date, date, date)

    -- DROP FUNCTION public.proc_step_303(integer, date, date, date);

    CREATE OR REPLACE FUNCTION public.proc_step_303(
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

      -- STEP 3G -- ADDING MANUAL RECLASSIFICIATIONS TO THE PAYROLL table

      -- Insert Manual Reclassification Payroll changes into the payroll_all_transactions_breakdown_by_manual_class table.


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
      --  payroll deducted from the manual class that is being reclassed
      (Select
          representative_number,
          policy_type,
          policy_number as "policy_number",
          reclass_manual_coverage_type as manual_class_type,
          re_classed_from_manual_number as "manual_number",
          payroll_reporting_period_from_date as "payroll_reporting_period_from_date",
          payroll_reporting_period_to_date as "payroll_reporting_period_to_date",
          (-re_classed_to_manual_payroll_total) as "manual_payroll",
          'A' as reporting_type,
          policy_number as "policy_transferred",
          re_classed_to_manual_number as "manual_class_transferred",
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
        manual_class_type,
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
      (Select
          representative_number,
          policy_type,
          policy_number as "policy_number",
          re_classed_to_manual_number as "manual_number",
          reclass_manual_coverage_type as manual_class_type,
          payroll_reporting_period_from_date as "payroll_reporting_period_from_date",
          payroll_reporting_period_to_date as "payroll_reporting_period_to_date",
          (re_classed_to_manual_payroll_total) as "manual_payroll",
          'A' as reporting_type,
          policy_number as "policy_transferred",
          re_classed_from_manual_number as "manual_class_transferred",
          reclass_creation_date as "transfer_creation_date",
          'manual_reclass' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
      FROM public.process_manual_reclass_tables
      where representative_number = process_representative
      );

      DELETE FROM process_payroll_all_transactions_breakdown_by_manual_classes
          WHERE id IN (SELECT id
             FROM (SELECT id, ROW_NUMBER() OVER (partition BY representative_number,
                            policy_type,
                            policy_number,
                            manual_class_type,
                            manual_number,
                            reporting_period_start_date,
                            reporting_period_end_date,
                            manual_class_payroll,
                            reporting_type,
                            data_source ORDER BY transfer_creation_date DESC) AS rnum
                            FROM process_payroll_all_transactions_breakdown_by_manual_classes) t
           WHERE t.rnum > 1);

    end;
        $BODY$
        LANGUAGE plpgsql;


      })
    end

    def down
      connection.execute(%q{
      DROP FUNCTION public.proc_step_303(integer, date, date, date);
      })
    end

end
