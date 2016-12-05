class CreateProcessPdemoProc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_process_flat_pdemos()
       RETURNS void AS
      $BODY$

      BEGIN
      /***************************************************************************/
      -- START OF pdemo
      /* Detail Record Type 02 */
      INSERT INTO pdemo_detail_records (
        representative_number,
        record_type,
        requestor_number,
        policy_number,
        business_sequence_number,
        valid_policy_number,
        current_coverage_status,
        coverage_status_effective_date,
        federal_identification_number,
        business_name,
        trading_as_name,
        valid_mailing_address,
        mailing_address_line_1,
        mailing_address_line_2,
        mailing_city,
        mailing_state,
        mailing_zip_code,
        mailing_zip_code_plus_4,
        mailing_country_code,
        mailing_county,
        valid_location_address,
        location_address_line_1,
        location_address_line_2,
        location_city,
        location_state,
        location_zip_code,
        location_zip_code_plus_4,
        location_country_code,
        location_county,
        currently_assigned_clm_representative_number,
        currently_assigned_risk_representative_number,
        currently_assigned_erc_representative_number,
        currently_assigned_grc_representative_number,
        immediate_successor_policy_number,
        immediate_successor_business_sequence_number,
        ultimate_successor_policy_number,
        ultimate_successor_business_sequence_number,
        employer_type,
        coverage_type,
        created_at,
        updated_at
      )
      (
      SELECT
        cast_to_int(substring(single_rec,1,6)) /* representative_number */,
        cast_to_int(substring(single_rec,10,2)) /* record_type */,
        cast_to_int(substring(single_rec,12,3)) /*  requestor_number  */,
        cast_to_int(substring(single_rec,15,8)) /*  policy_number  */,
        cast_to_int(substring(single_rec,24,3)) /*  business_sequence_number  */,
        substring(single_rec,27,1) /*  valid_policy_number  */,
        substring(single_rec,28,5) /*  current_coverage_status  */,
        case when substring(single_rec,33,8) > '00000000' THEN to_date(substring(single_rec,33,8), 'YYYYMMDD')
          else null
        end      /*  coverage_status_effective_date  */,
        cast_to_int(substring(single_rec,41,11)) /*  federal_identification_number  */,
        substring(single_rec,52,40) /*  business_name  */,
        substring(single_rec,92,40) /*  trading_as_name  */,
        substring(single_rec,132,1) /*  valid_mailing_address  */,
        substring(single_rec,133,40) /*  mailing_address_line_1  */,
        substring(single_rec,173,40) /*  mailing_address_line_2  */,
        substring(single_rec,213,30) /*  mailing_city  */,
        substring(single_rec,243,2) /*  mailing_state  */,
        cast_to_int(substring(single_rec,245,5)) /*  mailing_zip_code  */,
        cast_to_int(substring(single_rec,250,4)) /*  mailing_zip_code_plus_4  */,
        cast_to_int(substring(single_rec,254,3)) /*  mailing_country_code  */,
        cast_to_int(substring(single_rec,257,5)) /*  mailing_county  */,
        substring(single_rec,262,1) /*  valid_location_address  */,
        substring(single_rec,263,40) /*  location_address_line_1  */,
        substring(single_rec,303,40) /*  location_address_line_2  */,
        substring(single_rec,343,30) /*  location_city  */,
        substring(single_rec,373,2) /*  location_state  */,
        cast_to_int(substring(single_rec,375,5)) /*  location_zip_code  */,
        cast_to_int(substring(single_rec,380,4)) /*  location_zip_code_plus_4  */,
        cast_to_int(substring(single_rec,384,3)) /*  location_country_code  */,
        cast_to_int(substring(single_rec,387,5)) /*  location_county  */,
        cast_to_int(substring(single_rec,392,6)) /*  currently_assigned_clm_representative_number  */,
        cast_to_int(substring(single_rec,401,6)) /*  currently_assigned_risk_representative_number  */,
        cast_to_int(substring(single_rec,410,6)) /*  currently_assigned_erc_representative_number  */,
        cast_to_int(substring(single_rec,419,6)) /*  currently_assigned_grc_representative_number  */,
        cast_to_int(substring(single_rec,428,8)) /*  immediate_successor_policy_number  */,
        cast_to_int(substring(single_rec,437,3)) /*  immediate_successor_business_sequence_number  */,
        cast_to_int(substring(single_rec,440,8)) /*  ultimate_successor_policy_number  */,
        cast_to_int(substring(single_rec,449,3)) /*  ultimate_successor_business_sequence_number  */,
        substring(single_rec,452,3) /*  employer_type  */,
        substring(single_rec,455,2) /*  coverage_type  */,
        current_timestamp::timestamp as created_at,
        current_timestamp::timestamp as updated_at

       from pdemos WHERE substring(single_rec,10,2) = '02');


       end;

         $BODY$
       LANGUAGE plpgsql ;
    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_process_flat_pdemos();
    })
  end
end
