class PolicyUpdateCreate
  @queue = :policy_update_create

  def self.perform()

    FinalPolicyExperienceCalculation.find_each do |policy_exp|
        policy_proj = FinalPolicyGroupRatingAndPremiumProjection.find_by(policy_number: policy_exp.policy_number, representative_number: policy_exp.representative_number)
        PolicyCalculation.where(policy_number: policy_exp.policy_number, representative_number: policy_exp.representative_number).update_or_create(
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
          data_source: policy_exp.data_source)
    end
  end

end
