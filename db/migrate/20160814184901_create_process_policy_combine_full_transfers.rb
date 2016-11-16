class CreateProcessPolicyCombineFullTransfers < ActiveRecord::Migration
  def change
    create_table :process_policy_combine_full_transfers do |t|
      t.integer :representative_number
      t.string :policy_type
      t.integer :manual_number
      t.string :manual_type
      t.date :reporting_period_start_date
      t.date :reporting_period_end_date
      t.float :manual_class_rate
      t.float :manual_class_payroll
      t.float :manual_class_premium
      t.string :predecessor_policy_type
      t.integer :predecessor_policy_number
      t.string :successor_policy_type
      t.integer :successor_policy_number
      t.string :transfer_type
      t.date :transfer_effective_date
      t.date :transfer_creation_date
      t.string :payroll_origin
      t.string :data_source

      t.timestamps null: false
    end
  end
end
