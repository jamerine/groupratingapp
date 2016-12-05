class CreatePdemoDetailRecords < ActiveRecord::Migration
  def change
    create_table :pdemo_detail_records do |t|
      t.integer :representative_number
      t.integer :record_type
      t.integer :requestor_number
      t.integer :policy_number
      t.integer :business_sequence_number
      t.string  :valid_policy_number
      t.string  :current_coverage_status
      t.date    :coverage_status_effective_date
      t.integer :federal_identification_number
      t.string  :business_name
      t.string  :trading_as_name
      t.string  :valid_mailing_address
      t.string  :mailing_address_line_1
      t.string  :mailing_address_line_2
      t.string  :mailing_city
      t.string  :mailing_state
      t.integer :mailing_zip_code
      t.integer :mailing_zip_code_plus_4
      t.integer :mailing_country_code
      t.integer :mailing_county
      t.string  :valid_location_address
      t.string  :location_address_line_1
      t.string  :location_address_line_2
      t.string  :location_city
      t.string  :location_state
      t.integer :location_zip_code
      t.integer :location_zip_code_plus_4
      t.integer :location_country_code
      t.integer :location_county
      t.integer :currently_assigned_clm_representative_number
      t.integer :currently_assigned_risk_representative_number
      t.integer :currently_assigned_erc_representative_number
      t.integer :currently_assigned_grc_representative_number
      t.integer :immediate_successor_policy_number
      t.integer :immediate_successor_business_sequence_number
      t.integer :ultimate_successor_policy_number
      t.integer :ultimate_successor_business_sequence_number
      t.string :employer_type
      t.string :coverage_type


      t.timestamps null: false
    end
  end
end
