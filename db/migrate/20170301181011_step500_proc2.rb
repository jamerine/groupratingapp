    class Step500Proc2 < ActiveRecord::Migration
      def up
        connection.execute(%q{
          -- STEP 5 of process

          CREATE OR REPLACE FUNCTION public.proc_step_500(process_representative integer,
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

          -- STEP 6 -- CREATE CLAIMS TABLE

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
            data_source,
            created_at,
            updated_at,
            claim_combined,
            combined_into_claim_number,
            claim_rating_plan_indicator,
            claim_status,
            claim_status_effective_date,
            claim_type,
            claim_activity_status,
            claim_activity_status_effective_date,
            settled_claim,
            settlement_type,
            medical_settlement_date,
            indemnity_settlement_date,
            maximum_medical_improvement_date,
            claim_mira_ncci_injury_type

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
              ) as "claim_unlimited_limited_loss",
              'bwc' as data_source,
              run_date as created_at,
              run_date as updated_at,
              a.claim_combined,
              a.combined_into_claim_number,
              a.claim_rating_plan_indicator,
              a.claim_status,
              a.claim_status_effective_date,
              a.claim_type,
              a.claim_activity_status,
              a.claim_activity_status_effective_date,
              a.settled_claim,
              a.settlement_type,
              a.medical_settlement_date,
              a.indemnity_settlement_date,
              a.maximum_medical_improvement_date,
              a.claim_mira_ncci_injury_type
              FROM public.democ_detail_records a
              WHERE a.representative_number = process_representative
              ORDER BY claim_unlimited_limited_loss desc
              );



          -- STEP 6B -- CALCULATION OF CLAIMS COSTS

          end;

            $BODY$
          LANGUAGE plpgsql;

              })
      end

      def down
        connection.execute(%q{
          DROP FUNCTION public.proc_step_500(integer, date, date, date, date);
        })
      end
    end
