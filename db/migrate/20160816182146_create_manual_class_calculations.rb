class CreateManualClassCalculations < ActiveRecord::Migration
  def change
    create_table :manual_class_calculations do |t|
      t.integer :representative_number
      t.references :policy_calculation, index: true, foreign_key: true
      t.integer :policy_number
      t.string :manual_class_type
      t.integer :manual_number
      t.index [:policy_number, :manual_number], name: 'index_man_class_calc_pol_num_and_man_num'
      t.float :manual_class_four_year_period_payroll
      t.float :manual_class_expected_loss_rate
      t.float :manual_class_base_rate
      t.float :manual_class_expected_losses
      t.integer :manual_class_industry_group
      t.float :manual_class_limited_loss_rate
      t.float :manual_class_limited_losses
      t.float :manual_class_industry_group_premium_total
      t.float :manual_class_current_estimated_payroll
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
