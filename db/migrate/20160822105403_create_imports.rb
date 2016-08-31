class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.integer :process_representative
      t.text :import_status
      t.text :parse_status
      t.integer :democs_count
      t.integer :mrcls_count
      t.integer :mremps_count
      t.integer :pcombs_count
      t.integer :phmgns_count
      t.integer :sc220s_count
      t.integer :sc230s_count
      t.integer :democ_detail_records_count
      t.integer :mrcl_detail_records_count
      t.integer :mremp_employee_experience_policy_levels_count
      t.integer :mremp_employee_experience_manual_class_levels_count
      t.integer :mremp_employee_experience_claim_levels_count
      t.integer :pcomb_detail_records_count
      t.integer :phmgn_detail_records_count
      t.integer :sc220_rec1_employer_demographics_count
      t.integer :sc220_rec2_employer_manual_level_payrolls_count
      t.integer :sc220_rec3_employer_ar_transactions_count
      t.integer :sc220_rec4_policy_not_founds_count
      t.integer :sc230_employer_demographics_count
      t.integer :sc230_claim_medical_payments_count
      t.integer :sc230_claim_indemnity_awards_count

      t.timestamps null: false
    end
  end
end
