class PolicyUpdateCreate
  @queue = :policy_update_create

  def self.perform(group_rating_id)
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Policies Updating"
    @group_rating.save
    FinalPolicyExperienceCalculation.find_each do |policy_exp|
        policy_proj = FinalPolicyGroupRatingAndPremiumProjection.find_by(policy_number: policy_exp.policy_number, representative_number: policy_exp.representative_number)
        @policy_demographic = FinalEmployerDemographicsInformation.find_by(policy_number: policy_exp.policy_number, representative_number: policy_exp.representative_number)
        @policy_calculation = PolicyCalculation.where(policy_number: policy_exp.policy_number, representative_number: policy_exp.representative_number).update_or_create(
          representative_number: policy_exp.representative_number,
          policy_group_number: policy_exp.policy_group_number,
          policy_status: policy_exp.policy_status,
          policy_total_four_year_payroll: policy_exp.policy_total_four_year_payroll,
          policy_credibility_group: policy_exp.policy_credibility_group,
          policy_maximum_claim_value: policy_exp.policy_maximum_claim_value,
          policy_credibility_percent: policy_exp.policy_credibility_percent,
          policy_total_expected_losses: policy_exp.policy_total_expected_losses,
          policy_total_limited_losses: policy_exp.policy_total_limited_losses,
          policy_total_claims_count: policy_exp.policy_total_claims_count,
          policy_total_modified_losses_group_reduced: policy_exp.policy_total_modified_losses_group_reduced,
          policy_total_modified_losses_individual_reduced: policy_exp.policy_total_modified_losses_individual_reduced,
          policy_group_ratio: policy_exp.policy_group_ratio,
          policy_individual_total_modifier: policy_exp.policy_individual_total_modifier,
          policy_individual_experience_modified_rate: policy_exp.policy_individual_experience_modified_rate,
          policy_industry_group: policy_proj.policy_industry_group,
          group_rating_qualification: policy_proj.group_rating_qualification,
          group_rating_tier: policy_proj.group_rating_tier,
          group_rating_group_number: policy_proj.group_rating_group_number,
          policy_total_current_payroll: policy_proj.policy_total_current_payroll,
          policy_total_standard_premium: policy_proj.policy_total_standard_premium,
          policy_total_individual_premium: policy_proj.policy_total_individual_premium,
          policy_total_group_premium: policy_proj.policy_total_group_premium,
          policy_total_group_savings: policy_proj.policy_total_group_savings,
          policy_group_fees:policy_proj.policy_group_fees,
          policy_group_dues: policy_proj.policy_group_dues,
          policy_total_costs:policy_proj.policy_total_costs,
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
          data_source: policy_exp.data_source)
    end
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Policy Updates Complete"
    @group_rating.save

    Resque.enqueue(ManualClassUpdateCreate, group_rating_id)

  end

end
