class GroupRatingAllCreate
  include Sidekiq::Worker

  sidekiq_options queue: :group_rating_all_create

  def perform(group_rating_id, experience_period_lower_date, process_representative, representative_id, policy_number)
      @policy_exp = FinalPolicyExperienceCalculation.find_by(policy_number: policy_number, representative_number: process_representative)
      @policy_proj = FinalPolicyGroupRatingAndPremiumProjection.find_by(policy_number: @policy_exp.policy_number, representative_number: @policy_exp.representative_number)

      @policy_demographic = FinalEmployerDemographicsInformation.find_by(policy_number: @policy_exp.policy_number, representative_number: @policy_exp.representative_number)

      @account = Account.where(policy_number_entered: @policy_exp.policy_number, representative_id: representative_id).update_or_create(policy_number_entered: @policy_exp.policy_number, representative_id: representative_id, status: 3, name: @policy_demographic.business_name, street_address: @policy_demographic.address_1, street_address_2: @policy_demographic.address_2, city: @policy_demographic.city, state: @policy_demographic.state, zip_code: @policy_demographic.zip_code)

      @policy_calculation = PolicyCalculation.where(account_id: @account.id).update_or_create(
          representative_number: @policy_exp.representative_number,
          policy_type: @policy_exp.policy_type,
          policy_number: @account.policy_number_entered,
          policy_group_number: @policy_exp.policy_group_number,
          policy_status: @policy_exp.policy_status,
          policy_total_four_year_payroll: @policy_exp.policy_total_four_year_payroll,
          policy_credibility_group: @policy_exp.policy_credibility_group,
          policy_maximum_claim_value: @policy_exp.policy_maximum_claim_value,
          policy_credibility_percent: @policy_exp.policy_credibility_percent,
          policy_total_expected_losses: @policy_exp.policy_total_expected_losses,
          policy_total_limited_losses: @policy_exp.policy_total_limited_losses,
          policy_total_claims_count: @policy_exp.policy_total_claims_count,
          policy_total_modified_losses_group_reduced: @policy_exp.policy_total_modified_losses_group_reduced,
          policy_total_modified_losses_individual_reduced:
          @policy_exp.policy_total_modified_losses_individual_reduced,
          policy_group_ratio:
          @policy_exp.policy_group_ratio,
          policy_individual_total_modifier:
          @policy_exp.policy_individual_total_modifier,
          policy_individual_experience_modified_rate:
          @policy_exp.policy_individual_experience_modified_rate,
          policy_industry_group: @policy_proj.policy_industry_group,
          group_rating_qualification: @policy_proj.group_rating_qualification,
          group_rating_tier: @policy_proj.group_rating_tier,
          group_rating_group_number: @policy_proj.group_rating_group_number,
          policy_total_current_payroll: @policy_proj.policy_total_current_payroll,
          policy_total_standard_premium: @policy_proj.policy_total_standard_premium,
          policy_total_individual_premium: @policy_proj.policy_total_individual_premium,
          policy_total_group_premium: @policy_proj.policy_total_group_premium,
          policy_total_group_savings: @policy_proj.policy_total_group_savings,
          policy_group_fees: @policy_proj.policy_group_fees,
          policy_group_dues: @policy_proj.policy_group_dues,
          policy_total_costs: @policy_proj.policy_total_costs,
          successor_policy_number: @policy_demographic.successor_policy_number,
          currently_assigned_representative_number: @policy_demographic.currently_assigned_representative_number,
          federal_identification_number: @policy_demographic.federal_identification_number,
          business_name: @policy_demographic.business_name,
          trading_as_name: @policy_demographic.trading_as_name,
          in_care_name_contact_name: @policy_demographic.in_care_name_contact_name,
          address_1: @policy_demographic.address_1,
          address_2: @policy_demographic.address_2,
          city: @policy_demographic.city,
          state: @policy_demographic.state,
          zip_code: @policy_demographic.zip_code,
          zip_code_plus_4: @policy_demographic.zip_code_plus_4,
          country_code: @policy_demographic.country_code,
          county: @policy_demographic.county,
          policy_creation_date: @policy_demographic.policy_creation_date,
          current_policy_status: @policy_demographic.current_policy_status,
          current_policy_status_effective_date: @policy_demographic.current_policy_status_effective_date,
          merit_rate: @policy_demographic.merit_rate,
          group_code: @policy_demographic.group_code,
          minimum_premium_percentage: @policy_demographic.minimum_premium_percentage,
          rate_adjust_factor: @policy_demographic.rate_adjust_factor,
          em_effective_date: @policy_demographic.em_effective_date,
          regular_balance_amount: @policy_demographic.regular_balance_amount,
          attorney_general_balance_amount: @policy_demographic.attorney_general_balance_amount,
          appealed_balance_amount: @policy_demographic.appealed_balance_amount,
          pending_balance_amount: @policy_demographic.pending_balance_amount,
          advance_deposit_amount: @policy_demographic.advance_deposit_amount,
          data_source: @policy_exp.data_source,
          representative_id: @account.representative_id,
          account_id: @account.id
          )

          FinalClaimCostCalculationTable.where(representative_number: @policy_calculation.representative_number, policy_number: @policy_calculation.policy_number).each do |claim|
            ClaimCalculation.where(representative_number: claim.representative_number, policy_number: claim.policy_number, claim_number: claim.claim_number).update_or_create(
              representative_number: claim.representative_number,
              policy_type: claim.policy_type,
              policy_number: claim.policy_number,
              policy_calculation_id: @policy_calculation.id,
              claim_number: claim.claim_number,
              claim_injury_date: claim.claim_injury_date,
              claim_handicap_percent: claim.claim_handicap_percent,
              claim_handicap_percent_effective_date: claim.claim_handicap_percent_effective_date,
              claimant_name: claim.claimant_name,
              claimant_date_of_birth: claim.claimant_date_of_birth,
              claimant_date_of_death: claim.claimant_date_of_death,
              claim_manual_number: claim.claim_manual_number,
              claim_medical_paid: claim.claim_medical_paid,
              claim_mira_medical_reserve_amount: claim.claim_mira_medical_reserve_amount,
              claim_mira_non_reducible_indemnity_paid: claim.claim_mira_non_reducible_indemnity_paid,
              claim_mira_reducible_indemnity_paid: claim.claim_mira_reducible_indemnity_paid,
              claim_mira_indemnity_reserve_amount: claim.claim_mira_indemnity_reserve_amount,
              claim_mira_non_reducible_indemnity_paid_2: claim.claim_mira_non_reducible_indemnity_paid_2,
              claim_total_subrogation_collected: claim.claim_total_subrogation_collected,
              claim_unlimited_limited_loss: claim.claim_unlimited_limited_loss,
              policy_individual_maximum_claim_value: claim.policy_individual_maximum_claim_value,
              claim_group_multiplier: claim.claim_group_multiplier,
              claim_individual_multiplier: claim.claim_individual_multiplier,
              claim_group_reduced_amount: claim.claim_group_reduced_amount,
              claim_individual_reduced_amount: claim.claim_individual_reduced_amount,
              claim_subrogation_percent: claim.claim_subrogation_percent,
              claim_modified_losses_group_reduced: claim.claim_modified_losses_group_reduced,
              claim_modified_losses_individual_reduced: claim.claim_modified_losses_individual_reduced,
              data_source: claim.data_source)
          end


          FinalManualClassFourYearPayrollAndExpLoss.where(representative_number: @policy_calculation.representative_number, policy_number: @policy_calculation.policy_number).each do |man_class_exp|
              man_class_proj = FinalManualClassGroupRatingAndPremiumProjection.find_by(policy_number: man_class_exp.policy_number, manual_number: man_class_exp.manual_number, representative_number: man_class_exp.representative_number)
                if !man_class_proj.nil?
                  @manual_class_calculation = ManualClassCalculation.where(policy_calculation_id: @policy_calculation.id, manual_number: man_class_exp.manual_number).update_or_create(
                    representative_number: man_class_exp.representative_number,
                    policy_number: man_class_exp.policy_number,
                    policy_calculation_id: @policy_calculation.id,
                    manual_number: man_class_exp.manual_number,
                    manual_class_four_year_period_payroll: man_class_exp.manual_class_four_year_period_payroll,
                    manual_class_expected_loss_rate: man_class_exp.manual_class_expected_loss_rate,
                    manual_class_base_rate: man_class_exp.manual_class_base_rate,
                    manual_class_expected_losses: man_class_exp.manual_class_expected_losses,
                    manual_class_limited_loss_rate: man_class_exp.manual_class_limited_loss_rate,
                    manual_class_limited_losses: man_class_exp.manual_class_limited_losses,
                    manual_class_industry_group: man_class_proj.manual_class_industry_group,
                    manual_class_industry_group_premium_total: man_class_proj.manual_class_industry_group_premium_total,
                    manual_class_current_estimated_payroll: man_class_proj.manual_class_current_estimated_payroll,
                    manual_class_industry_group_premium_percentage: man_class_proj.manual_class_industry_group_premium_percentage,
                    manual_class_modification_rate: man_class_proj.manual_class_modification_rate,
                    manual_class_individual_total_rate: man_class_proj.manual_class_individual_total_rate,
                    manual_class_group_total_rate: man_class_proj.manual_class_group_total_rate,
                    manual_class_standard_premium: man_class_proj.manual_class_standard_premium,
                    manual_class_estimated_group_premium: man_class_proj.manual_class_estimated_group_premium,
                    manual_class_estimated_individual_premium: man_class_proj.manual_class_estimated_individual_premium,
                    data_source: man_class_proj.data_source)
                else
                  @manual_class_calculation = ManualClassCalculation.where(policy_calculation_id: @policy_calculation.id, manual_number: man_class_exp.manual_number).update_or_create(
                    representative_number: man_class_exp.representative_number,
                    policy_number: man_class_exp.policy_number,
                    policy_calculation_id: @policy_calculation.id,
                    manual_number: man_class_exp.manual_number,
                    manual_class_four_year_period_payroll: man_class_exp.manual_class_four_year_period_payroll,
                    manual_class_expected_loss_rate: man_class_exp.manual_class_expected_loss_rate,
                    manual_class_base_rate: man_class_exp.manual_class_base_rate,
                    manual_class_expected_losses: man_class_exp.manual_class_expected_losses,
                    manual_class_limited_loss_rate: man_class_exp.manual_class_limited_loss_rate,
                    manual_class_limited_losses: man_class_exp.manual_class_limited_losses,
                    manual_class_industry_group: 0,
                    manual_class_industry_group_premium_total: 0,
                    manual_class_current_estimated_payroll: 0,
                    manual_class_industry_group_premium_percentage: 0,
                    manual_class_modification_rate: 0,
                    manual_class_individual_total_rate: 0,
                    manual_class_group_total_rate: 0,
                    manual_class_standard_premium: 0,
                    manual_class_estimated_group_premium: 0,
                    manual_class_estimated_individual_premium: 0,
                    data_source: man_class_exp.data_source)
              end
              ProcessPayrollAllTransactionsBreakdownByManualClass.where("manual_class_effective_date >= :manual_class_effective_date and representative_number = :representative_number and manual_number = :manual_number and policy_number = :policy_number",  manual_class_effective_date: experience_period_lower_date, representative_number: process_representative, manual_number: @manual_class_calculation.manual_number, policy_number: @manual_class_calculation.policy_number).find_each do |payroll_transaction|
                unless @manual_class_calculation.nil? || payroll_transaction.id.nil? || payroll_transaction.manual_number == 0
                  PayrollCalculation.where(representative_number: payroll_transaction.representative_number,
                  policy_type: payroll_transaction.policy_type,
                  policy_number: payroll_transaction.policy_number,
                  manual_type: payroll_transaction.manual_type,
                  manual_number: payroll_transaction.manual_number,
                  manual_class_calculation_id: @manual_class_calculation.id,
                  manual_class_effective_date: payroll_transaction.manual_class_effective_date,
                  payroll_origin: payroll_transaction.payroll_origin,
                  data_source: payroll_transaction.data_source).update_or_create(
                    representative_number: payroll_transaction.representative_number,
                    policy_type: payroll_transaction.policy_type,
                    policy_number: payroll_transaction.policy_number,
                    manual_type: payroll_transaction.manual_type,
                    manual_number: payroll_transaction.manual_number,
                    manual_class_calculation_id: @manual_class_calculation.id,
                    manual_class_effective_date: payroll_transaction.manual_class_effective_date,
                    manual_class_payroll: payroll_transaction.manual_class_payroll,
                    payroll_origin: payroll_transaction.payroll_origin,
                    data_source: payroll_transaction.data_source
                  )
                end
              end
        end
      @account.group_rating
  end

end
