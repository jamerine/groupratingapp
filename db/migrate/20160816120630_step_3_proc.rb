class Step3Proc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      -- Function: public.proc_step_3(integer, date, date, date)

  -- DROP FUNCTION public.proc_step_3(integer, date, date, date);

  CREATE OR REPLACE FUNCTION public.proc_step_3(
      process_representative integer,
      experience_period_lower_date date,
      experience_period_upper_date date,
      current_payroll_period_lower_date date)
    RETURNS void AS
  $BODY$

        DECLARE
          run_date timestamp := LOCALTIMESTAMP;
        BEGIN


        -- STEP 3A POLICY COMBINE FULL TRANSFER

        INSERT INTO process_policy_combine_full_transfers (
          representative_number,
          policy_type,
          manual_number,
          manual_type,
          manual_class_effective_date,
          manual_class_rate,
          manual_class_payroll,
          manual_class_premium,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT DISTINCT
            a.representative_number,
            a.policy_type,
            a.manual_number,
            a.manual_type,
            a.manual_class_effective_date,
            a.manual_class_rate,
            a.manual_class_payroll,
            a.manual_class_premium,
            b.predecessor_policy_type,
            b.predecessor_policy_number,
            b.successor_policy_type,
            b.successor_policy_number,
            b.transfer_type,
            b.transfer_effective_date,
            b.transfer_creation_date,
            'full_transfer' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
          FROM public.process_payroll_breakdown_by_manual_classes a
          Right Join public.pcomb_detail_records b
          ON a.policy_number = b.predecessor_policy_number
          Where b.transfer_type = 'FC' and a.representative_number = process_representative
          GROUP BY a.representative_number,
            a.policy_type,
            a.manual_number,
            a.manual_type,
            a.manual_class_effective_date,
            a.manual_class_rate,
            a.manual_class_payroll,
            a.manual_class_premium,
            b.predecessor_policy_type,
            b.predecessor_policy_number,
            b.successor_policy_type,
            b.successor_policy_number,
            b.transfer_type,
            b.transfer_effective_date,
            b.transfer_creation_date
        );



        /*********************************************************************/
        -- Remove exceptions from full_transfer table
        -- Create 'Request Payroll Information Table'
        /*********************************************************************/


        INSERT INTO exception_table_policy_combined_request_payroll_infos (
          representative_number,
          predecessor_policy_type,
          predecessor_policy_number,
          successor_policy_type,
          successor_policy_number,
          transfer_type,
          transfer_effective_date,
          transfer_creation_date,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
         (SELECT DISTINCT
             b.representative_number,
             b.predecessor_policy_type,
             b.predecessor_policy_number,
             b.successor_policy_type,
             b.successor_policy_number,
             b.transfer_type,
             b.transfer_effective_date,
             b.transfer_creation_date,
             'full_transfer' as payroll_origin,
             'bwc' as data_source,
             run_date as created_at,
             run_date as updated_at
           FROM public.process_payroll_breakdown_by_manual_classes a
           Right Join public.pcomb_detail_records b
           ON a.policy_number = b.predecessor_policy_number
           Where b.transfer_type = 'FC' and a.representative_number is null and b.transfer_creation_date >= experience_period_lower_date
           GROUP BY
             b.representative_number,
             b.predecessor_policy_type,
             b.predecessor_policy_number,
             b.successor_policy_type,
             b.successor_policy_number,
             b.transfer_type,
             b.transfer_effective_date,
             b.transfer_creation_date,
             payroll_origin
         );


         DELETE FROM public.process_policy_combine_full_transfers
          WHERE representative_number is null;


        -- 3B -- POLICY COMBINE FULL TRANSFER NO LEASES

        -- No labor lease, just partial payroll combinations
        -- Will add the designated payroll amount for the manual class for the designated
        -- payroll period from the predecessor_policy_number to the successor_policy_number.



        -- 05/03/16 Appendment to Logic
        -- If it is a State Fund PEO [will create a custom table to query against for a list of the PEOs], we want to only transfer payroll from [+ transfer] predecessor_policy_number (client) to the (successor_policy_number) State Fund PEO .  We will not do the [- transfer] away from the predecessor_policy_number (client). ALSO mark the policy number as not eligable for group rating.

        -- If it is a Self Insured PEO [policy_type 2] we will not transfer any of the payroll or anything from the policy combined, but we will keep them eligable for group rating.


        INSERT INTO process_policy_combine_partial_transfer_no_leases (
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
        (SELECT representative_number,
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
            'partial_transfer' as payroll_origin,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
        FROM public.pcomb_detail_records
        WHERE policy_combinations = 'Y' and transfer_type = 'PT' and partial_transfer_due_to_labor_lease = 'N' and representative_number = process_representative
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
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )


        -- Payroll breakdown by manual_class

        (SELECT a.representative_number,
        a.policy_type,
        a.policy_number,
        a.manual_type,
        a.manual_number,
        a.manual_class_effective_date,
        a.manual_class_payroll,
        a.payroll_origin,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
        FROM public.process_payroll_breakdown_by_manual_classes a
        LEFT JOIN public.final_employer_demographics_informations b
        ON a.policy_number = b.policy_number
        where a.representative_number = process_representative and a.manual_class_effective_date >= b.policy_creation_date
        );



        -- Payroll combination - Full Transfer -- Positive
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
        successor_policy_type as "policy_type",
        successor_policy_number as "policy_number",
        manual_type,
        manual_number,
        manual_class_effective_date,
        manual_class_payroll,
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
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
          payroll_origin,
          data_source,
          created_at,
          updated_at
        )
        (SELECT representative_number,
        predecessor_policy_type as "policy_type",
        predecessor_policy_number as "policy_number",
        manual_type,
        manual_number,
        manual_class_effective_date,
        (- manual_class_payroll),
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
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
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
        payroll_reporting_period_from_date as "manual_class_effective_date",
        manual_payroll as "manual_payroll",
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
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
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
        payroll_reporting_period_from_date as "manual_class_effective_date",
        (-manual_payroll) as "manual_payroll",
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
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
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
          payroll_reporting_period_from_date as "manual_class_effective_date",
          manual_payroll as "manual_payroll",
          payroll_origin,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.process_policy_combine_partial_to_full_leases
        where representative_number = process_representative
        );


        -- Payroll Combination - Partial to Full Lease -- Negative
        INSERT INTO process_payroll_all_transactions_breakdown_by_manual_classes (
          representative_number,
          policy_type,
          policy_number,
          manual_type,
          manual_number,
          manual_class_effective_date,
          manual_class_payroll,
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
          payroll_reporting_period_from_date as "manual_class_effective_date",
          (-manual_payroll) as "manual_payroll",
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
          manual_class_effective_date,
          manual_class_payroll,
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
          payroll_reporting_period_from_date as "manual_class_effective_date",
          manual_payroll as "manual_payroll",
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
          manual_class_effective_date,
          manual_class_payroll,
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
        payroll_reporting_period_from_date as "manual_class_effective_date",
        (-manual_payroll) as "manual_payroll",
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
          manual_class_effective_date,
          manual_class_payroll,
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
            (-re_classed_to_manual_payroll_total) as "manual_payroll",
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
          manual_class_effective_date,
          manual_class_payroll,
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
            (re_classed_to_manual_payroll_total) as "manual_payroll",
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
                             ROW_NUMBER() OVER (partition BY representative_number, policy_type, policy_number, manual_type, manual_number, manual_class_effective_date,
       manual_class_payroll, data_source, created_at,
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
      DROP FUNCTION public.proc_step_3(integer, date, date, date);
    })
  end
end
