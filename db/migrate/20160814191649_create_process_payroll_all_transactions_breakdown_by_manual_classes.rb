class CreateProcessPayrollAllTransactionsBreakdownByManualClasses < ActiveRecord::Migration
  def change
    create_table :process_payroll_all_transactions_breakdown_by_manual_classes do |t|
      t.integer :representative_number
      t.string :policy_type
      t.integer :policy_number
      t.date :policy_status_effective_date
      t.string :policy_status
      t.integer :manual_number
      t.index [:policy_number, :manual_number, :representative_number], name: 'index_pr_pol_num_and_man_num_rep'
      t.string :manual_class_type
      t.string :manual_class_description
      t.integer :bwc_customer_id
      t.date :reporting_period_start_date
      t.date :reporting_period_end_date
      t.float :manual_class_rate
      t.float :manual_class_payroll
      t.string :reporting_type
      t.integer :number_of_employees
      t.integer :policy_transferred
      t.date :transfer_creation_date
      t.string :payroll_origin
      t.string :data_source

      t.timestamps null: false
    end
  end
end
