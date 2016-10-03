class CreateMrclDetailRecords < ActiveRecord::Migration
  def change
    create_table :mrcl_detail_records do |t|
      t.integer :representative_number
      t.integer :representative_type
      t.integer :record_type
      t.integer :requestor_number
      t.string :policy_type
      t.integer :policy_number
      t.integer :business_sequence_number
      t.string :valid_policy_number
      t.string :manual_reclassifications
      t.integer :re_classed_from_manual_number
      t.integer :re_classed_to_manual_number
      t.string :reclass_manual_coverage_type
      t.date :reclass_creation_date
      t.string :reclassed_payroll_information
      t.date :payroll_reporting_period_from_date
      t.date :payroll_reporting_period_to_date
      t.float :re_classed_to_manual_payroll_total

      t.timestamps null: true
    end
  end
end
