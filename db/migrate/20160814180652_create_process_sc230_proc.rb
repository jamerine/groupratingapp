class CreateProcessSc230Proc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_process_flat_sc230s()
      RETURNS void AS
    $BODY$

    BEGIN

    INSERT INTO sc230_employer_demographics (
      representative_number,
      representative_type,
      policy_type,
      policy_number,
      business_sequence_number,
      claim_manual_number,
      record_type,
      claim_number,
      policy_name,
      doing_business_as_name,
      street_address,
      city,
      state,
      zip_code,
      created_at,
      updated_at
    )
    (select cast_to_int(substring(single_rec,1,6)),   /*  representative_number  */
            cast_to_int(substring(single_rec,8,2)),   /*  representative_type  */
            cast_to_int(substring(single_rec,10,1)),   /*  policy_type  */
            cast_to_int(substring(single_rec,11,7)),   /*  policy_sequence_number  */
            cast_to_int(substring(single_rec,19,3)),   /*  business_sequence_number  */
            cast_to_int(substring(single_rec,22,4)),   /*  claim_manual_number  */
            substring(single_rec,26,2),   /*  record_type  */
            substring(single_rec,28,10),   /*  claim_number  */
            substring(single_rec,38,34),   /*  policy_name  */
            substring(single_rec,72,34),   /*  doing_business_as_name  */
            substring(single_rec,106,34),   /*  street_address  */
            substring(single_rec,140,24),   /*  city  */
            substring(single_rec,164,2),   /*  state  */
            cast_to_int(substring(single_rec,166,5)),   /*  zip_code  */
            current_timestamp::timestamp as created_at,
            current_timestamp::timestamp as updated_at
    from sc230s WHERE substring(single_rec,26,2) = '01');

    /* Claim Medical Payments Record – Record Type ‘02’: */

    INSERT INTO sc230_claim_medical_payments (
      representative_number,
      representative_type,
      policy_type,
      policy_number,
      business_sequence_number,
      claim_manual_number,
      record_type,
      claim_number,
      hearing_date,
      injury_date,
      from_date,
      to_date,
      award_type,
      number_of_weeks,
      awarded_weekly_rate,
      award_amount,
      payment_amount,
      claimant_name,
      payee_name,
      created_at,
      updated_at

    )
    (select cast_to_int(substring(single_rec,1,6)),   /*  representative_number  */
            cast_to_int(substring(single_rec,8,2)),   /*  representative_type  */
            cast_to_int(substring(single_rec,10,1)),   /*  policy_type  */
            cast_to_int(substring(single_rec,11,7)),   /*  policy_sequence_number  */
            cast_to_int(substring(single_rec,19,3)),   /*  business_sequence_number  */
            cast_to_int(substring(single_rec,22,4)),   /*  claim_manual_number  */
            substring(single_rec,26,2),   /*  record_type  */
            substring(single_rec,28,10),   /*  claim_number  */
            case when substring(single_rec,38,6) > '00000000' THEN to_date(substring(single_rec,38,6), 'YYMMDD')
              else null
            end,   /*  hearing_date  */
            case when substring(single_rec,44,6) > '00000000' THEN to_date(substring(single_rec,44,6), 'YYMMDD')
              else null
            end,   /*  injury_date  */
            substring(single_rec,50,6),   /*  from_date  */
            substring(single_rec,56,6),   /*  to_date  */
            substring(single_rec,62,2),   /*  award_type  */
            substring(single_rec,64,6),   /*  number_of_weeks  */
            substring(single_rec,70,6),   /*  awarded_weekly_rate  */
            cast_to_int(substring(single_rec,76,9)),   /*  award_amount  */
            substring(single_rec,86,9)::numeric/100,   /*  payment_amount  */
            substring(single_rec,96,26),   /*  claimant_name  */
            substring(single_rec,122,24),   /*  payee_name  */
            current_timestamp::timestamp as created_at,
            current_timestamp::timestamp as updated_at
    from sc230s WHERE substring(single_rec,26,2) = '02');

    /* SC230	Claim Indemnity Awards Record – Record Type ‘03’: */
    INSERT INTO sc230_claim_indemnity_awards (
      representative_number,
      representative_type,
      policy_type,
      policy_number,
      business_sequence_number,
      claim_manual_number,
      record_type,
      claim_number,
      hearing_date,
      injury_date,
      from_date,
      to_date,
      award_type,
      number_of_weeks,
      awarded_weekly_rate,
      award_amount,
      payment_amount,
      claimant_name,
      payee_name,
      created_at,
      updated_at
    )
    (select cast_to_int(substring(single_rec,1,6)),   /*  representative_number  */
            cast_to_int(substring(single_rec,8,2)),   /*  representative_type  */
            cast_to_int(substring(single_rec,10,1)),   /*  policy_type  */
            cast_to_int(substring(single_rec,11,7)),   /*  policy_sequence_number  */
            cast_to_int(substring(single_rec,19,3)),   /*  business_sequence_number  */
            cast_to_int(substring(single_rec,22,4)),   /*  claim_manual_number  */
            substring(single_rec,26,2),   /*  record_type  */
            substring(single_rec,28,10),   /*  claim_number  */
            case when substring(single_rec,38,6) > '00000000' THEN to_date(substring(single_rec,38,6), 'YYMMDD')
              else null
            end,   /*  hearing_date  */
            case when substring(single_rec,44,6) > '00000000' THEN to_date(substring(single_rec,44,6), 'YYMMDD')
              else null
            end,   /*  injury_date  */
            case when substring(single_rec,50,6) > '00000000' THEN to_date(substring(single_rec,50,6), 'YYMMDD')
              else null
            end,   /*  from_date  */
            case when substring(single_rec,56,6) > '00000000' THEN to_date(substring(single_rec,56,6), 'YYMMDD')
              else null
            end,   /*  to_date  */
            substring(single_rec,62,2),   /*  award_type  */
            substring(single_rec,64,6),   /*  number_of_weeks  */
            substring(single_rec,70,6)::numeric/100,   /*  awarded_weekly_rate  */
            substring(single_rec,76,9)::numeric/100,   /*  award_amount  */
            cast_to_int(substring(single_rec,86,9)),   /*  payment_amount  */
            substring(single_rec,96,26),   /*  claimant_name  */
            substring(single_rec,122,24),   /*  payee_name  */
            current_timestamp::timestamp as created_at,
            current_timestamp::timestamp as updated_at
    from sc230s WHERE substring(single_rec,26,2) = '03');

    end;

      $BODY$
    LANGUAGE plpgsql;

    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_process_flat_sc230;
    })
  end
end
