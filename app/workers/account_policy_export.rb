class AccountPolicyExport
  include Sidekiq::Worker

  sidekiq_options queue: :account_policy_export

  def perform(representative_id)
    # @representative = Representative.find(representative_id)
    # @accounts = Account.includes(:policy_calculation).where(representative_id: representative_id)


    @accounts = Account.includes(:policy_calculation).where(representative_id: 1)

    column_names = []
    column_names << ["id", "name", "policy_number_entered", "street_address", "street_address_2", "city", "state", "zip_code", "business_phone_number", "business_email_address", "website_url", "group_rating_qualification", "group_rating_tier", "group_rating_group_number", "group_premium", "group_savings", "group_fees", "group_dues", "total_costs", "status", "federal_identification_number", "cycle_date", "quarterly_request","weekly_request", "ac3_approval", "user_override", "policy_type", "policy_number", "policy_group_number", "policy_status", "policy_total_four_year_payroll", "policy_credibility_group", "policy_maximum_claim_value", "policy_credibility_percent", "policy_total_expected_losses", "policy_total_limited_losses", "policy_total_claims_count", "policy_total_modified_losses_group_reduced", "policy_total_modified_losses_individual_reduced", "policy_group_ratio", "policy_individual_total_modifier", "policy_individual_experience_modified_rate", "policy_industry_group", "group_rating_qualification", "group_rating_tier", "group_rating_group_number", "policy_total_current_payroll", "policy_total_standard_premium", "policy_total_individual_premium", "policy_total_group_premium", "policy_total_group_savings", "policy_group_fees", "policy_group_dues", "policy_total_costs", "successor_policy_number", "currently_assigned_representative_number", "federal_identification_number", "business_name", "trading_as_name", "in_care_name_contact_name", "address_1", "address_2", "city", "state", "zip_code", "zip_code_plus_4", "country_code", "county", "policy_creation_date", "current_policy_status", "current_policy_status_effective_date", "merit_rate", "group_code", "minimum_premium_percentage", "rate_adjust_factor", "em_effective_date", "regular_balance_amount", "attorney_general_balance_amount", "appealed_balance_amount", "pending_balance_amount", "advance_deposit_amount", "data_source", "created_at", "updated_at", "representative_id", "account_id"]

    CSV.generate(headers: true) do |csv|
      csv << column_names

      all.each do |account|
        csv << attributes.map{ |attr| policy.send(attr) }
      end
    end

    @accounts.each do |account|

    end

    puts column_names

  end
end
