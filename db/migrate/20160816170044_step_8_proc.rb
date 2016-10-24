class Step8Proc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      -- STEP 8 of process

      CREATE OR REPLACE FUNCTION public.proc_step_8(process_representative integer,
      experience_period_lower_date date,
      experience_period_upper_date date,
      current_payroll_period_lower_date date
      )
      RETURNS void AS
      $BODY$

      DECLARE
        run_date timestamp := LOCALTIMESTAMP;
      BEGIN

      -- STEP 8A -- CREATE FINAL POLICY PREMIUMS AND PROJECTIONS

      Insert into final_policy_group_rating_and_premium_projections
      (
        representative_number,
        policy_type,
        policy_number,
        policy_status,
        data_source,
        created_at,
        updated_at
      )
      (Select
        representative_number,
        policy_type,
        policy_number,
        policy_status,
        'bwc' as data_source,
        run_date as created_at,
        run_date as updated_at
      FROM final_policy_experience_calculations
      WHERE representative_number = process_representative
      );


      -- STEP 8B -- CREATE MANUAL LEVEL GROUP RATING AND PREMIUM CALCULATIONS


      INSERT INTO final_manual_class_group_rating_and_premium_projections
      (
        representative_number,
        policy_type,
        policy_number,
        manual_number,
        -- ADD ALL INDUSTRY_GROUP'S PAYROLL WITHIN A POLICY_NUMBER SURE TO UPDATE THIS AFTER GOING AF
        -- PAYROLL IS PREVIOUS EXPERIENCE YEARS PAYROLL FROM THE TRANSACTIONS TABLE 'July & January'
        manual_class_current_estimated_payroll,
        data_source,
        created_at,
        updated_at
      )
      (
        SELECT
          a.representative_number,
          a.policy_type,
          a.policy_number,
          b.manual_number,
          round(sum(b.manual_class_payroll)::numeric,2) as manual_class_current_estimated_payroll,
          'bwc' as data_source,
          run_date as created_at,
          run_date as updated_at
        FROM public.final_employer_demographics_informations a
        Inner Join public.process_payroll_all_transactions_breakdown_by_manual_classes b
        ON a.policy_number = b.policy_number
        WHERE (b.manual_class_effective_date >= current_payroll_period_lower_date) and a.representative_number = process_representative
        GROUP BY a.representative_number, a.policy_type, a.policy_number, b.manual_number
      );



      -- UPDATE THE Industry_group
      update public.final_manual_class_group_rating_and_premium_projections mcgr SET (manual_class_industry_group, updated_at)  = (t1.manual_class_industry_group, t1.updated_at)
      FROM
      (SELECT
        a.policy_number as policy_number,
        a.manual_number as manual_number,
        c.industry_group as manual_class_industry_group,
        run_date as updated_at
      FROM public.final_manual_class_group_rating_and_premium_projections a
      LEFT JOIN public.bwc_codes_ncci_manual_classes c
      ON a.manual_number = c.ncci_manual_classification
      WHERE a.representative_number = process_representative
      ) t1
      WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_number = t1.manual_number
      ;


      -- Update base_rate of manual_cass
      update public.final_manual_class_group_rating_and_premium_projections mcgr SET (manual_class_base_rate, updated_at)  = (t1.manual_class_base_rate, t1.updated_at)
      FROM
      (SELECT
        a.policy_number as policy_number,
        a.manual_number as manual_number,
        b.base_rate as manual_class_base_rate,
        run_date as updated_at
      FROM public.final_manual_class_group_rating_and_premium_projections a
      LEFT JOIN public.bwc_codes_base_rates_exp_loss_rates b
      ON a.manual_number = b.class_code
      WHERE a.representative_number = process_representative
      ) t1
      WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_number = t1.manual_number;


      update public.final_manual_class_group_rating_and_premium_projections mcgr SET (manual_class_standard_premium, updated_at)  = (t1.manual_class_standard_premium, t1.updated_at)
      FROM
      (SELECT
        a.policy_number as policy_number,
        a.manual_number as manual_number,
        round((a.manual_class_base_rate * a.manual_class_current_estimated_payroll * pec.policy_individual_experience_modified_rate)::numeric,2) as manual_class_standard_premium,
        run_date as updated_at
      FROM public.final_manual_class_group_rating_and_premium_projections a
      LEFT JOIN public.final_policy_experience_calculations pec
      ON a.policy_number = pec.policy_number
      WHERE a.representative_number = process_representative
      ) t1
      WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_number = t1.manual_number;



      -- UPDATE manual_class industry_group PAYROLL totals
      update public.final_manual_class_group_rating_and_premium_projections mcgr SET
      (manual_class_industry_group_premium_total, updated_at) = (t1.manual_class_industry_group_premium_total, t1.updated_at)
      FROM
        (
      SELECT
      a.policy_number as policy_number,
      a.manual_class_industry_group as manual_class_industry_group,
      round(sum(a.manual_class_standard_premium)::numeric,2) as manual_class_industry_group_premium_total,
      run_date as updated_at
      FROM public.final_manual_class_group_rating_and_premium_projections a
      WHERE a.representative_number = process_representative
      GROUP BY a.policy_number, a.manual_class_industry_group
        ) t1
        WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_class_industry_group = t1.manual_class_industry_group
      ;



       update public.final_policy_group_rating_and_premium_projections pgr SET (policy_total_standard_premium, updated_at) =
       (t1.policy_total_standard_premium, t1.updated_at)
       FROM
       (SELECT
           a.policy_number as policy_number,
         sum(a.manual_class_standard_premium) as policy_total_standard_premium,
         run_date as updated_at
         FROM public.final_manual_class_group_rating_and_premium_projections a
         WHERE a.representative_number = process_representative
         GROUP BY a.policy_number
       ) t1
       WHERE pgr.policy_number = t1.policy_number;




      update public.final_policy_group_rating_and_premium_projections pgr SET (policy_total_current_payroll, updated_at) =
      (t1.policy_total_current_payroll, t1.updated_at)
      FROM
      (SELECT
          a.policy_number as policy_number,
        sum(a.manual_class_current_estimated_payroll) as policy_total_current_payroll,
        run_date as updated_at
        FROM public.final_manual_class_group_rating_and_premium_projections a
        WHERE a.representative_number = process_representative
        GROUP BY a.policy_number
      ) t1
      WHERE pgr.policy_number = t1.policy_number;




      --
      --
      --
       -- UPDATE manual_class_industry_group_payroll_percentage
       update public.final_manual_class_group_rating_and_premium_projections mcgr SET
       (manual_class_industry_group_premium_percentage, updated_at) = (t1.manual_class_industry_group_premium_percentage, t1.updated_at)
       FROM
       (SELECT mc.policy_number, mc.manual_number,
       round((CASE WHEN (p.policy_total_standard_premium is null) or (p.policy_total_standard_premium = '0') or (mc.manual_class_industry_group_premium_total = '0') or (mc.manual_class_industry_group_premium_total is null) THEN '0'
       	ELSE
       ( mc.manual_class_industry_group_premium_total / p.policy_total_standard_premium)
       END )::numeric,3) as manual_class_industry_group_premium_percentage,
       run_date as updated_at
       FROM public.final_manual_class_group_rating_and_premium_projections mc
       RIGHT JOIN public.final_policy_group_rating_and_premium_projections p
       ON mc.policy_number = p.policy_number
       WHERE p.representative_number = process_representative
       ) t1
       WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_number = t1.manual_number;


      -- UPDATE  modification rate
       update public.final_manual_class_group_rating_and_premium_projections mcgr SET
       (manual_class_modification_rate, updated_at) = (t1.manual_class_modification_rate, t1.updated_at)
       FROM
       (
         SELECT
         a.policy_number as policy_number,
         a.manual_number as manual_number,
         round((a.manual_class_base_rate * plec.policy_individual_experience_modified_rate)::numeric,4) as manual_class_modification_rate,
         run_date as updated_at
           FROM public.final_manual_class_group_rating_and_premium_projections a
           LEFT JOIN public.final_policy_experience_calculations plec
           ON a.policy_number = plec.policy_number
           WHERE a.representative_number = process_representative
         ) t1
         WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_number = t1.manual_number;



      -- update Individual Total Rate
      UPDATE public.final_manual_class_group_rating_and_premium_projections mcgr SET
      (manual_class_individual_total_rate) =
      (round((manual_class_modification_rate *  (1 + (SELECT rate from public.bwc_codes_constant_values
      where name = 'administrative_rate' and completed_date is null)))::numeric,6));


      -- ADDED Logic to find industry_group by using the Homogeneity File

      update public.final_policy_group_rating_and_premium_projections c SET
        (policy_industry_group, updated_at) = (t1.manual_class, t1.updated_at)
        FROM
        (SELECT a.policy_number as policy_number,
            	(SELECT cast_to_int(b.industry_code)
      	FROM public.phmgn_detail_records b
      	WHERE  b.policy_number = a.policy_number and cast_to_int(b.industry_code) != 0
             ORDER BY premium_percentage DESC NULLS LAST LIMIT 1) as manual_class,
             run_date as updated_at
        FROM final_policy_group_rating_and_premium_projections a
        ) t1
        WHERE c.policy_number = t1.policy_number;



      -- Update policy industry group based on highest payroll percentage by industry group of all manual classes.
        -- Adds up like manual classes if different manual classes for a policy belong to the same policy.


      update public.final_policy_group_rating_and_premium_projections c SET
        (policy_industry_group, updated_at) = (t1.manual_class, t1.updated_at)
        FROM
      (SELECT a.policy_number as policy_number,
      	(SELECT b.manual_class_industry_group
      	FROM final_manual_class_group_rating_and_premium_projections b
      	WHERE  b.policy_number = a.policy_number
              ORDER BY manual_class_industry_group_premium_percentage DESC NULLS LAST LIMIT 1) as manual_class,
              run_date as updated_at
      FROM final_policy_group_rating_and_premium_projections a
      WHERE a.representative_number = process_representative
        ) t1
        WHERE c.policy_number = t1.policy_number and c.policy_industry_group is null;



      -- ADD logic to update a  new industry_group when the industry_group is 10.

      -- LOGIC: query to find the policy_numbers that have an industry_group of 10 and a experience ratio between .05 and .86
              -- THEN find a manual_class within for a policy_number within that list that has a 20% or above premium for the policy_number
      UPDATE public.final_policy_group_rating_and_premium_projections c SET
        (policy_industry_group, updated_at) = (t1.manual_class_industry_group, t1.updated_at)
      FROM
      (SELECT l.policy_number, l.manual_class_industry_group, run_date as updated_at
          FROM public.final_manual_class_group_rating_and_premium_projections l
          WHERE policy_number in (SELECT fp.policy_number
          FROM public.final_policy_group_rating_and_premium_projections fp
          WHERE fp.policy_industry_group = '10' and fp.representative_number = process_representative) and policy_number in (SELECT fpe.policy_number FROM final_policy_experience_calculations fpe where fpe.policy_group_ratio between '.05' and '.86')
          and manual_class_industry_group != '10' and manual_class_industry_group_premium_percentage > '.2'
          and representative_number = process_representative
          GROUP BY representative_number, policy_number, manual_class_industry_group, manual_class_industry_group_premium_percentage
          ORDER BY manual_class_industry_group_premium_percentage
        ) t1
        WHERE c.policy_number = t1.policy_number;


      -- 06/06/2016 ADDED condition for creating group_rating_tier only when the policy_status is Active, ReInsured, or Lapse
      -- update group_rating_tier

      -- update public.final_policy_group_rating_and_premium_projections c SET
      -- (group_rating_tier, updated_at)	= (t1.group_rating_tier, t1.updated_at)
      -- FROM
      -- 	(SELECT
      -- 		a.policy_number,
      -- 		(SELECT (CASE WHEN (a.policy_group_ratio = '0') THEN '-.53'
      -- 					ELSE min(market_rate)
      -- 					END)  as group_rating_tier
      -- 				 FROM public.bwc_codes_industry_group_savings_ratio_criteria
      -- 				 WHERE (a.policy_group_ratio /ratio_criteria <= 1) and (industry_group = b.policy_industry_group)),
      --          run_date as updated_at
      -- 			FROM public.final_policy_experience_calculations a
      --       LEFT JOIN final_policy_group_rating_and_premium_projections b
      --       ON a.policy_number = b.policy_number
      --       WHERE a.representative_number = process_representative and a.policy_group_ratio is not null
      -- 			GROUP BY a.policy_number, a.policy_group_ratio, a.policy_status, b.policy_industry_group
      -- 		) t1
      -- WHERE c.policy_number = t1.policy_number;




      -- UPDATE public.final_manual_class_group_rating_and_premium_projections mcgr SET
      -- (manual_class_group_total_rate, updated_at) = (t1.manual_class_group_total_rate, t1.updated_at)
      -- FROM
      -- (
      --  SELECT a.policy_number as policy_number,
      --    a.manual_number as manual_number,
      --    ((1+ b.group_rating_tier) * a.manual_class_base_rate * (1 + (SELECT rate from public.bwc_codes_constant_values
      --    where name = 'administrative_rate' and completed_date is null))) as manual_class_group_total_rate,
      --    run_date as updated_at
      --  FROM public.final_manual_class_group_rating_and_premium_projections a
      --  Left Join public.final_policy_group_rating_and_premium_projections b
      --  ON a.policy_number = b.policy_number
      --  WHERE a.representative_number = process_representative
      -- ) t1
      -- WHERE mcgr.policy_number = t1.policy_number and mcgr.manual_number = t1.manual_number;



      --Update Premium Values
           UPDATE public.final_manual_class_group_rating_and_premium_projections mcgr SET
           (
           manual_class_estimated_group_premium,
           manual_class_estimated_individual_premium) =
           (
           manual_class_current_estimated_payroll * manual_class_group_total_rate
           ,
           manual_class_current_estimated_payroll * manual_class_individual_total_rate
           );


      UPDATE public.final_policy_group_rating_and_premium_projections pgr SET (policy_total_individual_premium, updated_at) = (t1.policy_total_individual_premium, t1.updated_at)
      FROM
      (SELECT a.policy_number,
        round(SUM(a.manual_class_estimated_individual_premium)::numeric,2) as policy_total_individual_premium,
        run_date as updated_at
        FROM public.final_manual_class_group_rating_and_premium_projections a
        WHERE a.representative_number = process_representative
        Group BY a.policy_number
      ) t1
      WHERE pgr.policy_number = t1.policy_number;


      -- Update policy_total_group_savings
      -- UPDATE public.final_policy_group_rating_and_premium_projections pgr SET (policy_total_group_savings, updated_at) =
      -- (t1.policy_total_group_savings, t1.updated_at)
      -- FROM
      -- (SELECT a.policy_number,
      --   round((a.policy_total_individual_premium - a.policy_total_group_premium)::numeric,2) as policy_total_group_savings,
      --   run_date as updated_at
      -- FROM final_policy_group_rating_and_premium_projections a
      -- WHERE a.representative_number = process_representative
      --) t1
      --WHERE pgr.policy_number = t1.policy_number;


      DELETE FROM process_policy_experience_period_peos
      WHERE id IN (SELECT id
                   FROM (SELECT id,
                                  ROW_NUMBER() OVER (partition BY representative_number, policy_type, policy_number, manual_class_sf_peo_lease_effective_date,
       manual_class_sf_peo_lease_termination_date, manual_class_si_peo_lease_effective_date,
       manual_class_si_peo_lease_termination_date, data_source ORDER BY id) AS rnum
                          FROM process_policy_experience_period_peos) t
                   WHERE t.rnum > 1);

      end;

        $BODY$
      LANGUAGE plpgsql;

    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_step_8(integer, date, date, date);
    })
  end
end
