class CreateProcessManualReclassTables < ActiveRecord::Migration
  def change
    create_table :process_manual_reclass_tables do |t|
      t.integer :representative_number
      t.integer :policy_type
      t.integer :policy_number
      t.integer :re_classed_from_manual_number
      t.integer :re_classed_to_manual_number
      t.string :reclass_manual_coverage_type
      t.date :reclass_creation_date
      t.date :payroll_reporting_period_from_date
      t.date :payroll_reporting_period_to_date
      t.float :re_classed_to_manual_payroll_total
      t.string :payroll_origin
      t.string :data_source

      t.timestamps null: false
    end
  end
end
