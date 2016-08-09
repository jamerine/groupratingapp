class CreateSc230ClaimIndemnityAwards < ActiveRecord::Migration
  def change
    create_table :sc230_claim_indemnity_awards do |t|
      t.integer :representative_number
      t.integer :representative_type
      t.integer :policy_type
      t.integer :policy_number
      t.integer :business_sequence_number
      t.integer :claim_manual_number
      t.string :record_type
      t.string :claim_number
      t.date :hearing_date
      t.date :injury_date
      t.date :from_date
      t.date :to_date
      t.string :award_type
      t.string :number_of_weeks
      t.float :awarded_weekly_rate
      t.float :award_amount
      t.integer :payment_amount
      t.string :claimant_name
      t.string :payee_name

      t.timestamps null: false
    end
  end
end
