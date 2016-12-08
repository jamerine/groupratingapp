class CreateFinalEmployerDemographicsInformations < ActiveRecord::Migration
  def change
    create_table :final_employer_demographics_informations do |t|
      t.integer :representative_number
      t.integer :policy_number
      t.index [:policy_number, :representative_number], name: 'index_emp_demo_pol_num_and_man_num'
      t.integer :currently_assigned_representative_number
      t.string  :valid_policy_number
      t.string  :current_coverage_status
      t.date    :coverage_status_effective_date
      t.date    :policy_creation_date
      t.string  :federal_identification_number
      t.string  :business_name
      t.string  :trading_as_name
      # t.string :in_care_name_contact_name
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
      t.string  :employer_type
      t.string  :coverage_type
      t.string  :policy_coverage_type
      t.string  :policy_employer_type
      t.float   :merit_rate
      t.string  :group_code
      t.string  :minimum_premium_percentage
      t.string  :rate_adjust_factor
      t.date    :em_effective_date
      t.float   :regular_balance_amount
      t.float   :attorney_general_balance_amount
      t.float   :appealed_balance_amount
      t.float   :pending_balance_amount
      t.float   :advance_deposit_amount
      t.string  :data_source

      t.timestamps null: false
    end
  end
end
