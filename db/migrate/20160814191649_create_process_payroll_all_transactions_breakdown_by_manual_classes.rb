class CreateProcessPayrollAllTransactionsBreakdownByManualClasses < ActiveRecord::Migration
  def change
    create_table :process_payroll_all_transactions_breakdown_by_manual_classes do |t|
      t.integer :representative_number
      t.integer :policy_number
      t.integer :manual_number
      t.date :manual_class_effective_date
      t.float :manual_class_payroll
      t.string :payroll_origin
      t.string :data_sourc

      t.timestamps null: false
    end
  end
end