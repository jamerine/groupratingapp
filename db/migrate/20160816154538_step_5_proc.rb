class Step5Proc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      -- STEP 5 of process

      CREATE OR REPLACE FUNCTION public.proc_step_5(process_representative integer,
      experience_period_lower_date date,
      experience_period_upper_date date,
      current_payroll_period_lower_date date
      )
      RETURNS void AS
      $BODY$

      DECLARE
        run_date timestamp := LOCALTIMESTAMP;
      BEGIN


      -- STEP 5A -- POLICY EXPERIENCE ROLLUPS

      -- INSERT THEN UPDATE STATEMENTS TO CREATE MORE SPEED.
      INSERT INTO public.final_policy_experience_calculations
      (
      representative_number,
      policy_type,
      policy_number,
      data_source,
      created_at,
      updated_at
      )
      (SELECT DISTINCT representative_number,
             policy_type,
             policy_number,
             'bwc' as data_source,
             run_date as created_at,
             run_date as updated_at
       FROM final_manual_class_four_year_payroll_and_exp_losses
       where representative_number = process_representative
       );


      --  UPDATE policy_group_number

      UPDATE public.final_policy_experience_calculations pec SET (policy_group_number, updated_at) =
      (t2.policy_group_number, t2.updated_at)
      FROM
      (
       SELECT a.policy_number, a.group_code as policy_group_number,
       run_date as updated_at
       FROM final_employer_demographics_informations a
       where a.representative_number = process_representative
      ) t2
      WHERE pec.policy_number = t2.policy_number;


      -- UPDATE policy_role_ups
      UPDATE public.final_policy_experience_calculations pec SET (policy_total_four_year_payroll, policy_total_expected_losses, updated_at) = (t2.policy_four_year_payroll, t2.policy_total_expected_losses, t2.updated_at)
      FROM
      (SELECT policy_number,
       round(sum(manual_class_four_year_period_payroll)::numeric,2) as policy_four_year_payroll,
       round(sum(manual_class_expected_losses)::numeric,2) as policy_total_expected_losses,
       run_date as created_at,
       run_date as updated_at
       FROM public.final_manual_class_four_year_payroll_and_exp_losses
       WHERE representative_number = process_representative
       GROUP BY policy_number
      ) t2
      WHERE pec.policy_number = t2.policy_number;


      -- UPDATE industry_group




      ----------------------------
      -- Update policy_status

      UPDATE public.final_policy_experience_calculations a SET (policy_status, updated_at) = (t2.current_policy_status, t2.updated_at)
      FROM
      (SELECT p.policy_number, p.current_policy_status,
      run_date as updated_at
        FROM public.final_employer_demographics_informations p
        where p.representative_number = process_representative
      ) t2
      WHERE a.policy_number = t2.policy_number;

      ----------
      -- UPDATE policy_level credibilty_group

       UPDATE public.final_policy_experience_calculations a SET (policy_credibility_group, updated_at) = (t2.credibility_group, t2.updated_at)
      FROM
       (SELECT p.policy_number,
             (SELECT case when (min(bwc.credibility_group) - 1) is null THEN '22'
                    ELSE (min(bwc.credibility_group) - 1)
                       END
             as credibility_group
               FROM public.bwc_codes_credibility_max_losses bwc
                 WHERE (p.policy_total_expected_losses / expected_losses ) <= 1),
                 run_date as updated_at
         FROM public.final_policy_experience_calculations p
         WHERE p.representative_number = process_representative
        ) t2
        WHERE a.policy_number = t2.policy_number;


      --- Update Credibilty policy_credibility_percent and maximum_claim_value

      UPDATE public.final_policy_experience_calculations a SET (policy_credibility_percent, policy_maximum_claim_value, updated_at) = (t2.policy_credibility_percent, t2.policy_maximum_claim_value, t2.updated_at)
      FROM
      (
        SELECT
        p.policy_number,
       case when bwc.credibility_percent is null THEN '0.00'
       ELSE bwc.credibility_percent
       end as policy_credibility_percent,
        case when bwc.group_maximum_value is null THEN '250000'
       ELSE bwc.group_maximum_value
     end as policy_maximum_claim_value,
      run_date as updated_at

        from public.bwc_codes_credibility_max_losses bwc
        right Join public.final_policy_experience_calculations p
        ON bwc.credibility_group = p.policy_credibility_group
        WHERE p.representative_number = process_representative
      ) t2
      WHERE a.policy_number = t2.policy_number
      ;
      -- Update limited_loss_rate On Manual_class_level

      UPDATE public.final_manual_class_four_year_payroll_and_exp_losses a SET (manual_class_limited_loss_rate, updated_at) =
      (t2.limited_loss_rate, t2.updated_at)
      FROM

      (SELECT
        p.policy_number as policy_number,
        mc.manual_number as manual_number,
        bwc.limited_loss_ratio as limited_loss_rate,
        run_date as updated_at
      FROM public.final_policy_experience_calculations p
      RIGHT JOIN final_manual_class_four_year_payroll_and_exp_losses mc
      on p.policy_number = mc.policy_number
      RIGHT JOIN bwc_codes_limited_loss_ratios bwc
      ON  p.policy_credibility_group = bwc.credibility_group
       and mc.manual_class_industry_group = bwc.industry_group
      WHERE p.representative_number = process_representative
      ) t2
      WHERE t2.policy_number = a.policy_number and a.manual_number = t2.manual_number;





       -- Update Manual Class LImited Losses on the Manual Classes

      UPDATE public.final_manual_class_four_year_payroll_and_exp_losses a SET (manual_class_limited_losses, updated_at) =
      (t2.manual_class_limited_losses, t2.updated_at)
      FROM
      (
        SELECT
          b.policy_number as policy_number,
          b.manual_number as manual_number,
          round((manual_class_expected_losses * manual_class_limited_loss_rate)::numeric,2) as manual_class_limited_losses,
          run_date as updated_at
        FROM public.final_manual_class_four_year_payroll_and_exp_losses b
        WHERE b.representative_number = process_representative
      ) t2
      WHERE a.policy_number = t2.policy_number and a.manual_number = t2.manual_number;






      UPDATE public.final_policy_experience_calculations a SET (policy_total_limited_losses,updated_at) =
      (t2.policy_total_limited_losses, t2.updated_at)
      FROM
      (
        SELECT
        b.policy_number as policy_number,
        round(SUM(b.manual_class_limited_losses)::numeric,2) as policy_total_limited_losses,
        run_date as updated_at
        FROM public.final_manual_class_four_year_payroll_and_exp_losses b
        where b.representative_number = process_representative
        GROUP BY policy_number
      ) t2
      Where t2.policy_number = a.policy_number;



      end;

        $BODY$
      LANGUAGE plpgsql;

          })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_step_5(integer, date, date, date);
    })
  end
end
