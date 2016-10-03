class CreatePhmgnDetailRecords < ActiveRecord::Migration
  def change
    create_table :phmgn_detail_records do |t|
      t.integer :representative_number
      t.integer :representative_type
      t.integer :record_type
      t.integer :requestor_number
      t.string :policy_type
      t.integer :policy_number
      t.integer :business_sequence_number
      t.string :valid_policy_number
      t.string :experience_payroll_premium_information
      t.string :industry_code
      t.integer :ncci_manual_number
      t.string :manual_coverage_type
      t.float :manual_payroll
      t.float :manual_premium
      t.float :premium_percentage
      t.integer :upcoming_policy_year
      t.integer :policy_year_extracted_for_experience_payroll_determining_premiu
      t.date :policy_year_extracted_beginning_date
      t.date :policy_year_extracted_ending_date

      t.timestamps null: false
    end
  end
end
