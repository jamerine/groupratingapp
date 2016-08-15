class CreateProcessManualClassFourYearPayrollWithConditions < ActiveRecord::Migration
  def change
    create_table :process_manual_class_four_year_payroll_with_conditions do |t|
      t.integer :representative_number
      t.integer :policy_number
      t.integer :manual_number
      t.float :manual_class_four_year_period_payroll
      t.string :data_source

      t.timestamps null: false
    end
  end
end