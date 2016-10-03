class CreateSc230ClaimMedicalPayments < ActiveRecord::Migration
  def change
    create_table :sc230_claim_medical_payments do |t|
        t.integer :representative_number
        t.integer :representative_type
        t.string :policy_type
        t.integer :policy_number
        t.integer :business_sequence_number
        t.integer :claim_manual_number
        t.string :record_type
        t.string :claim_number
        t.date :hearing_date
        t.date :injury_date
        t.string :from_date
        t.string :to_date
        t.string :award_type
        t.string :number_of_weeks
        t.string :awarded_weekly_rate
        t.integer :award_amount
        t.float :payment_amount
        t.string :claimant_name
        t.string :payee_name

      t.timestamps null: false
    end
  end
end
