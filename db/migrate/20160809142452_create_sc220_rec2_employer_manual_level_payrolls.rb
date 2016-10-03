class CreateSc220Rec2EmployerManualLevelPayrolls < ActiveRecord::Migration
  def change
    create_table :sc220_rec2_employer_manual_level_payrolls do |t|
       t.integer :representative_number
       t.integer :representative_type
       t.string :description_ar
       t.integer :record_type
       t.integer :request_type
       t.string :policy_type
       t.integer :policy_number
       t.integer :business_sequence_number
       t.integer :manual_number
       t.string :manual_type
       t.float :year_to_date_payroll
       t.float :manual_class_rate
       t.float :year_to_date_premium_billed
       t.date :manual_effective_date
       t.float :n2nd_year_to_date_payroll
       t.float :n2nd_manual_class_rate
       t.float :n2nd_year_to_date_premium_billed
       t.date :n2nd_manual_effective_date
       t.float :n3rd_year_to_date_payroll
       t.float :n3rd_manual_class_rate
       t.float :n3rd_year_to_date_premium_billed
       t.date :n3rd_manual_effective_date
       t.float :n4th_year_to_date_payroll
       t.float :n4th_manual_class_rate
       t.float :n4th_year_to_date_premium_billed
       t.date :n4th_manual_effective_date
       t.float :n5th_year_to_date_payroll
       t.float :n5th_manual_class_rate
       t.float :n5th_year_to_date_premium_billed
       t.date :n5th_manual_effective_date
       t.float :n6th_year_to_date_payroll
       t.float :n6th_manual_class_rate
       t.float :n6th_year_to_date_premium_billed
       t.date :n6th_manual_effective_date
       t.float :n7th_year_to_date_payroll
       t.float :n7th_manual_class_rate
       t.float :n7th_year_to_date_premium_billed
       t.date :n7th_manual_effective_date
       t.float :n8th_year_to_date_payroll
       t.float :n8th_manual_class_rate
       t.float :n8th_year_to_date_premium_billed
       t.date :n8th_manual_effective_date
       t.float :n9th_year_to_date_payroll
       t.float :n9th_manual_class_rate
       t.float :n9th_year_to_date_premium_billed
       t.date :n9th_manual_effective_date
       t.float :n10th_year_to_date_payroll
       t.float :n10th_manual_class_rate
       t.float :n10th_year_to_date_premium_billed
       t.date :n10th_manual_effective_date
       t.float :n11th_year_to_date_payroll
       t.float :n11th_manual_class_rate
       t.float :n11th_year_to_date_premium_billed
       t.date :n11th_manual_effective_date
       t.float :n12th_year_to_date_payroll
       t.float :n12th_manual_class_rate
       t.float :n12th_year_to_date_premium_billed
       t.date :n12th_manual_effective_date

      t.timestamps null: false
    end
  end
end
