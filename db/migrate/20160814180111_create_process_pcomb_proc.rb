class CreateProcessPcombProc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_process_flat_pcomb()
        RETURNS void AS
      $BODY$

      BEGIN

      /* Detail Record Type 02 */
      INSERT INTO pcomb_detail_records (
              representative_number,
              representative_type,
              record_type,
              requestor_number,
              policy_type,
              policy_number,
              business_sequence_number,
              valid_policy_number,
              policy_combinations,
              predecessor_policy_type,
              predecessor_policy_number,
              predecessor_filler,
              predecessor_business_sequence_number,
              successor_policy_type,
              successor_policy_number,
              successor_filler,
              successor_business_sequence_number,
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
              created_at,
              updated_at
      )
      (select cast_to_int(substring(single_rec,1,6)),   /*  representative_number  */
              cast_to_int(substring(single_rec,8,2)),   /*  representative_type  */
              cast_to_int(substring(single_rec,10,2)),   /*  record_type  */
              cast_to_int(substring(single_rec,12,3)),   /*  requestor_number  */
              cast_to_int(substring(single_rec,15,1)),   /*  policy_type  */
              cast_to_int(substring(single_rec,16,7)),   /*  policy_sequence_number  */
              cast_to_int(substring(single_rec,24,3)),   /*  business_sequence_number  */
              substring(single_rec,27,1),   /*  valid_policy_number  */
              substring(single_rec,28,1),   /*  policy_combinations  */
              substring(single_rec,29,1),   /*  predecessor_policy_type  */
              cast_to_int(substring(single_rec,30,7)),   /*  predecessor_policy_sequence_number  */
              substring(single_rec,37,1),   /*  predecessor_filler  */
              substring(single_rec,38,3),   /*  predecessor_business_sequence_number  */
              substring(single_rec,41,1),   /*  successor_policy_type  */
              cast_to_int(substring(single_rec,42,7)),   /*  successor_policy_sequence_number  */
              substring(single_rec,49,1),   /*  successor_filler  */
              substring(single_rec,50,3),   /*  successor_business_sequence_number  */
              substring(single_rec,53,2),   /*  transfer_type  */
              case when substring(single_rec,55,8) > '00000000' THEN to_date(substring(single_rec,55,8), 'YYYYMMDD')
                else null
              end,   /*  transfer_effective_date  */
              case when substring(single_rec,63,8) > '00000000' THEN to_date(substring(single_rec,63,8), 'YYYYMMDD')
                else null
              end,   /*  transfer_creation_date  */
              substring(single_rec,71,1),   /*  partial_transfer_due_to_labor_lease  */
              substring(single_rec,72,5),   /*  labor_lease_type  */
              substring(single_rec,77,1),   /*  partial_transfer_payroll_movement  */
              cast_to_int( substring(single_rec,78,5)),   /*  ncci_manual_number  */
              substring(single_rec,83,3),   /*  manual_coverage_type  */
              case when substring(single_rec,86,8) > '00000000' THEN to_date(substring(single_rec,86,8), 'YYYYMMDD')
                else null
              end,   /*  payroll_reporting_period_from_date  */
              case when substring(single_rec,94,8) > '00000000' THEN to_date(substring(single_rec,94,8), 'YYYYMMDD')
                else null
              end,   /*  payroll_reporting_period_to_date  */
              CASE when substring(single_rec,102,13) > '0' THEN cast(substring(single_rec,102,13) as numeric)
              ELSE null
              end,   /*  manual_payroll  */
              current_timestamp::timestamp as created_at,
              current_timestamp::timestamp as updated_at
      from pcombs WHERE substring(single_rec,10,2) = '02');


      end;

        $BODY$
      LANGUAGE plpgsql;



    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_process_flat_pcomb;
    })
  end
end
