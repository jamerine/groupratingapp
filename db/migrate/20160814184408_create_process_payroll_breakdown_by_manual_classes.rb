class CreateProcessPayrollBreakdownByManualClasses < ActiveRecord::Migration
  def change
    create_table :process_payroll_breakdown_by_manual_classes do |t|
      t.integer :representative_number
      t.string :policy_type
      t.integer :policy_number
      t.integer :manual_number
      t.index [:policy_number, :manual_number, :representative_number], name: 'index_proc_pr_by_man_cl_on_pol_and_man_rep'
      t.string :manual_type
      t.date :reporting_period_start_date
      t.date :reporting_period_end_date
      t.float :manual_class_rate
      t.float :manual_class_payroll
      t.float :manual_class_premium
      t.string :payroll_origin
      t.string :data_source
      t.timestamps null: false
    end


  end
end
