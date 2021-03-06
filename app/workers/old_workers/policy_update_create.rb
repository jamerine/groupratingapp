class PolicyUpdateCreate
  include Sidekiq::Worker

  sidekiq_options queue: :policy_update_create

  def perform(representative_number, policy_type, policy_number, policy_group_number, policy_status, policy_total_four_year_payroll, policy_credibility_group, policy_maximum_claim_value, policy_credibility_percent, policy_total_expected_losses, policy_total_limited_losses, policy_total_claims_count, policy_total_modified_losses_group_reduced, policy_total_modified_losses_individual_reduced, policy_group_ratio, policy_individual_total_modifier, policy_individual_experience_modified_rate, policy_industry_group, group_rating_qualification, group_rating_tier, group_rating_group_number, policy_total_current_payroll, policy_total_standard_premium, policy_total_individual_premium, policy_total_group_premium, policy_total_group_savings, policy_group_fees, policy_group_dues, policy_total_costs, successor_policy_number, currently_assigned_representative_number, federal_identification_number, business_name, trading_as_name, in_care_name_contact_name, address_1, address_2, city, state, zip_code, zip_code_plus_4, country_code, county, policy_creation_date, current_policy_status, current_policy_status_effective_date, merit_rate, group_code, minimum_premium_percentage, rate_adjust_factor, em_effective_date, regular_balance_amount, attorney_general_balance_amount, appealed_balance_amount, pending_balance_amount, advance_deposit_amount, data_source, representative_id)
    unless @account = Account.find_by(policy_number_entered: policy_number, representative_id: representative_id)
      @account = Account.create(policy_number_entered: policy_number, representative_id: representative_id, status: 3, name: business_name, street_address: address_1, street_address_2: address_2, city: city, state: state, zip_code: zip_code)
    end
    PolicyCalculation.where(policy_number: policy_number, representative_number: representative_number).update_or_create(
      representative_number: representative_number,
      policy_number: policy_number,
      policy_type: policy_type,
      policy_group_number: policy_group_number,
      policy_status: policy_status,
      policy_total_four_year_payroll: policy_total_four_year_payroll,
      policy_credibility_group: policy_credibility_group,
      policy_maximum_claim_value: policy_maximum_claim_value,
      policy_credibility_percent: policy_credibility_percent,
      policy_total_expected_losses: policy_total_expected_losses,
      policy_total_limited_losses: policy_total_limited_losses,
      policy_total_claims_count: policy_total_claims_count,
      policy_total_modified_losses_group_reduced: policy_total_modified_losses_group_reduced,
      policy_total_modified_losses_individual_reduced: policy_total_modified_losses_individual_reduced,
      policy_group_ratio: policy_group_ratio,
      policy_individual_total_modifier: policy_individual_total_modifier,
      policy_individual_experience_modified_rate: policy_individual_experience_modified_rate,
      policy_industry_group: policy_industry_group,
      group_rating_qualification: group_rating_qualification,
      group_rating_tier: group_rating_tier,
      group_rating_group_number: group_rating_group_number,
      policy_total_current_payroll: policy_total_current_payroll,
      policy_total_standard_premium: policy_total_standard_premium,
      policy_total_individual_premium: policy_total_individual_premium,
      policy_total_group_premium: policy_total_group_premium,
      policy_total_group_savings: policy_total_group_savings,
      policy_group_fees:policy_group_fees,
      policy_group_dues: policy_group_dues,
      policy_total_costs:policy_total_costs,
      successor_policy_number: successor_policy_number,
      currently_assigned_representative_number: currently_assigned_representative_number,
      federal_identification_number: federal_identification_number,
      business_name: business_name,
      trading_as_name: trading_as_name,
      in_care_name_contact_name: in_care_name_contact_name,
      address_1: address_1,
      address_2: address_2,
      city: city,
      state: state,
      zip_code: zip_code,
      zip_code_plus_4: zip_code_plus_4,
      country_code: country_code,
      county: county,
      policy_creation_date: policy_creation_date,
      current_policy_status: current_policy_status,
      current_policy_status_effective_date: current_policy_status_effective_date,
      merit_rate: merit_rate,
      group_code: group_code,
      minimum_premium_percentage: minimum_premium_percentage,
      rate_adjust_factor: rate_adjust_factor,
      em_effective_date: em_effective_date,
      regular_balance_amount: regular_balance_amount,
      attorney_general_balance_amount: attorney_general_balance_amount,
      appealed_balance_amount: appealed_balance_amount,
      pending_balance_amount: pending_balance_amount,
      advance_deposit_amount: advance_deposit_amount,
      data_source: data_source,
      representative_id: representative_id,
      account_id: @account.id)
  end

end
