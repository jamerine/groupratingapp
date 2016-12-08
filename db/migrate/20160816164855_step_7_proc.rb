class Step7Proc < ActiveRecord::Migration
  def up
    connection.execute(%q{
            -- STEP 7 of process

      CREATE OR REPLACE FUNCTION public.proc_step_7(process_representative integer,
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

      -- STEP 7A -- Calcualate FINAL POLICY EXPERIENCE

      --UPDATE Policy_level group modified losses from the claim_calculations table

      -- NEW QUERY FOR CALCULATED MOTIFIED LOSSES.

      UPDATE public.final_policy_experience_calculations c SET (policy_total_modified_losses_group_reduced, policy_total_modified_losses_individual_reduced, policy_total_claims_count, updated_at) = (t2.policy_total_modified_losses_group_reduced, t2.policy_total_modified_losses_individual_reduced, t2.policy_total_claims_count, t2.updated_at)
      FROM
      (SELECT
      	b.policy_number,
      	round(sum(b.claim_modified_losses_group_reduced)::numeric,2) as policy_total_modified_losses_group_reduced,
      	round(sum(b.claim_modified_losses_individual_reduced)::numeric,2) as policy_total_modified_losses_individual_reduced,
      	(CASE WHEN sum(b.claim_modified_losses_group_reduced) = 0 and sum(b.claim_modified_losses_individual_reduced) = 0 THEN '0'
      	ELSE count(b.policy_number)
      	END)::integer as policy_total_claims_count,
        run_date as updated_at
      from public.final_claim_cost_calculation_tables b
      WHERE b.claim_injury_date BETWEEN experience_period_lower_date and experience_period_upper_date
      and b.representative_number = process_representative
      GROUP BY b.policy_number) t2
      WHERE c.policy_number = t2.policy_number;





      -- UPDATE losses for companies without claims.

      UPDATE public.final_policy_experience_calculations c SET (policy_total_modified_losses_group_reduced, policy_total_modified_losses_individual_reduced, policy_total_claims_count, updated_at) = (t2.policy_total_modified_losses_group_reduced, t2.policy_total_modified_losses_individual_reduced, t2.policy_total_claims_count, t2.updated_at)
      FROM
      (SELECT
      	b.policy_number,
      	round(sum(b.claim_modified_losses_group_reduced)::numeric,2) as policy_total_modified_losses_group_reduced,
      	round(sum(b.claim_modified_losses_individual_reduced)::numeric,2) as policy_total_modified_losses_individual_reduced,
      	'0'::integer as policy_total_claims_count,
        run_date as updated_at
      from public.final_claim_cost_calculation_tables b
      WHERE b.claim_injury_date is null and b.representative_number = process_representative
      GROUP BY b.policy_number) t2
      where c.policy_number = t2.policy_number;
      --

      -- UPdate for companies with really old claims, to zero out null values
      	UPDATE public.final_policy_experience_calculations c SET (policy_total_modified_losses_group_reduced, policy_total_modified_losses_individual_reduced, policy_total_claims_count) = (round('0'::numeric,2),round('0'::numeric,2),round('0'::numeric,1))
      	where policy_total_claims_count is null;




        -- UPDATE policy_group_ratio using the policy_total_modified_losses_group_reduced / policy_total_expected_losses

        update public.final_policy_experience_calculations SET policy_group_ratio =
          (
            CASE WHEN policy_total_expected_losses = '0.00' and policy_total_modified_losses_group_reduced = '0.00' THEN '0.00'::numeric
                 WHEN policy_total_expected_losses > '0.00' and policy_total_modified_losses_group_reduced >= '0.00' THEN
                 round((policy_total_modified_losses_group_reduced / policy_total_expected_losses)::numeric, 4)
            END
          );




      -- Update policy_individual_total_modifier but subtracting total limited losses from total modified losses and dividing by the total limited Losses.  Then Multiplying by the policy_credibility_percent

      update public.final_policy_experience_calculations SET policy_individual_total_modifier =
        (
          CASE WHEN policy_total_limited_losses = '0.00' THEN '0.00'::numeric
          ELSE
          round(((((policy_total_modified_losses_individual_reduced - policy_total_limited_losses ) / policy_total_limited_losses) * policy_credibility_percent)::numeric),2)
          END
        );

      -- Update policy_individual_total_modifier but subtracting total limited losses from total modified losses and dividing by the total limited Losses.  Then Multiplying by the policy_credibility_percent and adding one


      update public.final_policy_experience_calculations SET policy_individual_experience_modified_rate =
      	(
      		CASE WHEN policy_total_limited_losses = '0' THEN '1'::numeric
      		ELSE
      		round((((((policy_total_modified_losses_individual_reduced - policy_total_limited_losses ) / policy_total_limited_losses) * policy_credibility_percent) + 1)::numeric),2)
      		END
      	);

        end;

          $BODY$
        LANGUAGE plpgsql;

    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_step_7(integer, date, date, date);
    })
  end
end
