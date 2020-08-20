class UpdateStep6 < ActiveRecord::Migration
  def up
    connection.execute(%q{
            -- STEP 6 of process

      CREATE OR REPLACE FUNCTION public.proc_step_6(process_representative integer,
      experience_period_lower_date date,
      experience_period_upper_date date,
      current_payroll_period_lower_date date,
      current_payroll_period_upper_date date
      )
      RETURNS void AS
      $BODY$

      DECLARE
        run_date timestamp := LOCALTIMESTAMP;
      BEGIN

      -- STEP 6 -- CREATE CLAIMS TABLE and Calculations

      INSERT INTO final_claim_cost_calculation_tables
        (
        representative_number,
        policy_type,
        policy_number,
        claim_number,
        claim_injury_date,
        claim_handicap_percent,
        claim_handicap_percent_effective_date,
        claim_manual_number,
        claimant_name,
        claimant_date_of_birth,
        claimant_date_of_death,
        claim_medical_paid,
        claim_mira_medical_reserve_amount,
        claim_mira_non_reducible_indemnity_paid,
        claim_mira_reducible_indemnity_paid,
        claim_mira_indemnity_reserve_amount,
        claim_mira_non_reducible_indemnity_paid_2,
        claim_total_subrogation_collected,
        claim_unlimited_limited_loss,
        policy_individual_maximum_claim_value,
        --claim_group_multiplier,
        --claim_individual_multiplier,
        -- claim_group_reduced_amount,
        -- claim_individual_reduced_amount,
        --claim_subrogation_percent,
        --claim_modified_losses_group_reduced
        --claim_modified_losses_individual_reduced,
        data_source,
        enhanced_care_program_indicator,
        created_at,
        updated_at
        )
        (SELECT
          a.representative_number,
          a.policy_type,
          a.policy_number,
          a.claim_number,
          a.claim_injury_date,
          round(a.claim_handicap_percent::numeric/100,2),
          a.claim_handicap_percent_effective_date,
          a.claim_manual_number,
          a.claimant_name,
          a.claimant_date_of_birth,
          a.claimant_date_of_death,
          a.claim_medical_paid,
          a.claim_mira_medical_reserve_amount,
          a.claim_mira_non_reducible_indemnity_paid,
          a.claim_mira_reducible_indemnity_paid,
          a.claim_mira_indemnity_reserve_amount,
          a.claim_mira_non_reducible_indemnity_paid_2,
          a.claim_total_subrogation_collected,
          (a.claim_medical_paid +
            a.claim_mira_medical_reserve_amount +
            a.claim_mira_non_reducible_indemnity_paid +
            a.claim_mira_reducible_indemnity_paid +
            a.claim_mira_indemnity_reserve_amount +
            a.claim_mira_non_reducible_indemnity_paid_2
          ) as "claim_unlimited_limited_loss"
          /*(case when (a.claim_medical_paid +
            a.claim_mira_medical_reserve_amount +
            a.claim_mira_non_reducible_indemnity_paid +
            a.claim_mira_reducible_indemnity_paid +
            a.claim_mira_indemnity_reserve_amount +
            a.claim_mira_non_reducible_indemnity_paid_2
          ) < '25000' THEN '1'
            else '25000'/(a.claim_medical_paid +
              a.claim_mira_medical_reserve_amount +
              a.claim_mira_non_reducible_indemnity_paid +
              a.claim_mira_reducible_indemnity_paid +
              a.claim_mira_indemnity_reserve_amount +
              a.claim_mira_non_reducible_indemnity_paid_2
            )
            end)::numeric as "claim_group_multiplier",

            (case when (a.claim_medical_paid +
              a.claim_mira_medical_reserve_amount +
              a.claim_mira_non_reducible_indemnity_paid +
              a.claim_mira_reducible_indemnity_paid +
              a.claim_mira_indemnity_reserve_amount +
              a.claim_mira_non_reducible_indemnity_paid_2
            ) < (SELECT b.policy_maximum_claim_value FROM public.test_table b WHERE a.policy_sequence_number = b.policy_number) THEN '1'
              else (SELECT b.policy_maximum_claim_value FROM public.test_table b WHERE a.policy_sequence_number = b.policy_number)/(a.claim_medical_paid +
                a.claim_mira_medical_reserve_amount +
                a.claim_mira_non_reducible_indemnity_paid +
                a.claim_mira_reducible_indemnity_paid +
                a.claim_mira_indemnity_reserve_amount +
                a.claim_mira_non_reducible_indemnity_paid_2
              )
              end)::decimal as "claim_independent_multiplier" */
              ,(SELECT plec.policy_maximum_claim_value from final_policy_experience_calculations plec where a.policy_number = plec.policy_number) as "policy_individual_maximum_claim_value",
              'bwc' as data_source,
              a.enhanced_care_program_indicator,
              run_date as created_at,
              run_date as updated_at
          FROM public.democ_detail_records a
          WHERE a.representative_number = process_representative
          ORDER BY claim_unlimited_limited_loss desc
          );



      -- STEP 6B -- CALCULATION OF CLAIMS COSTS



      -- Calculate out the claim_group_multiplier
        -- give employers figures on how much they are saving by being in a group.
      UPDATE public.final_claim_cost_calculation_tables SET claim_group_multiplier =

        ((CASE WHEN '250000' > claim_unlimited_limited_loss THEN '1'
              ELSE ('250000' / nullif(claim_unlimited_limited_loss, 0))
              END)::numeric);


      -- Calculate out the claim_individual_multiplier
        -- give employers figures on how much they are saving by being in a group.
      UPDATE public.final_claim_cost_calculation_tables SET claim_individual_multiplier =
        (CASE WHEN (policy_individual_maximum_claim_value is null or claim_unlimited_limited_loss is null) THEN '1'
              WHEN policy_individual_maximum_claim_value > claim_unlimited_limited_loss THEN '1'
              WHEN policy_individual_maximum_claim_value = '0.00' THEN '1'
              ELSE (policy_individual_maximum_claim_value / claim_unlimited_limited_loss)
              END)::numeric;




        -- claim_group_reduced_amount,
        -- claim_individual_reduced_amount,

      -- Calculate out the claim reducable cost
        -- [ NON-REDUCABLE AMOUNT * CLAIMS GROUP MULTIPLIER ] + [ ( REDUCIBLE AMOUNT ) * (CLAIMS GROUP MULTIPLIER * ( 1 - Handicapped Percent))]

      UPDATE public.final_claim_cost_calculation_tables SET claim_group_reduced_amount =
      (((claim_mira_non_reducible_indemnity_paid + claim_mira_non_reducible_indemnity_paid_2 ) * claim_group_multiplier ) + ((claim_medical_paid +
      claim_mira_medical_reserve_amount +
      claim_mira_reducible_indemnity_paid +
      claim_mira_indemnity_reserve_amount) * claim_group_multiplier * (1 - claim_handicap_percent)));



      -- Calculate out the claim reducable cost
        -- [ NON-REDUCABLE AMOUNT * CLAIMS INDIVIDUAL MULTIPLIER ] + [ ( REDUCIBLE AMOUNT ) * (CLAIMS INDIVIDUAL MULTIPLIER * ( 1 - Handicapped Percent))]

      UPDATE public.final_claim_cost_calculation_tables SET claim_individual_reduced_amount =
      (((claim_mira_non_reducible_indemnity_paid +
        claim_mira_non_reducible_indemnity_paid_2) * claim_individual_multiplier) +
      (
      (claim_medical_paid +
      claim_mira_medical_reserve_amount +
      claim_mira_reducible_indemnity_paid +
      claim_mira_indemnity_reserve_amount) * claim_individual_multiplier * ( 1 - claim_handicap_percent )));



      -- Calculate subrogation of case AMOUNT


      UPDATE public.final_claim_cost_calculation_tables SET claim_subrogation_percent =
      (
      case WHEN claim_total_subrogation_collected = '0' THEN '0'
           WHEN claim_total_subrogation_collected > claim_unlimited_limited_loss THEN '1'
           ELSE claim_total_subrogation_collected / claim_unlimited_limited_loss
           END
      );


      -- Calulate final claim cost if in group rating

      UPDATE public.final_claim_cost_calculation_tables SET claim_modified_losses_group_reduced =
      (
        round((claim_group_reduced_amount * (1 - claim_subrogation_percent))::numeric,2)
      );

      -- calculate final claim cost if individual not group.

      UPDATE public.final_claim_cost_calculation_tables SET claim_modified_losses_individual_reduced =
      (
        round((claim_individual_reduced_amount * (1 - claim_subrogation_percent))::numeric,2)
      );
      end;
        $BODY$
      LANGUAGE plpgsql;

    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_step_6(integer, date, date, date);
    })
  end
end
