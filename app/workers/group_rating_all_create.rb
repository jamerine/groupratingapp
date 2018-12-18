class GroupRatingAllCreate
  include Sidekiq::Worker

  sidekiq_options queue: :group_rating_all_create, retry: 3

  def perform(group_rating_id, experience_period_lower_date, process_representative, representative_id, policy_number)


      @policy_demographic = FinalEmployerDemographicsInformation.find_by(policy_number: policy_number, representative_number: process_representative)
      # @policy_demographic = FinalEmployerDemographicsInformation.find_by(policy_number: 1740451, representative_number: 1740).nil? ? PolicyCalculation.find_by(policy_number: 1740451, representative_number: 1740) : FinalEmployerDemographicsInformation.find_by(policy_number: 1740451, representative_number: 1740)
      # @policy_demographic = FinalEmployerDemographicsInformation.find_by(policy_number: 1283284)

      unless @policy_demographic.nil?
        @account = Account.find_by(policy_number_entered: @policy_demographic.policy_number, representative_id: representative_id)
        # @account = Account.find_by(policy_number_entered: 1283284)

          if @account.nil?
            @account = Account.create(policy_number_entered: @policy_demographic.policy_number, representative_id: representative_id, status: 4, name: @policy_demographic.business_name, street_address: @policy_demographic.mailing_address_line_1, street_address_2: @policy_demographic.mailing_address_line_2, city: @policy_demographic.mailing_city, state: @policy_demographic.mailing_state, zip_code: @policy_demographic.mailing_zip_code, weekly_request: true)
          elsif @account.policy_calculation.policy_creation_date.nil?
            @account.update_attributes(policy_number_entered: @policy_demographic.policy_number, representative_id: representative_id, name: @policy_demographic.business_name, street_address: @policy_demographic.mailing_address_line_1, street_address_2: @policy_demographic.mailing_address_line_2, city: @policy_demographic.mailing_city, state: @policy_demographic.mailing_state, zip_code: @policy_demographic.mailing_zip_code)
          elsif @account.status == "predecessor"
            @account.update_attributes(policy_number_entered: @policy_demographic.policy_number, representative_id: representative_id, name: @policy_demographic.business_name, street_address: @policy_demographic.mailing_address_line_1, street_address_2: @policy_demographic.mailing_address_line_2, city: @policy_demographic.mailing_city, state: @policy_demographic.mailing_state, zip_code: @policy_demographic.mailing_zip_code)
          elsif @account.status == "invalid_policy_number"
            @account.update_attributes(policy_number_entered: @policy_demographic.policy_number, representative_id: representative_id, name: @policy_demographic.business_name, street_address: @policy_demographic.mailing_address_line_1, street_address_2: @policy_demographic.mailing_address_line_2, city: @policy_demographic.mailing_city, state: @policy_demographic.mailing_state, zip_code: @policy_demographic.mailing_zip_code, status: 2)
          end

        @policy_calculation = PolicyCalculation.where(account_id: @account.id).update_or_create(
            representative_number: @policy_demographic.representative_number,
            policy_number: @account.policy_number_entered,
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
            data_source: @policy_demographic.data_source,
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
                claim_combined: claim.claim_combined,
                combined_into_claim_number: claim.combined_into_claim_number,
                claim_rating_plan_indicator: claim.claim_rating_plan_indicator,
                claim_status: claim.claim_status,
                claim_status_effective_date: claim.claim_status_effective_date,
                claim_type: claim.claim_type,
                claim_activity_status: claim.claim_activity_status,
                claim_activity_status_effective_date: claim.claim_activity_status_effective_date,
                settled_claim: claim.settled_claim,
                settlement_type: claim.settlement_type,
                medical_settlement_date: claim.medical_settlement_date,
                indemnity_settlement_date: claim.indemnity_settlement_date,
                maximum_medical_improvement_date: claim.maximum_medical_improvement_date,
                claim_mira_ncci_injury_type: claim.claim_mira_ncci_injury_type,
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

            PemhDetailRecord.where(representative_number: @policy_calculation.representative_number, policy_number: @policy_calculation.policy_number).find_each do |policy_program_history|
              PolicyProgramHistory.where(policy_calculation_id: @policy_calculation.id, representative_id: @policy_calculation.representative_id, reporting_period_start_date: policy_program_history.reporting_period_start_date, reporting_period_end_date: policy_program_history.reporting_period_end_date).update_or_create(
                representative_id: @policy_calculation.representative_id,
                policy_calculation_id: @policy_calculation.id,
                representative_number: policy_program_history.representative_number,
                policy_number: policy_program_history.policy_number,
                business_sequence_number: policy_program_history.business_sequence_number,
                experience_modifier_rate: policy_program_history.experience_modifier_rate,
                em_effective_date: policy_program_history.em_effective_date,
                policy_year: policy_program_history.policy_year,
                reporting_period_start_date: policy_program_history.reporting_period_start_date,
                reporting_period_end_date: policy_program_history.reporting_period_end_date,
                group_participation_indicator: policy_program_history.group_participation_indicator,
                group_code: policy_program_history.group_code,
                group_type: policy_program_history.group_type,
                rrr_participation_indicator: policy_program_history.rrr_participation_indicator,
                rrr_tier: policy_program_history.rrr_tier,
                rrr_policy_claim_limit: policy_program_history.rrr_policy_claim_limit,
                rrr_minimum_premium_percentage: policy_program_history.rrr_minimum_premium_percentage,
                deductible_participation_indicator: policy_program_history.deductible_participation_indicator,
                deductible_level: policy_program_history.deductible_level,
                deductible_stop_loss_indicator: policy_program_history.deductible_stop_loss_indicator,
                deductible_discount_percentage: policy_program_history.deductible_discount_percentage,
                ocp_participation_indicator: policy_program_history.ocp_participation_indicator,
                ocp_participation: policy_program_history.ocp_participation,
                ocp_first_year_of_participation: policy_program_history.ocp_first_year_of_participation,
                grow_ohio_participation_indicator: policy_program_history.grow_ohio_participation_indicator,
                em_cap_participation_indicator: policy_program_history.em_cap_participation_indicator,
                drug_free_program_participation_indicator: policy_program_history.drug_free_program_participation_indicator,
                drug_free_program_type: policy_program_history.drug_free_program_type,
                drug_free_program_participation_level: policy_program_history.drug_free_program_participation_level,
                drug_free_program_discount_eligiblity_indicator: policy_program_history.drug_free_program_discount_eligiblity_indicator,
                issp_participation_indicator: policy_program_history.issp_participation_indicator,
                issp_discount_eligibility_indicator: policy_program_history.issp_discount_eligibility_indicator,
                twbns_participation_indicator: policy_program_history.twbns_participation_indicator,
                twbns_discount_eligibility_indicator: policy_program_history.twbns_discount_eligibility_indicator
              )

            end

            unless FinalManualClassFourYearPayrollAndExpLoss.where(representative_number: @policy_calculation.representative_number, policy_number: @policy_calculation.policy_number).empty?

              FinalManualClassFourYearPayrollAndExpLoss.where(representative_number: @policy_calculation.representative_number, policy_number: @policy_calculation.policy_number).find_each do |man_class_exp|
                      @manual_class_calculation = ManualClassCalculation.where(policy_calculation_id: @policy_calculation.id, manual_number: man_class_exp.manual_number).update_or_create(
                        representative_number: man_class_exp.representative_number,
                        policy_number: man_class_exp.policy_number,
                        policy_calculation_id: @policy_calculation.id,
                        manual_number: man_class_exp.manual_number,
                        manual_class_type: man_class_exp.manual_class_type,
                        manual_class_base_rate: man_class_exp.manual_class_base_rate,
                        manual_class_industry_group: man_class_exp.manual_class_industry_group,
                        data_source: man_class_exp.data_source)


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
                      manual_class_transferred: payroll_transaction.manual_class_transferred,
                      transfer_creation_date: payroll_transaction.transfer_creation_date,
                      payroll_origin: payroll_transaction.payroll_origin,
                      data_source: payroll_transaction.data_source
                      ).update_or_create(
                        representative_number: payroll_transaction.representative_number,
                        policy_number: payroll_transaction.policy_number,
                        manual_class_type: payroll_transaction.manual_class_type,
                        manual_number: payroll_transaction.manual_number,
                        manual_class_calculation_id: @manual_class_calculation.id,
                        manual_class_rate: payroll_transaction.manual_class_rate,
                        reporting_period_start_date: payroll_transaction.reporting_period_start_date,
                        reporting_period_end_date: payroll_transaction.reporting_period_end_date,
                        policy_transferred: payroll_transaction.policy_transferred,
                        manual_class_transferred: payroll_transaction.manual_class_transferred,
                        transfer_creation_date: payroll_transaction.transfer_creation_date,
                        manual_class_payroll: payroll_transaction.manual_class_payroll,
                        reporting_type: payroll_transaction.reporting_type,
                        number_of_employees: payroll_transaction.number_of_employees,
                        payroll_origin: payroll_transaction.payroll_origin,
                        data_source: payroll_transaction.data_source
                      )
                    end
                  end

                  #Fix for termination of peos without a negative action on the transfer
                  @termination_peo_payroll = @manual_class_calculation.payroll_calculations.where(payroll_origin: 'lease_terminated')
                  @termination_peo_payroll.each do |term_payroll|
                    if @manual_class_calculation.payroll_calculations.find_by(reporting_period_start_date: term_payroll.reporting_period_start_date, reporting_period_end_date: term_payroll.reporting_period_end_date, manual_class_payroll: term_payroll.manual_class_payroll, payroll_origin: 'payroll') && !@manual_class_calculation.payroll_calculations.find_by(reporting_period_start_date: term_payroll.reporting_period_start_date, reporting_period_end_date: term_payroll.reporting_period_end_date, manual_class_payroll: (-term_payroll.manual_class_payroll), payroll_origin: 'partial_to_full_lease')
                      PayrollCalculation.where(representative_number: term_payroll.representative_number,
                        policy_number: term_payroll.policy_number,
                        manual_class_type: term_payroll.manual_class_type,
                        manual_number: term_payroll.manual_number,
                        manual_class_calculation_id: @manual_class_calculation.id,
                        manual_class_rate: term_payroll.manual_class_rate,
                        reporting_period_start_date: term_payroll.reporting_period_start_date,
                        reporting_period_end_date: term_payroll.reporting_period_end_date,
                        policy_transferred: term_payroll.policy_transferred,
                        manual_class_transferred: term_payroll.manual_class_transferred,
                        transfer_creation_date: term_payroll.transfer_creation_date,
                        manual_class_payroll: (-term_payroll.manual_class_payroll),
                        reporting_type: term_payroll.reporting_type,
                        number_of_employees: term_payroll.number_of_employees,
                        payroll_origin: term_payroll.payroll_origin,
                        data_source: term_payroll.data_source).update_or_create(
                          representative_number: term_payroll.representative_number,
                          policy_number: term_payroll.policy_number,
                          manual_class_type: term_payroll.manual_class_type,
                          manual_number: term_payroll.manual_number,
                          manual_class_calculation_id: @manual_class_calculation.id,
                          manual_class_rate: term_payroll.manual_class_rate,
                          reporting_period_start_date: term_payroll.reporting_period_start_date,
                          reporting_period_end_date: term_payroll.reporting_period_end_date,
                          policy_transferred: term_payroll.policy_transferred,
                          manual_class_transferred: term_payroll.manual_class_transferred,
                          transfer_creation_date: term_payroll.transfer_creation_date,
                          manual_class_payroll: (-term_payroll.manual_class_payroll),
                          reporting_type: term_payroll.reporting_type,
                          number_of_employees: term_payroll.number_of_employees,
                          payroll_origin: term_payroll.payroll_origin,
                          data_source: term_payroll.data_source
                      )
                    end
                  end
            end
          end
          @account.policy_calculation.calculate_experience
          @account.policy_calculation.calculate_premium
          @account.group_rating
          @account.group_retro
      else

        # PREDECESSOR PAYROLL FIX - 9/5/2017
        @policy_demographic = PolicyCalculation.find_by(policy_number: policy_number, representative_number: process_representative)
        # @policy_demographic = PolicyCalculation.find_by(policy_number: 1740451, representative_number: 1740)
        unless @policy_demographic.nil?
          @account = Account.find_by(policy_number_entered: @policy_demographic.policy_number, representative_id: representative_id)
          @account.policy_calculation.manual_class_calculations.each do |manual_class|
            ProcessPayrollAllTransactionsBreakdownByManualClass.where("reporting_period_start_date >= :reporting_period_start_date and representative_number = :representative_number and manual_number = :manual_number and policy_number = :policy_number",  reporting_period_start_date: experience_period_lower_date, representative_number: process_representative, manual_number: manual_class.manual_number, policy_number: manual_class.policy_number).find_each do |payroll_transaction|
              unless manual_class.nil? || payroll_transaction.id.nil? || payroll_transaction.manual_number == 0
                PayrollCalculation.where(representative_number: payroll_transaction.representative_number,
                policy_number: payroll_transaction.policy_number,
                manual_class_type: payroll_transaction.manual_class_type,
                manual_number: payroll_transaction.manual_number,
                manual_class_calculation_id: manual_class.id,
                reporting_period_start_date: payroll_transaction.reporting_period_start_date,
                reporting_period_end_date: payroll_transaction.reporting_period_end_date,
                policy_transferred: payroll_transaction.policy_transferred,
                manual_class_transferred: payroll_transaction.manual_class_transferred,
                transfer_creation_date: payroll_transaction.transfer_creation_date,
                payroll_origin: payroll_transaction.payroll_origin,
                data_source: payroll_transaction.data_source
                ).update_or_create(
                  representative_number: payroll_transaction.representative_number,
                  policy_number: payroll_transaction.policy_number,
                  manual_class_type: payroll_transaction.manual_class_type,
                  manual_number: payroll_transaction.manual_number,
                  manual_class_calculation_id: manual_class.id,
                  manual_class_rate: payroll_transaction.manual_class_rate,
                  reporting_period_start_date: payroll_transaction.reporting_period_start_date,
                  reporting_period_end_date: payroll_transaction.reporting_period_end_date,
                  policy_transferred: payroll_transaction.policy_transferred,
                  manual_class_transferred: payroll_transaction.manual_class_transferred,
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
          @account.group_retro
        end
      end
  end

end
