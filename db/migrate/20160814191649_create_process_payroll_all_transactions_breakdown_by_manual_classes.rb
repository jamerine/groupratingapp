class CreateProcessPayrollAllTransactionsBreakdownByManualClasses < ActiveRecord::Migration
  def change
    create_table :process_payroll_all_transactions_breakdown_by_manual_classes do |t|
      t.integer :representative_number
      t.string :policy_type
      t.integer :policy_number
      t.string :manual_type
      t.integer :manual_number
      t.index [:policy_number, :manual_number, :representative_number], name: 'index_pr_pol_num_and_man_num_rep'
      t.date :manual_class_effective_date
      t.float :manual_class_payroll
      t.string :payroll_origin
      t.string :data_source

      t.timestamps null: false
    end
  end
end
