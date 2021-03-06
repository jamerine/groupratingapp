class CreateFinalManualClassGroupRatingAndPremiumProjections < ActiveRecord::Migration
  def change
      create_table :final_manual_class_group_rating_and_premium_projections do |t|
      t.integer :representative_number
      t.string :policy_type
      t.integer :policy_number
      t.integer :manual_number
      t.string :manual_class_type
      t.index [:policy_number, :manual_number, :representative_number], name: 'index_fin_man_pr_pol_num_and_man_num_rep'
      t.integer :manual_class_industry_group
      t.float :manual_class_industry_group_premium_total
      t.float :manual_class_current_estimated_payroll
      t.float :manual_class_base_rate
      t.float :manual_class_industry_group_premium_percentage
      t.float :manual_class_modification_rate
      t.float :manual_class_individual_total_rate
      t.float :manual_class_group_total_rate
      t.float :manual_class_standard_premium
      t.float :manual_class_estimated_group_premium
      t.float :manual_class_estimated_individual_premium
      t.string :data_source
      t.timestamps null: false
    end
  end
end
