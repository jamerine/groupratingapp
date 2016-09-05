class CreateFinalManualClassFourYearPayrollAndExpLosses < ActiveRecord::Migration
  def change
    create_table :final_manual_class_four_year_payroll_and_exp_losses do |t|
      t.integer :representative_number
      t.integer :policy_number
      t.integer :manual_number
      t.index [:policy_number, :manual_number, :representative_number], name: 'index_man_pr_pol_num_and_man_num_rep'
      t.float :manual_class_four_year_period_payroll
      t.float :manual_class_expected_loss_rate
      t.float :manual_class_base_rate
      t.float :manual_class_expected_losses
      t.integer :manual_class_industry_group
      t.float :manual_class_limited_loss_rate
      t.float :manual_class_limited_losses
      t.string :data_source
      t.timestamps null: false
    end
  end
end
