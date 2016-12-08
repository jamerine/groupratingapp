class Step3BProc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      -- Function: public.proc_step_3_b(integer, date, date, date, date)

  -- DROP FUNCTION public.proc_step_3_b(integer, date, date, date, date);

      CREATE OR REPLACE FUNCTION public.proc_step_3_b(
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


        -- Two different ways to do this, append the policy combination records to the end of the payroll
        -- list or we can "merge" or "upsert" the data policy combination records with the list of payroll
        -- for each manual class for the corresponding policies.


        -- STEP 3C -- POLICY COMBINATION -- PARTIAL TO FULL LEASE
        -- Labor lease, just full and partial payroll combinations
        -- Will add the designated payroll amount for the manual class for the designated
        -- payroll period from the predecessor_policy_number to the successor_policy_number.

        -- Only add the predecessor_policy_number



        INSERT INTO process_policy_combine_partial_to_full_leases (
          representative_number,
          valid_policy_number,
          policy_combinations,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          partial_transfer_due_to_labor_lease,
          labor_lease_type,
          partial_transfer_payroll_movement,
          ncci_manual_number,
          manual_coverage_type,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          manual_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (
        SELECT representative_number,
          valid_policy_number,
          policy_combinations,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          partial_transfer_due_to_labor_lease,
          labor_lease_type,
          partial_transfer_payroll_movement,
          ncci_manual_number,
          manual_coverage_type,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          manual_payroll,
          'partial_to_full_lease' as payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.pcomb_detail_records
        WHERE partial_transfer_due_to_labor_lease = 'Y' and labor_lease_type != 'LTERM' and representative_number = process_representative
        GROUP BY representative_number,
          valid_policy_number,
          policy_combinations,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          partial_transfer_due_to_labor_lease,
          labor_lease_type,
          partial_transfer_payroll_movement,
          ncci_manual_number,
          manual_coverage_type,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          manual_payroll
        );



        -- Two different ways to do this, append the policy combination records to the end of the payroll
        -- list or we can "merge" or "upsert" the data policy combination records with the list of payroll
        -- for each manual class for the corresponding policies.


        --  UPDATE PEO LIST file from list of PEO Transfers.
        INSERT INTO bwc_codes_peo_lists (
        policy_type,
        policy_number,
        updated_at
        )
        (
        SELECT DISTINCT
           successor_policy_type,
           successor_policy_number,
           run_date as updated_at
        FROM public.process_policy_combine_partial_to_full_leases
        WHERE partial_transfer_due_to_labor_lease = 'Y' and successor_policy_number not in (SELECT policy_number FROM public.bwc_codes_peo_lists)
        );




        -- STEP 3D -- TERMINATE POLICY COMBINATIONS LEASES --
        -- Labor lease TERMINATE payroll combinations
        -- Will add the designated payroll amount for the manual class for the designated
        -- payroll period from the predecessor_policy_number to the successor_policy_number.

        -- Only add the predecessor_policy_number



        INSERT INTO process_policy_combination_lease_terminations (
          representative_number,
          valid_policy_number,
          policy_combinations,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          partial_transfer_due_to_labor_lease,
          labor_lease_type,
          partial_transfer_payroll_movement,
          ncci_manual_number,
          manual_coverage_type,
          payroll_reporting_period_from_date,
          payroll_reporting_period_to_date,
          manual_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (
          SELECT representative_number,
              valid_policy_number,
              policy_combinations,
              predecessor_policy_type,
              predecessor_policy_number,
              successor_policy_type,
              successor_policy_number,
              transfer_type,
              transfer_effective_date,
              transfer_creation_date,
              partial_transfer_due_to_labor_lease,
              labor_lease_type,
              partial_transfer_payroll_movement,
              ncci_manual_number,
              manual_coverage_type,
              payroll_reporting_period_from_date,
              payroll_reporting_period_to_date,
              manual_payroll,
              'lease_terminated' as payroll_origin,
              'bwc' as data_source,
              run_date as created_at,
              run_date as updated_at
          FROM public.pcomb_detail_records
          WHERE partial_transfer_due_to_labor_lease = 'Y'
            and labor_lease_type = 'LTERM' and representative_number = process_representative
        GROUP BY representative_number,
                valid_policy_number,
                policy_combinations,
                predecessor_policy_type,
                predecessor_policy_number,
                successor_policy_type,
                successor_policy_number,
                transfer_type,
                transfer_effective_date,
                transfer_creation_date,
                partial_transfer_due_to_labor_lease,
                labor_lease_type,
                partial_transfer_payroll_movement,
                ncci_manual_number,
                manual_coverage_type,
                payroll_reporting_period_from_date,
                payroll_reporting_period_to_date,
                manual_payroll
        );




        -- Two different ways to do this, append the policy combination records to the end of the payroll
        -- list or we can "merge" or "upsert" the data policy combination records with the list of payroll
        -- for each manual class for the corresponding policies.

        -- transfering the leased payroll out of PEO and adding it back to the employer


        -- STEP 3E -- CREATE POLICY LEVEL ROLLUPS for payroll and combinations

        -- All payroll transactions for policy Number and Manual class per period

        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
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
        (SELECT a.representative_number,
          a.policy_type,
          a.policy_number,
          a.policy_status_effective_date,
          a.policy_status,
          a.manual_number,
          a.manual_class_type,
          a.manual_class_description,
          a.bwc_customer_id,
          a.reporting_period_start_date,
          a.reporting_period_end_date,
          a.manual_class_rate,
          a.manual_class_payroll,
          a.reporting_type,
          a.number_of_employees,
          a.payroll_origin,
          a.data_source,
          a.created_at,
          a.updated_at
        FROM public.process_payroll_breakdown_by_manual_classes a
        LEFT JOIN public.final_employer_demographics_informations b
        ON a.policy_number = b.policy_number
        where a.representative_number = process_representative and b.policy_creation_date <= a.reporting_period_start_date
        );



        -- Payroll combination - Full Transfer -- Positive
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_class_type,
          manual_number,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_payroll,
          policy_transferred,
          transfer_creation_date,
          reporting_type,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
        successor_policy_type as "policy_type",
        successor_policy_number as "policy_number",
        manual_class_type,
        manual_number,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class_payroll,
        predecessor_policy_number as "policy_transferred",
        transfer_creation_date,
        'A' as reporting_type,
        payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM public.process_policy_combine_full_transfers
        where representative_number = process_representative
        );

        -- Payroll combination - Full Transfer -- Negative
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
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
        predecessor_policy_type as "policy_type",
        predecessor_policy_number as "policy_number",
        manual_class_type,
        manual_number,
        reporting_period_start_date,
        reporting_period_end_date,
        (- manual_class_payroll) as "manual_class_payroll",
        'A' as reporting_type,
        successor_policy_number as "policy_transferred",
        transfer_creation_date,
        payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM public.process_policy_combine_full_transfers
        where representative_number = process_representative
        );


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
      DROP FUNCTION public.proc_step_3_b(integer, date, date, date, date);
    })
  end
end
