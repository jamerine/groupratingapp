ActiveAdmin.register PolicyCalculation do
  actions :all, except: [:update, :destroy, :edit, :create, :new]
  config.per_page = [25, 50, 100]

  index do
    column :representative do |i|
      i.representative.abbreviated_name
    end
    column :policy_number
    column :business_name
    column '4yr Payroll', :policy_total_four_year_payroll
    column 'Cred Group', :policy_credibility_group
    column 'Max Claim Val', :policy_maximum_claim_value
    column 'Cred %', :policy_credibility_percent
    column 'Exp Loss', :policy_total_expected_losses
    column 'TLL', :policy_total_limited_losses
    column 'Claim Count', :policy_total_claims_count
    column 'Group TML', :policy_total_modified_losses_group_reduced
    column 'Ind TML', :policy_total_modified_losses_individual_reduced
    column 'Group Ratio', :policy_group_ratio
    column 'Ind Total Mod', :policy_individual_total_modifier
    column 'Ind Exp Mod Rate', :policy_individual_experience_modified_rate
    column 'Ind Adj Exp Mod Rate', :policy_individual_adjusted_experience_modified_rate
    column 'IG', :policy_industry_group
    column 'Current Payroll', :policy_total_current_payroll
    column 'Std Premium', :policy_total_standard_premium
    column 'Adj Std Premium', :policy_adjusted_standard_premium
    column 'Ind Premium', :policy_total_individual_premium
    column 'Coverage Status', :current_coverage_status
    column 'Status Eff Date', :coverage_status_effective_date
    column 'Creation Date', :policy_creation_date
    column 'FIN', :federal_identification_number
    column 'CLM Rep', :currently_assigned_clm_representative_number
    column 'Risk Rep', :currently_assigned_risk_representative_number
    column 'ERC Rep', :currently_assigned_erc_representative_number
    column 'GRC Rep', :currently_assigned_grc_representative_number
    column 'Imm Successor', :immediate_successor_policy_number
    column 'Ult Successor', :ultimate_successor_policy_number
    column 'Coverage Type', :policy_coverage_type
    column 'Employer Type', :policy_employer_type

    actions
  end

  filter :representative, as: :select, collection: Representative.options_for_select
  filter :policy_number_eq, label: 'Policy Number'
  filter :current_coverage_status

end
