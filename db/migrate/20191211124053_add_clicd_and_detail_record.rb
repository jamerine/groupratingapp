class AddClicdAndDetailRecord < ActiveRecord::Migration
  def change
    create_table :clicds do |t|
      t.string :single_rec
    end

    create_table :clicd_detail_records do |t|
      t.integer :representative_number
      t.integer :record_type
      t.integer :requestor_number
      t.integer :policy_number
      t.integer :business_sequence_number
      t.string :valid_policy_number
      t.string :current_policy_status
      t.date :current_policy_status_effective_date
      t.integer :policy_year
      t.string :policy_year_rating_plan
      t.string :claim_indicator
      t.string :claim_number
      t.string :icd_codes_assigned
      t.string :icd_code
      t.string :icd_status
      t.date :icd_status_effective_date
      t.string :icd_injury_location_code
      t.string :icd_digit_tooth_number
      t.string :primary_icd

      t.timestamps null: false
    end

    add_column :imports, :clicds_count, :integer
    add_column :imports, :clicd_detail_records_count, :integer
  end
end
