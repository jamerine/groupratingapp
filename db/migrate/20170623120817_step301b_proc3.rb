class Step301bProc3 < ActiveRecord::Migration
      def up
        connection.execute(%q{
          -- Function: public.proc_step_301b(integer, date, date, date, date)

      -- DROP FUNCTION public.proc_step_301b(integer, date, date, date, date);

          CREATE OR REPLACE FUNCTION public.proc_step_301b(
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



                -- CHANGES TOP 301 PROC.  Broke up proc to add new pcomb process for full transfers.


                -- Payroll combination - Partial Transfer -- No Lease -- Positive
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
                  manual_payroll,
                  'A' as reporting_type,
                  predecessor_policy_number as "policy_transferred",
                  ncci_manual_number as "manual_class_transferred",
                  transfer_creation_date,
                  payroll_origin,
                  'bwc' as data_source,
                  run_date as created_at,
                  run_date as updated_at
                FROM public.process_policy_combine_partial_transfer_no_leases
                where representative_number = process_representative
                );

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
                FROM public.process_policy_combine_partial_transfer_no_leases
                where representative_number = process_representative
                );


                -- Payroll Combination - Partial to Full Lease -- Positive
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
                  manual_payroll as "manual_payroll",
                  'A' as reporting_type,
                  predecessor_policy_number as "policy_transferred",
                  ncci_manual_number as "manual_class_transferred",
                  transfer_creation_date,
                  payroll_origin,
                  'bwc' as data_source,
                  run_date as created_at,
                  run_date as updated_at
                FROM public.process_policy_combine_partial_to_full_leases
                where representative_number = process_representative
                );




          end;
              $BODY$
              LANGUAGE plpgsql;


          })
      end

      def down
        connection.execute(%q{
          DROP FUNCTION public.proc_step_301b(integer, date, date, date, date);
        })
      end
  end
