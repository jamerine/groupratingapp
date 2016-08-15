class CreateFinalPolicyExperienceCalculations < ActiveRecord::Migration
  def change
    create_table :final_policy_experience_calculations do |t|
      t.integer :representative_number
      t.integer :policy_number
      t.index :policy_number
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
      t.string :data_source

      t.timestamps null: false
    end
  end
end
