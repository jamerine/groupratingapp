class UpdateStep3A < ActiveRecord::Migration
  def up
    connection.execute(%q{
      -- Function: public.proc_step_3_a(integer, date, date, date)

  -- DROP FUNCTION public.proc_step_3_a(integer, date, date, date);

  CREATE OR REPLACE FUNCTION public.proc_step_3_a(
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


        -- STEP 3A POLICY COMBINE FULL TRANSFER

        INSERT INTO process_policy_combine_full_transfers (
          representative_number,
          policy_type,
          manual_number,
          manual_class_type,
          reporting_period_start_date,
          reporting_period_end_date,
          manual_class_rate,
          manual_class_payroll,
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
            a.manual_class_type,
            a.reporting_period_start_date,
            a.reporting_period_end_date,
            a.manual_class_rate,
            a.manual_class_payroll,
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
          RIGHT JOIN public.final_employer_demographics_informations c
          ON a.policy_number = c.policy_number
          Where b.transfer_type = 'FC' and a.representative_number = process_representative
          and a.reporting_period_end_date >= c.policy_creation_date
          GROUP BY a.representative_number,
            a.policy_type,
            a.manual_number,
            a.manual_class_type,
            a.reporting_period_start_date,
            a.reporting_period_end_date,
            a.manual_class_rate,
            a.manual_class_payroll,
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

      end;
          $BODY$
          LANGUAGE plpgsql;


    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_step_3_a(integer, date, date, date, date);
    })
  end
end
