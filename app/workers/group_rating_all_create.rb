class GroupRatingAllCreate
  include Sidekiq::Worker

  sidekiq_options queue: :group_rating_all_create

  def perform(group_rating_id, experience_period_lower_date, process_representative, representative_id, policy_number)

      @policy_exp = FinalPolicyExperienceCalculation.find_by(policy_number: policy_number, representative_number: process_representative)
      @policy_proj = FinalPolicyGroupRatingAndPremiumProjection.find_by(policy_number: @policy_exp.policy_number, representative_number: @policy_exp.representative_number)

      @policy_demographic = FinalEmployerDemographicsInformation.find_by(policy_number: @policy_exp.policy_number, representative_number: @policy_exp.representative_number)

      @account = Account.where(policy_number_entered: @policy_exp.policy_number, representative_id: representative_id)
      # @account = Account.where(policy_number_entered: 1638083, representative_id: 17)
      # @account.first.status == "predecessor"

        if @account.empty?
          @account = @account.create(policy_number_entered: @policy_exp.policy_number, representative_id: representative_id, status: 4, name: @policy_demographic.business_name, street_address: @policy_demographic.mailing_address_line_1, street_address_2: @policy_demographic.mailing_address_line_2, city: @policy_demographic.mailing_city, state: @policy_demographic.mailing_state, zip_code: @policy_demographic.mailing_zip_code, weekly_request: true)
        elsif @account.first.status == "predecessor"
          @account = @account.first
          @account.update_attributes(policy_number_entered: @policy_exp.policy_number, representative_id: representative_id, name: @policy_demographic.business_name, street_address: @policy_demographic.mailing_address_line_1, street_address_2: @policy_demographic.mailing_address_line_2, city: @policy_demographic.mailing_city, state: @policy_demographic.mailing_state, zip_code: @policy_demographic.mailing_zip_code)
        else
          @account = @account.first
        end


      @policy_calculation = PolicyCalculation.where(account_id: @account.id).update_or_create(
          representative_number: @policy_exp.representative_number,
          policy_number: @account.policy_number_entered,
          policy_group_number: @policy_exp.policy_group_number,
          # policy_total_four_year_payroll: @policy_exp.policy_total_four_year_payroll,
          # policy_credibility_group: @policy_exp.policy_credibility_group,
          # policy_maximum_claim_value: @policy_exp.policy_maximum_claim_value,
          # policy_credibility_percent: @policy_exp.policy_credibility_percent,
          # policy_total_expected_losses: @policy_exp.policy_total_expected_losses,
          # policy_total_limited_losses: @policy_exp.policy_total_limited_losses,
          # policy_total_claims_count: @policy_exp.policy_total_claims_count,
          # policy_total_modified_losses_group_reduced: @policy_exp.policy_total_modified_losses_group_reduced,
          # policy_total_modified_losses_individual_reduced:
          # @policy_exp.policy_total_modified_losses_individual_reduced,
          # policy_group_ratio:
          # @policy_exp.policy_group_ratio,
          # policy_individual_total_modifier:
          # @policy_exp.policy_individual_total_modifier,
          # policy_individual_experience_modified_rate:
          # @policy_exp.policy_individual_experience_modified_rate,
          # policy_industry_group: @policy_proj.policy_industry_group,
          # policy_total_current_payroll: @policy_proj.policy_total_current_payroll,
          # policy_total_standard_premium: @policy_proj.policy_total_standard_premium,
          # policy_total_individual_premium: @policy_proj.policy_total_individual_premium,
          currently_assigned_representative_number: @policy_demographic.currently_assigned_representative_number,
          valid_policy_number: @policy_demographic.valid_policy_number,
          current_coverage_status: @policy_demographic.current_coverage_status.strip,
          coverage_status_effective_date: @policy_demographic.coverage_status_effective_date,
          policy_creation_date: @policy_demographic.policy_creation_date,
          federal_identification_number: @policy_demographic.federal_identification_number,
          business_name: @policy_demographic.business_name,
          trading_as_name: @policy_demographic.trading_as_name,
          valid_mailing_address: @policy_demographic.valid_mailing_address,
          mailing_address_line_1: @policy_demographic.mailing_address_line_1,
          mailing_address_line_2: @policy_demographic.mailing_address_line_2,
          mailing_city: @policy_demographic.mailing_city,
          mailing_state: @policy_demographic.mailing_state,
          mailing_zip_code: @policy_demographic.mailing_zip_code,
          mailing_zip_code_plus_4: @policy_demographic.mailing_zip_code_plus_4,
          mailing_country_code: @policy_demographic.mailing_country_code,
          mailing_county: @policy_demographic.mailing_county,
          valid_location_address: @policy_demographic.valid_location_address,
          location_address_line_1: @policy_demographic.location_address_line_1,
          location_address_line_2: @policy_demographic.location_address_line_2,
          location_city: @policy_demographic.location_city,
          location_state: @policy_demographic.location_state,
          location_zip_code: @policy_demographic.location_zip_code,
          location_zip_code_plus_4: @policy_demographic.location_zip_code_plus_4,
          location_country_code: @policy_demographic.location_country_code,
          location_county: @policy_demographic.location_county,
          currently_assigned_clm_representative_number: @policy_demographic.currently_assigned_clm_representative_number,
          currently_assigned_risk_representative_number: @policy_demographic.currently_assigned_risk_representative_number,
          currently_assigned_erc_representative_number: @policy_demographic.currently_assigned_erc_representative_number,
          currently_assigned_grc_representative_number: @policy_demographic.currently_assigned_grc_representative_number,
          immediate_successor_policy_number: @policy_demographic.immediate_successor_policy_number,
          immediate_successor_business_sequence_number: @policy_demographic.immediate_successor_business_sequence_number,
          ultimate_successor_policy_number: @policy_demographic.ultimate_successor_policy_number,
          ultimate_successor_business_sequence_number: @policy_demographic.ultimate_successor_business_sequence_number,
          employer_type: @policy_demographic.employer_type,
          coverage_type: @policy_demographic.coverage_type,
          policy_coverage_type: @policy_demographic.policy_coverage_type,
          policy_employer_type: @policy_demographic.policy_employer_type,
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

          ProcessPolicyCoverageStatusHistory.where(representative_number: @policy_calculation.representative_number, policy_number: @policy_calculation.policy_number).find_each do |policy_coverage|
            PolicyCoverageStatusHistory.where(policy_calculation_id: @policy_calculation.id, policy_number: @policy_calculation.policy_number, representative_number: @policy_calculation.representative_number, coverage_effective_date: policy_coverage.coverage_effective_date, coverage_status: policy_coverage.coverage_status).update_or_create(
                    policy_calculation_id: @policy_calculation.id,
                    representative_id: @policy_calculation.representative_id,
                    representative_number: @policy_calculation.representative_number,
                    policy_number: @policy_calculation.policy_number,
                    coverage_effective_date: policy_coverage.coverage_effective_date,
                    coverage_end_date: policy_coverage.coverage_end_date,
                    coverage_status: policy_coverage.coverage_status,
                    lapse_days: policy_coverage.lapse_days,
                    data_source: policy_coverage.data_source
                )

          end


          FinalManualClassFourYearPayrollAndExpLoss.where(representative_number: @policy_calculation.representative_number, policy_number: @policy_calculation.policy_number).find_each do |man_class_exp|
              man_class_proj = FinalManualClassGroupRatingAndPremiumProjection.find_by(policy_number: man_class_exp.policy_number, manual_number: man_class_exp.manual_number, representative_number: man_class_exp.representative_number)
                if !man_class_proj.nil?
                  @manual_class_calculation = ManualClassCalculation.where(policy_calculation_id: @policy_calculation.id, manual_number: man_class_exp.manual_number).update_or_create(
                    representative_number: man_class_exp.representative_number,
                    policy_number: man_class_exp.policy_number,
                    policy_calculation_id: @policy_calculation.id,
                    manual_number: man_class_exp.manual_number,
                    # manual_class_four_year_period_payroll: man_class_exp.manual_class_four_year_period_payroll,
                    # manual_class_expected_loss_rate: man_class_exp.manual_class_expected_loss_rate,
                    manual_class_base_rate: man_class_exp.manual_class_base_rate,
                    # manual_class_expected_losses: man_class_exp.manual_class_expected_losses,
                    # manual_class_limited_loss_rate: man_class_exp.manual_class_limited_loss_rate,
                    # manual_class_limited_losses: man_class_exp.manual_class_limited_losses,
                    manual_class_industry_group: man_class_proj.manual_class_industry_group,
                    # manual_class_industry_group_premium_total: man_class_proj.manual_class_industry_group_premium_total,
                    # manual_class_current_estimated_payroll: man_class_proj.manual_class_current_estimated_payroll,
                    # manual_class_industry_group_premium_percentage: man_class_proj.manual_class_industry_group_premium_percentage,
                    # manual_class_modification_rate: man_class_proj.manual_class_modification_rate,
                    # manual_class_individual_total_rate: man_class_proj.manual_class_individual_total_rate,
                    # manual_class_group_total_rate: man_class_proj.manual_class_group_total_rate,
                    # manual_class_standard_premium: man_class_proj.manual_class_standard_premium,
                    # manual_class_estimated_group_premium: man_class_proj.manual_class_estimated_group_premium,
                    # manual_class_estimated_individual_premium: man_class_proj.manual_class_estimated_individual_premium,
                    data_source: man_class_proj.data_source)
                else
                  @manual_class_calculation = ManualClassCalculation.where(policy_calculation_id: @policy_calculation.id, manual_number: man_class_exp.manual_number).update_or_create(
                    representative_number: man_class_exp.representative_number,
                    policy_number: man_class_exp.policy_number,
                    policy_calculation_id: @policy_calculation.id,
                    manual_number: man_class_exp.manual_number,
                    # manual_class_four_year_period_payroll: man_class_exp.manual_class_four_year_period_payroll,
                    # manual_class_expected_loss_rate: man_class_exp.manual_class_expected_loss_rate,
                    manual_class_base_rate: man_class_exp.manual_class_base_rate,
                    # manual_class_expected_losses: man_class_exp.manual_class_expected_losses,
                    # manual_class_limited_loss_rate: man_class_exp.manual_class_limited_loss_rate,
                    # manual_class_limited_losses: man_class_exp.manual_class_limited_losses,
                    # manual_class_industry_group: 0,
                    # manual_class_industry_group_premium_total: 0,
                    # manual_class_current_estimated_payroll: 0,
                    # manual_class_industry_group_premium_percentage: 0,
                    # manual_class_modification_rate: 0,
                    # manual_class_individual_total_rate: 0,
                    # manual_class_group_total_rate: 0,
                    # manual_class_standard_premium: 0,
                    # manual_class_estimated_group_premium: 0,
                    # manual_class_estimated_individual_premium: 0,
                    data_source: man_class_exp.data_source)
              end
              ProcessPayrollAllTransactionsBreakdownByManualClass.where("reporting_period_start_date >= :reporting_period_start_date and representative_number = :representative_number and manual_number = :manual_number and policy_number = :policy_number",  reporting_period_start_date: experience_period_lower_date, representative_number: process_representative, manual_number: @manual_class_calculation.manual_number, policy_number: @manual_class_calculation.policy_number).find_each do |payroll_transaction|
                unless @manual_class_calculation.nil? || payroll_transaction.id.nil? || payroll_transaction.manual_number == 0
                  PayrollCalculation.where(representative_number: payroll_transaction.representative_number,
                  policy_number: payroll_transaction.policy_number,
                  manual_class_type: payroll_transaction.manual_class_type,
                  manual_number: payroll_transaction.manual_number,
                  manual_class_calculation_id: @manual_class_calculation.id,
                  reporting_period_start_date: payroll_transaction.reporting_period_start_date,
                  reporting_period_end_date: payroll_transaction.reporting_period_end_date,
                  policy_transferred: payroll_transaction.policy_transferred,
                  transfer_creation_date: payroll_transaction.transfer_creation_date,
                  payroll_origin: payroll_transaction.payroll_origin,
                  data_source: payroll_transaction.data_source).update_or_create(
                    representative_number: payroll_transaction.representative_number,
                    policy_number: payroll_transaction.policy_number,
                    manual_class_type: payroll_transaction.manual_class_type,
                    manual_number: payroll_transaction.manual_number,
                    manual_class_calculation_id: @manual_class_calculation.id,
                    reporting_period_start_date: payroll_transaction.reporting_period_start_date,
                    reporting_period_end_date: payroll_transaction.reporting_period_end_date,
                    policy_transferred: payroll_transaction.policy_transferred,
                    transfer_creation_date: payroll_transaction.transfer_creation_date,
                    manual_class_payroll: payroll_transaction.manual_class_payroll,
                    reporting_type: payroll_transaction.reporting_type,
                    number_of_employees: payroll_transaction.number_of_employees,
                    payroll_origin: payroll_transaction.payroll_origin,
                    data_source: payroll_transaction.data_source
                  )
                end
              end
        end

        @account.policy_calculation.calculate_experience
        @account.policy_calculation.calculate_premium
        @account.group_rating
  end

end
