class CreateProcessRateProc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_process_flat_rates()
       RETURNS void AS
      $BODY$

      BEGIN
      /***************************************************************************/
      -- START OF rates
      /* Detail Record Type 02 */
      INSERT INTO rate_detail_records (
        create_date,
        representative_number,
        representative_name,
        policy_number,
        business_sequence_number,
        policy_name,
        tax_id,
        policy_status_effective_date,
        policy_status,
        reporting_period_start_date,
        reporting_period_end_date,
        manual_class,
        manual_class_type,
        manual_class_description,
        bwc_customer_id,
        individual_first_name,
        individual_middle_name,
        individual_last_name,
        individual_tax_id,
        manual_class_rate,
        reporting_type,
        number_of_employees,
        payroll,
        created_at,
        updated_at
      )
      (
      SELECT
        split_part(single_rec, '|',1)::date,
        cast_to_int(substring(split_part(single_rec, '|',2),1,6)),
        split_part(single_rec, '|',3),
        cast_to_int(split_part(single_rec, '|',4)),
        cast_to_int(split_part(single_rec, '|',5)),
        split_part(single_rec, '|',6),
        cast_to_int(split_part(single_rec, '|',7)),
        split_part(single_rec, '|',8)::date,
        split_part(single_rec, '|',9),
        split_part(single_rec, '|',10)::date,
        split_part(single_rec, '|',11)::date,
        cast_to_int(split_part(single_rec, '|',12)),
        split_part(single_rec, '|',13),
        split_part(single_rec, '|',14),
        cast_to_int(split_part(single_rec, '|',15)),
        split_part(single_rec, '|',16),
        split_part(single_rec, '|',17),
        split_part(single_rec, '|',18),
        cast_to_int(split_part(single_rec, '|',19)),
        cast(split_part(single_rec, '|',20) as numeric),
        split_part(single_rec, '|',21),
        cast_to_int(split_part(single_rec, '|',22)),
        cast(split_part(single_rec, '|',23) as numeric),
        current_timestamp::timestamp as created_at,
        current_timestamp::timestamp as updated_at
       FROM public.rates

      );


       end;

         $BODY$
       LANGUAGE plpgsql ;
    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_process_flat_rates;
    })
  end
end
