class CreateProcessMrclsProc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_process_flat_mrcls()
       RETURNS void AS
      $BODY$

      BEGIN
      /***************************************************************************/
      -- START OF MRCLS

      /* Detail Record Type 02 */
      INSERT INTO mrcl_detail_records (
       representative_number,
       representative_type,
       record_type,
       requestor_number,
       policy_type,
       policy_number,
       business_sequence_number,
       valid_policy_number,
       manual_reclassifications,
       re_classed_from_manual_number,
       re_classed_to_manual_number,
       reclass_manual_coverage_type,
       reclass_creation_date,
       reclassed_payroll_information,
       payroll_reporting_period_from_date,
       payroll_reporting_period_to_date,
       re_classed_to_manual_payroll_total
      )
      (select
       cast_to_int(substring(single_rec,1,6)),   /*  representative_number  */
       cast_to_int(substring(single_rec,8,2)),   /*  representative_type  */
       cast_to_int(substring(single_rec,10,2)),   /*  record_type  */
       cast_to_int(substring(single_rec,12,3)),   /*  requestor_number  */
       CASE WHEN cast_to_int(substring(single_rec,15,1)) = 0 THEN 'private_state_fund'
            WHEN cast_to_int(substring(single_rec,15,1)) = 1 THEN 'public_state_fund'
            WHEN cast_to_int(substring(single_rec,15,1)) = 2 THEN 'private_self_insured'
            WHEN cast_to_int(substring(single_rec,15,1)) = 3 THEN 'public_app_fund'
            ELSE substring(single_rec,15,1)
            END,   /*  policy_type  */
       cast_to_int(substring(single_rec,15,1) || substring(single_rec,16,7)),   /*  policy_number  */
       cast_to_int(substring(single_rec,24,3)),   /*  business_sequence_number  */
       substring(single_rec,27,1),   /*  valid_policy_number  */
       substring(single_rec,28,1),   /*  manual_reclassifications  */
       cast_to_int(substring(single_rec,29,5)),   /*  re-classed_from_manual_number  */
       cast_to_int(substring(single_rec,34,5)),   /*  re-classed_to_manual_number  */
       CASE WHEN substring(single_rec,39,3) LIKE 'SUP' THEN 'SN'
            WHEN substring(single_rec,39,3) LIKE 'REG' THEN 'RN'
            ELSE substring(single_rec,39,3) END,   /*  reclass_manual_coverage_type  */
       case when substring(single_rec,42,8) > '0' THEN to_date(substring(single_rec,42,8), 'YYYYMMDD')
         else null
       end,  /*  reclass_creation_date  */
       substring(single_rec,50,1),   /*  reclassed_payroll_information  */
       case when substring(single_rec,51,8) > '0' THEN to_date(substring(single_rec,51,8), 'YYYYMMDD')
         else null
       end,  /*  payroll_reporting_period_from_date  */
       case when substring(single_rec,59,8) > '0' THEN to_date(substring(single_rec,59,8), 'YYYYMMDD')
         else null
       end, /*  payroll_reporting_period_to_date  */
       CASE when substring(single_rec,67,13) > '0' THEN cast(substring(single_rec,67,13) as numeric)
       ELSE null
       end  /*re-classed_to_manual_payroll_total  */

      from mrcls WHERE substring(single_rec,10,2) = '02');



       end;

         $BODY$
       LANGUAGE plpgsql ;
    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_process_flat_mrcls;
    })
  end
end
