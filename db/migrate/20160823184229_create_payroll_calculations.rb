class CreatePayrollCalculations < ActiveRecord::Migration
  def change
    create_table :payroll_calculations do |t|
      t.integer :representative_number
      t.string :policy_type
      t.integer :policy_number
      t.string :manual_class_type
      t.integer :manual_number
      t.references :manual_class_calculation, index: true, foreign_key: true
      t.index [:policy_number, :manual_number], name: 'index_payroll_calc_on_pol_num_and_man_num'
      t.date :reporting_period_start_date
      t.date :reporting_period_end_date
      t.float :manual_class_payroll
      t.string :reporting_type
      t.integer :number_of_employees
      t.integer :policy_transferred
      t.date :transfer_creation_date
      t.integer :process_payroll_all_transactions_breakdown_by_manual_class_id
      t.string :payroll_origin
      t.string :data_source

      t.timestamps null: false
    end
  end
end
