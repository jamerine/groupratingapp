class CreatePcombDetailRecords < ActiveRecord::Migration
  def change
    create_table :pcomb_detail_records do |t|
      t.integer :representative_number
      t.integer :representative_type
      t.integer :record_type
      t.integer :requestor_number
      t.string :policy_type
      t.integer :policy_number
      t.integer :business_sequence_number
      t.string :valid_policy_number
      t.string :policy_combinations
      t.string :predecessor_policy_type
      t.integer :predecessor_policy_number
      t.string :predecessor_filler
      t.string :predecessor_business_sequence_number
      t.string :successor_policy_type
      t.integer :successor_policy_number
      t.string :successor_filler
      t.string :successor_business_sequence_number
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

      t.timestamps null: false
    end
  end
end
