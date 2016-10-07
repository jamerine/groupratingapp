class CreatePolicyCalculations < ActiveRecord::Migration
  def change
    create_table :policy_calculations do |t|
      t.integer :representative_number
      t.string :policy_type
      t.integer :policy_number
      t.index :policy_number, name: 'index_policy_calculations_on_pol_num'
      t.string :policy_group_number
      t.string :policy_status
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
      t.string :group_rating_qualification 
      t.float :group_rating_tier
      t.integer :group_rating_group_number
      t.float :policy_total_current_payroll
      t.float :policy_total_standard_premium
      t.float :policy_total_individual_premium
      t.float :policy_total_group_premium
      t.float :policy_total_group_savings
      t.float :policy_group_fees
      t.float :policy_group_dues
      t.float :policy_total_costs
      t.integer :successor_policy_number
      t.integer :currently_assigned_representative_number
      t.string :federal_identification_number
      t.string :business_name
      t.string :trading_as_name
      t.string :in_care_name_contact_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :zip_code_plus_4
      t.string :country_code
      t.string :county
      t.date :policy_creation_date
      t.string :current_policy_status
      t.date :current_policy_status_effective_date
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
