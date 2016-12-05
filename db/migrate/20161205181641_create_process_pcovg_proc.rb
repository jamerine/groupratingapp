class CreateProcessPcovgProc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_process_flat_pcovgs()
       RETURNS void AS
      $BODY$

      BEGIN
      /***************************************************************************/
      -- START OF pcovg
      /* Detail Record Type 02 */
      INSERT INTO pcovg_detail_records (
        representative_number,
        record_type,
        requestor_number,
        policy_number,
        business_sequence_number,
        valid_policy_number,
        coverage_status,
        coverage_status_effective_date,
        coverage_status_end_date,
        created_at,
        updated_at
      )
      (
      SELECT
        cast_to_int(substring(single_rec,1,6)) /* representative_number */,
        cast_to_int(substring(single_rec,10,2)) /* record_type */,
        cast_to_int(substring(single_rec,12,3)) /* requestor_number */,
        cast_to_int(substring(single_rec,15,8)) /* policy_number */,
        cast_to_int(substring(single_rec,24,3)) /* business_sequence_number */,
        substring(single_rec,27,1) /* valid_policy_number */,
        substring(single_rec,28,5) /* coverage_status */,
        case when substring(single_rec,33,8) > '00000000' THEN to_date(substring(single_rec,33,8), 'YYYYMMDD')
          else null
        end /* coverage_status_effective_date */,
        case when substring(single_rec,41,8) > '00000000' THEN to_date(substring(single_rec,41,8), 'YYYYMMDD')
          else null
        end /* coverage_status_end_date */,
        current_timestamp::timestamp as created_at,
        current_timestamp::timestamp as updated_at

       from pcovgs WHERE substring(single_rec,10,2) = '02');


       end;

         $BODY$
       LANGUAGE plpgsql ;
    })
  end

  def down
    connection.execute(%q{
        DROP FUNCTION public.proc_process_flat_pcovgs();
    })
  end
end
