class CreateProcessPhmgnProc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_process_flat_phmgns()
        RETURNS void AS
      $BODY$

      BEGIN

      /****************************************************************************/
      -- START OF PHMGNFILE


      /* Detail Record Type 02 */
      INSERT INTO phmgn_detail_records (
                representative_number,
                representative_type,
                record_type,
                requestor_number,
                policy_type,
                policy_number,
                business_sequence_number,
                valid_policy_number,
                experience_payroll_premium_information,
                industry_code,
                ncci_manual_number,
                manual_coverage_type,
                manual_payroll,
                manual_premium,
                premium_percentage,
                upcoming_policy_year,
                policy_year_extracted_for_experience_payroll_determining_premiu,
                policy_year_extracted_beginning_date,
                policy_year_extracted_ending_date,
                created_at,
                updated_at
      )
      (select cast_to_int(substring(single_rec,1,6)),   /*  representative_number  */
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
              substring(single_rec,28,1),   /*  experience_payroll_premium_information  */
              substring(single_rec,29,2),   /*  industry_code  */
              cast_to_int(substring(single_rec,31,5)),   /*  ncci_manual_number  */
              substring(single_rec,36,3),   /*  manual_coverage_type  */
              case when substring(single_rec,39,13) > '0' THEN substring(single_rec,39,14)::numeric/100
                  else null
              end,          /*  manual_payroll  */
              case when substring(single_rec,53,13) > '0' THEN substring(single_rec,53,13)::numeric/100
                  else null
              end,  /*  manual_premium  */
              case when substring(single_rec,67,6) > '0' THEN substring(single_rec,67,6)::numeric/100
                  else null
              end,  /*  premium_percentage  */
              cast_to_int(substring(single_rec,74,4)),   /*  upcoming_policy_year  */
              cast_to_int(substring(single_rec,78,4)),   /*  policy_year_extracted_for_experience_payroll_determining_premium  */
              case when substring(single_rec,82,8) > '00000000' THEN to_date(substring(single_rec,82,8), 'YYYYMMDD')
                else null
              end,   /*  policy_year_extracted_beginning_date  */
              case when substring(single_rec,90,8) > '00000000' THEN to_date(substring(single_rec,90,8), 'YYYYMMDD')
                else null
              end,   /*  policy_year_extracted_ending_date  */
              current_timestamp::timestamp as created_at,
              current_timestamp::timestamp as updated_at
      from phmgns WHERE substring(single_rec,10,2) = '02');




      end;

        $BODY$
        LANGUAGE plpgsql;




    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_process_flat_phmgn;
    })
  end
end
