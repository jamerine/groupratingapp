class Step4Proc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_step_4(process_representative integer,
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
        -- STEP 4 -- Manual Class 4 Year Rollups
        -- Create table that adds up 4 year payroll for each unique policy number and manual class combination,
          -- Calculates expected losses for each manual class by joining bwc_codes_base_rates_exp_loss_rates table
          -- Adds industry_group to manual class by joining bwc_codes_ncci_manual_classes

        INSERT INTO final_manual_class_four_year_payroll_and_exp_losses
          (
            representative_number,
            policy_number,
            manual_number,
            manual_class_type,
            data_source,
            created_at,
            updated_at
          )
          (
            SELECT
            a.representative_number,
            a.policy_number,
            b.manual_number,
            b.manual_class_type,
            'bwc' as data_source,
            run_date as created_at,
            run_date as updated_at
          FROM public.final_employer_demographics_informations a
          Inner Join public.process_payroll_all_transactions_breakdown_by_manual_classes b
          ON a.policy_number = b.policy_number
          WHERE b.reporting_period_start_date >= experience_period_lower_date and a.representative_number = process_representative
          GROUP BY a.representative_number,
            a.policy_number,
            b.manual_number,
            b.manual_class_type
          );



          -- Broke manual_class payroll calculations into two tables.
          -- One  to calculate payroll and manual_reclass payroll when  a.reporting_period_start_date > edi.policy_creation_date because a payroll is only counted in your experience when you have a policy_created.

          -- One to calculate the payroll of transferred payroll from another policy.  This does not require a policy to be  created.


          INSERT INTO process_manual_class_four_year_payroll_with_conditions
          (
            representative_number,
            policy_number,
            manual_number,
            manual_class_type,
            manual_class_four_year_period_payroll,
            data_source,
            created_at,
            updated_at
          )
          (
            SELECT
              a.representative_number,
              a.policy_number,
              a.manual_number,
              a.manual_class_type,
              SUM(a.manual_class_payroll) as manual_class_four_year_period_payroll,
              'bwc' as data_source,
              run_date as created_at,
              run_date as updated_at
            FROM public.process_payroll_all_transactions_breakdown_by_manual_classes a
            Left Join public.final_employer_demographics_informations edi
            ON a.policy_number = edi.policy_number
            WHERE (a.reporting_period_start_date BETWEEN experience_period_lower_date and experience_period_upper_date)
            and a.representative_number = process_representative -- date range for experience_period
              and (a.payroll_origin = 'payroll' or a.payroll_origin = 'manual_reclass' or a.payroll_origin = 'payroll_adjustment') and (a.reporting_period_start_date >= edi.policy_creation_date )
            GROUP BY a.representative_number, a.policy_number, a.manual_number, a.manual_class_type
          );

            INSERT INTO process_manual_class_four_year_payroll_without_conditions
            (
              representative_number,
              policy_number,
              manual_number,
              manual_class_type,
              manual_class_four_year_period_payroll,
              data_source,
              created_at,
              updated_at
            )
            (
            SELECT
              a.representative_number,
              a.policy_number,
              a.manual_number,
              a.manual_class_type,
              SUM(a.manual_class_payroll) as manual_class_four_year_period_payroll,
              'bwc' as data_source,
              run_date as created_at,
              run_date as updated_at
            FROM public.process_payroll_all_transactions_breakdown_by_manual_classes a
            Left Join public.final_employer_demographics_informations edi
            ON a.policy_number = edi.policy_number
            WHERE (a.reporting_period_start_date BETWEEN experience_period_lower_date and experience_period_upper_date)
            and a.representative_number = process_representative -- date range for experience_period
              and (a.payroll_origin != 'payroll' and a.payroll_origin != 'manual_reclass' and a.payroll_origin != 'payroll_adjustment')
            GROUP BY a.representative_number, a.policy_number, a.manual_number, a.manual_class_type
            );





        -- Calculate manual_class_payroll

         UPDATE public.final_manual_class_four_year_payroll_and_exp_losses a SET (manual_class_four_year_period_payroll, updated_at) = (t2.manual_class_four_year_period_payroll, t2.updated_at)
         FROM
         (SELECT a.representative_number, a.policy_number, a.manual_number, a.manual_class_type,
        ROUND(((Case when wo.manual_class_four_year_period_payroll is null then '0'::decimal ELSE
        wo.manual_class_four_year_period_payroll END)
        + (Case when w.manual_class_four_year_period_payroll is null then '0'::decimal ELSE
        w.manual_class_four_year_period_payroll END))::numeric,2) as manual_class_four_year_period_payroll,
        run_date as updated_at
        FROM public.final_manual_class_four_year_payroll_and_exp_losses a
        Left join public.process_manual_class_four_year_payroll_without_conditions wo
        ON a.policy_number = wo.policy_number and a.manual_number = wo.manual_number and a.manual_class_type = wo.manual_class_type
        Left join public.process_manual_class_four_year_payroll_with_conditions w
        ON a.policy_number = w.policy_number and a.manual_number = w.manual_number and a.manual_class_type = w.manual_class_type
         ) t2
         WHERE a.policy_number = t2.policy_number and a.manual_number = t2.manual_number and a.manual_class_type = t2.manual_class_type and a.representative_number = t2.representative_number and a.representative_number = process_representative;









         UPDATE public.final_manual_class_four_year_payroll_and_exp_losses a SET (manual_class_expected_loss_rate, manual_class_base_rate, manual_class_expected_losses, manual_class_industry_group, updated_at) = (t2.manual_class_expected_loss_rate, t2.manual_class_base_rate, t2.manual_class_expected_losses, t2.manual_class_industry_group, t2.updated_at)
         FROM
         (  SELECT
             a.representative_number,
             a.policy_number,
             a.manual_number,
             a.manual_class_type,
             b.expected_loss_rate as manual_class_expected_loss_rate,
             b.base_rate as manual_class_base_rate,
             ROUND((a.manual_class_four_year_period_payroll * b.expected_loss_rate)::numeric, 4)
             as "manual_class_expected_losses",
             c.industry_group as "manual_class_industry_group",
             run_date as updated_at
           FROM public.final_manual_class_four_year_payroll_and_exp_losses a
           LEFT JOIN public.bwc_codes_base_rates_exp_loss_rates b
           ON a.manual_number = b.class_code
           LEFT JOIN public.bwc_codes_ncci_manual_classes c
           ON a.manual_number = c.ncci_manual_classification
           Left Join public.final_employer_demographics_informations edi
           ON a.policy_number = edi.policy_number
           ) t2
         WHERE a.policy_number = t2.policy_number and a.manual_number = t2.manual_number and a.manual_class_type = t2.manual_class_type and a.representative_number = t2.representative_number and (a.representative_number is not null) and a.representative_number = process_representative;




        -- 7/5/2016 __ CREATED NEW PEO TABLE called process_policy_experience_period_peo.
        -- This will calculate which policies were involved with a state fund or self insurred peo.
        -- It finds the most recent date of the effective_date for si peo or sf peo and documents it
        -- Then it finds the most recent termintation date for si peo or sf peo and documents it.
        -- If a policy is involved with a peo within the experience period, you will eventually reject that policy from getting quoted for group rating.


        -- Insert all policy_numbers and manual_numbers that are associated with a PEO LEASE
        INSERT INTO public.process_policy_experience_period_peos (
          representative_number,
          policy_type,
          policy_number,
          data_source,
          created_at,
          updated_at
        )
        (
          SELECT DISTINCT
               representative_number,
               predecessor_policy_type as policy_type,
               predecessor_policy_number as policy_number,
               'bwc' as data_source,
               run_date as created_at,
               run_date as updated_at
          FROM public.process_policy_combine_partial_to_full_leases
          where representative_number = process_representative
        );



        -- Self Insured  PEO LEASE INTO

         UPDATE public.process_policy_experience_period_peos mce SET
         (manual_class_si_peo_lease_effective_date, updated_at) = (t2.manual_class_si_peo_lease_effective_date, t2.updated_at)
         FROM
         (SELECT pcl.representative_number,
          pcl.predecessor_policy_number as policy_number,
          max(pcl.transfer_effective_date) as manual_class_si_peo_lease_effective_date,
          run_date as updated_at
         FROM public.process_policy_combine_partial_to_full_leases pcl
         -- Self Insured PEO
         WHERE pcl.successor_policy_type = 'private_self_insured' and pcl.successor_policy_number in (SELECT peo.policy_number FROM bwc_codes_peo_lists peo) and pcl.representative_number = process_representative
         GROUP BY pcl.representative_number,
          pcl.predecessor_policy_number
        ) t2
          WHERE mce.policy_number = t2.policy_number and mce.representative_number = t2.representative_number and (mce.representative_number is not null);

        --
        -- -- Self Insured PEO LEASE OUT
        --
        UPDATE public.process_policy_experience_period_peos mce SET
        (manual_class_si_peo_lease_termination_date, updated_at) = (t2.manual_class_si_peo_lease_termination_date, t2.updated_at)
        FROM
        ( SELECT pct.representative_number,
         pct.successor_policy_number as policy_number,
         max(pct.transfer_effective_date) as manual_class_si_peo_lease_termination_date,
         run_date as updated_at
        FROM public.process_policy_combination_lease_terminations pct
        WHERE pct.predecessor_policy_number in (SELECT peo.policy_number FROM bwc_codes_peo_lists peo) and pct.predecessor_policy_type = 'private_self_insured' and pct.representative_number = process_representative
        GROUP BY pct.representative_number,
         pct.successor_policy_number
        ) t2
        WHERE mce.policy_number = t2.policy_number and mce.representative_number = t2.representative_number and (mce.representative_number is not null);
        --
        -- -- State Fund PEO LEASE INTO
        --

     UPDATE public.process_policy_experience_period_peos mce SET
     (manual_class_sf_peo_lease_effective_date, updated_at) = (t2.manual_class_sf_peo_lease_effective_date, t2.updated_at)
     FROM
     (SELECT pcl.representative_number,
      pcl.predecessor_policy_number as policy_number,
      max(pcl.transfer_effective_date) as manual_class_sf_peo_lease_effective_date,
      run_date as updated_at
     FROM public.process_policy_combine_partial_to_full_leases pcl
     -- Self Insured PEO
     WHERE pcl.successor_policy_type != 'private_self_insured' and pcl.successor_policy_number in (SELECT peo.policy_number FROM bwc_codes_peo_lists peo) and pcl.representative_number = process_representative
     GROUP BY pcl.representative_number,
      pcl.predecessor_policy_number
    ) t2
      WHERE mce.policy_number = t2.policy_number and mce.representative_number = t2.representative_number and (mce.representative_number is not null);

    --
    -- -- Self Insured PEO LEASE OUT
    --
    UPDATE public.process_policy_experience_period_peos mce SET
    (manual_class_sf_peo_lease_termination_date, updated_at) = (t2.manual_class_sf_peo_lease_termination_date, t2.updated_at)
    FROM
    ( SELECT pct.representative_number,
     pct.successor_policy_number as policy_number,
     max(pct.transfer_effective_date) as manual_class_sf_peo_lease_termination_date,
     run_date as updated_at
    FROM public.process_policy_combination_lease_terminations pct
    WHERE pct.predecessor_policy_number in (SELECT peo.policy_number FROM bwc_codes_peo_lists peo) and pct.predecessor_policy_type != 'private_self_insured'and pct.representative_number = process_representative
    GROUP BY pct.representative_number,
     pct.successor_policy_number
    ) t2
    WHERE mce.policy_number = t2.policy_number and mce.representative_number = t2.representative_number and (mce.representative_number is not null);


    end;

      $BODY$
    LANGUAGE plpgsql;

    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_step_4(integer, date, date, date);
    })
  end
end
