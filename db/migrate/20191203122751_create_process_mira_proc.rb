class CreateProcessMiraProc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_process_flat_miras()
       RETURNS void AS
      $BODY$

      BEGIN
      /***************************************************************************/
      -- START OF mira
      /* Detail Record Type 02 */
      INSERT INTO mira_detail_records (
        representative_number,
        record_type,
        requestor_number,
        policy_number,
        business_sequence_number,
        valid_policy_number,
        created_at,
        updated_at
      )
      (
      SELECT
        cast_to_int(substring(single_rec,1,9)) /* representative_number */,
        cast_to_int(substring(single_rec,10,2)) /* record_type */,
        cast_to_int(substring(single_rec,12,3)) /*  requestor_number  */,
        cast_to_int(substring(single_rec,15,8)) /*  policy_number  */,
        cast_to_int(substring(single_rec,24,3)) /*  business_sequence_number  */,
        substring(single_rec,27,1) /*  valid_policy_number  */,
        current_timestamp::timestamp as created_at,
        current_timestamp::timestamp as updated_at

       from miras WHERE substring(single_rec,10,2) = '02');

       end;

         $BODY$
       LANGUAGE plpgsql ;
    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_process_flat_miras();
    })
  end
end
