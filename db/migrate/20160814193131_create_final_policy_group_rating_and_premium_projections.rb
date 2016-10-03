class CreateFinalPolicyGroupRatingAndPremiumProjections < ActiveRecord::Migration
  def change
    create_table :final_policy_group_rating_and_premium_projections do |t|
      t.integer :representative_number
      t.string :policy_type
      t.integer :policy_number
      t.index [:policy_number, :representative_number], name: 'index_pol_prem_pol_num_and_rep'
      t.integer :policy_industry_group
      t.string :policy_status
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
      t.string :data_source
      t.timestamps null: false
    end
  end
end
