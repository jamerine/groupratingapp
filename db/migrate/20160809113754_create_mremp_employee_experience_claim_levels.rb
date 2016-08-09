class CreateMrempEmployeeExperienceClaimLevels < ActiveRecord::Migration
  def change
    create_table :mremp_employee_experience_claim_levels do |t|
      t.integer :representative_number
      t.integer :representative_type
      t.integer :policy_type
      t.integer :policy_number
      t.integer :business_sequence_number
      t.integer :record_type
      t.integer :manual_number
      t.string :sub_manual_number
      t.string :claim_reserve_code
      t.string :claim_number
      t.date :injury_date
      t.integer :claim_indemnity_paid_using_mira_rules
      t.integer :claim_indemnity_mira_reserve
      t.integer :claim_medical_paid
      t.integer :claim_medical_reserve
      t.integer :claim_indemnity_handicap_paid_using_mira_rules
      t.integer :claim_indemnity_handicap_mira_reserve
      t.integer :claim_medical_handicap_paid
      t.integer :claim_medical_handicap_reserve
      t.string :claim_surplus_type
      t.string :claim_handicap_percent
      t.string :claim_over_policy_max_value_indicator
      
      t.timestamps null: false
    end
  end
end
