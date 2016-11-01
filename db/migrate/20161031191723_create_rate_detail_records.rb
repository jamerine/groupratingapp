class CreateRateDetailRecords < ActiveRecord::Migration
  def change
    create_table :rate_detail_records do |t|
      t.date :create_date
      t.integer :representative_number
      t.string :representative_name
      t.integer :policy_number
      t.integer :business_sequence_number
      t.string :policy_name
      t.integer :tax_id
      t.date :policy_status_effective_date
      t.string :policy_status
      t.date :reporting_period_start_date
      t.date :reporting_period_end_date
      t.integer :manual_class
      t.string :manual_class_type
      t.string :manual_class_description
      t.integer :bwc_customer_id
      t.string :individual_first_name
      t.string :individual_middle_name
      t.string :individual_last_name
      t.integer :individual_tax_id
      t.float :manual_class_rate
      t.string :reporting_type
      t.integer :number_of_employees
      t.float :payroll

      t.timestamps null: false
    end
  end
end
