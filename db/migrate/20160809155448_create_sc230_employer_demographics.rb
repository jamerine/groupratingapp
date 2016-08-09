class CreateSc230EmployerDemographics < ActiveRecord::Migration
  def change
    create_table :sc230_employer_demographics do |t|
        t.integer :representative_number
        t.integer :representative_type
        t.integer :policy_type
        t.integer :policy_number
        t.integer :business_sequence_number
        t.integer :claim_manual_number
        t.string :record_type
        t.string :claim_number
        t.string :policy_name
        t.string :doing_business_as_name
        t.string :street_address
        t.string :city
        t.string :state
        t.integer :zip_code

      t.timestamps null: false
    end
  end
end
