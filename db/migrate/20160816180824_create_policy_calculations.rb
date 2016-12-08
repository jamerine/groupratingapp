class CreatePolicyCalculations < ActiveRecord::Migration
  def change
    create_table :policy_calculations do |t|
      t.integer :representative_number
      t.integer :policy_number
      t.index :policy_number, name: 'index_policy_calculations_on_pol_num'
      t.string :policy_group_number
      t.float :policy_total_four_year_payroll
      t.integer :policy_credibility_group
      t.integer :policy_maximum_claim_value
      t.float :policy_credibility_percent
      t.float :policy_total_expected_losses
      t.float :policy_total_limited_losses
      t.integer :policy_total_claims_count
      t.float :policy_total_modified_losses_group_reduced
      t.float :policy_total_modified_losses_individual_reduced
      t.float :policy_group_ratio
      t.float :policy_individual_total_modifier
      t.float :policy_individual_experience_modified_rate
      t.integer :policy_industry_group
      t.float :policy_total_current_payroll
      t.float :policy_total_standard_premium
      t.float :policy_total_individual_premium
      t.integer :currently_assigned_representative_number
      t.string  :valid_policy_number
      t.string  :current_coverage_status
      t.date    :coverage_status_effective_date
      t.date    :policy_creation_date
      t.string :federal_identification_number
      t.string :business_name
      t.string :trading_as_name
      t.string :in_care_name_contact_name
      t.string  :valid_mailing_address
      t.string  :mailing_address_line_1
      t.string  :mailing_address_line_2
      t.string  :mailing_city
      t.string  :mailing_state
      t.integer :mailing_zip_code
      t.integer :mailing_zip_code_plus_4
      t.integer :mailing_country_code
      t.integer :mailing_county
      t.string  :valid_location_address
      t.string  :location_address_line_1
      t.string  :location_address_line_2
      t.string  :location_city
      t.string  :location_state
      t.integer :location_zip_code
      t.integer :location_zip_code_plus_4
      t.integer :location_country_code
      t.integer :location_county
      t.integer :currently_assigned_clm_representative_number
      t.integer :currently_assigned_risk_representative_number
      t.integer :currently_assigned_erc_representative_number
      t.integer :currently_assigned_grc_representative_number
      t.integer :immediate_successor_policy_number
      t.integer :immediate_successor_business_sequence_number
      t.integer :ultimate_successor_policy_number
      t.integer :ultimate_successor_business_sequence_number
      t.string  :employer_type
      t.string  :coverage_type
      t.string  :policy_coverage_type
      t.string  :policy_employer_type
      t.float :merit_rate
      t.string :group_code
      t.string :minimum_premium_percentage
      t.string :rate_adjust_factor
      t.date :em_effective_date
      t.float :regular_balance_amount
      t.float :attorney_general_balance_amount
      t.float :appealed_balance_amount
      t.float :pending_balance_amount
      t.float :advance_deposit_amount
      t.string :data_source

      t.timestamps null: false
    end
  end
end
