class CreatePayrollCalculations < ActiveRecord::Migration
  def change
    create_table :payroll_calculations do |t|
      t.integer :representative_number
      t.integer :policy_number
      t.integer :manual_number
      t.references :manual_class_calculation, index: true, foreign_key: true
      t.index [:policy_number, :manual_number], name: 'index_payroll_calc_on_pol_num_and_man_num'
      t.date :manual_class_effective_date
      t.float :manual_class_payroll
      t.string :payroll_origin
      t.string :data_source

      t.timestamps null: false
    end
  end
end