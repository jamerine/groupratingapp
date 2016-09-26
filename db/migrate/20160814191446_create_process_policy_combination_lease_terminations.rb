class CreateProcessPolicyCombinationLeaseTerminations < ActiveRecord::Migration
  def change
    create_table :process_policy_combination_lease_terminations do |t|
      t.integer :representative_number
      t.string :valid_policy_number
      t.string :policy_combinations
      t.integer :predecessor_policy_type
      t.integer :predecessor_policy_number
      t.integer :successor_policy_type
      t.integer :successor_policy_number
      t.string :transfer_type
      t.date :transfer_effective_date
      t.date :transfer_creation_date
      t.string :partial_transfer_due_to_labor_lease
      t.string :labor_lease_type
      t.string :partial_transfer_payroll_movement
      t.integer :ncci_manual_number
      t.string :manual_coverage_type
      t.date :payroll_reporting_period_from_date
      t.date :payroll_reporting_period_to_date
      t.float :manual_payroll
      t.string :payroll_origin
      t.string :data_source
      t.timestamps null: false
    end
  end
end
