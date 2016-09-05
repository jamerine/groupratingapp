class CreateFinalClaimCostCalculationTables < ActiveRecord::Migration
  def change
    create_table :final_claim_cost_calculation_tables do |t|
      t.integer :representative_number
      t.string :policy_type
      t.integer :policy_number
      t.index [:policy_number, :representative_number], name: 'index_cl_pol_num_and_rep'
      t.string :claim_number
      t.date :claim_injury_date
      t.float :claim_handicap_percent
      t.date :claim_handicap_percent_effective_date
      t.integer :claim_manual_number
      t.float :claim_medical_paid
      t.float :claim_mira_medical_reserve_amount
      t.float :claim_mira_non_reducible_indemnity_paid
      t.float :claim_mira_reducible_indemnity_paid
      t.float :claim_mira_indemnity_reserve_amount
      t.float :claim_mira_non_reducible_indemnity_paid_2
      t.float :claim_total_subrogation_collected
      t.float :claim_unlimited_limited_loss
      t.float :policy_individual_maximum_claim_value
      t.float :claim_group_multiplier
      t.float :claim_individual_multiplier
      t.float :claim_group_reduced_amount
      t.float :claim_individual_reduced_amount
      t.float :claim_subrogation_percent
      t.float :claim_modified_losses_group_reduced
      t.float :claim_modified_losses_individual_reduced
      t.string :data_source

      t.timestamps null: false
    end
  end
end
