class CreateProcessPayrollBreakdownByManualClasses < ActiveRecord::Migration
  def change
    create_table :process_payroll_breakdown_by_manual_class do |t|
      t.integer :representative_number
      t.string :policy_type
      t.integer :policy_number
      t.integer :manual_number
      t.index [:policy_number, :manual_number], name: 'index_process_payroll_by_man_cl_on_pol_num_and_man_num'
      t.string :manual_type
      t.date :manual_class_effective_date
      t.float :manual_class_rate
      t.float :manual_class_payroll
      t.float :manual_class_premium
      t.string :payroll_origin
      t.string :data_source
      t.timestamps null: false
    end


  end
end
