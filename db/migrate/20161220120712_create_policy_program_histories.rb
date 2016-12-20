class CreatePolicyProgramHistories < ActiveRecord::Migration
  def change
    create_table :policy_program_histories do |t|
      t.references :policy_calculation, index: true, foreign_key: true
      t.references :representative, index: true, foreign_key: true
      t.integer :representative_number
      t.integer :policy_number
      t.integer :business_sequence_number
      t.float :experience_modifier_rate
      t.date :em_effective_date
      t.integer :policy_year
      t.date :reporting_period_start_date
      t.date :reporting_period_end_date
      t.string :group_participation_indicator
      t.integer :group_code
      t.string :group_type
      t.string :rrr_participation_indicator
      t.integer :rrr_tier
      t.integer  :rrr_policy_claim_limit
      t.integer :rrr_minimum_premium_percentage
      t.string :deductible_participation_indicator
      t.integer :deductible_level
      t.string :deductible_stop_loss_indicator
      t.integer :deductible_discount_percentage
      t.string :ocp_participation_indicator
      t.integer :ocp_participation
      t.integer :ocp_first_year_of_participation
      t.string :grow_ohio_participation_indicator
      t.string :em_cap_participation_indicator
      t.string :drug_free_program_participation_indicator
      t.string :drug_free_program_type
      t.string :drug_free_program_participation_level
      t.string :drug_free_program_discount_eligiblity_indicator
      t.string :issp_participation_indicator
      t.string :issp_discount_eligibility_indicator
      t.string :twbns_participation_indicator
      t.string :twbns_discount_eligibility_indicator

      t.timestamps null: false
    end
  end
end
