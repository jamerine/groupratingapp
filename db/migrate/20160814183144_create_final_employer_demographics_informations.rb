class CreateFinalEmployerDemographicsInformations < ActiveRecord::Migration
  def change
    create_table :final_employer_demographics_informations do |t|
      t.integer :representative_number
      t.string :policy_type
      t.integer :policy_number
      t.index [:policy_number, :representative_number], name: 'index_emp_demo_pol_num_and_man_num'
      t.integer :successor_policy_number
      t.integer :currently_assigned_representative_number
      t.string :federal_identification_number
      t.string :business_name
      t.string :trading_as_name
      t.string :in_care_name_contact_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :zip_code_plus_4
      t.string :country_code
      t.string :county
      t.date :policy_creation_date
      t.string :current_policy_status
      t.date :current_policy_status_effective_date
      t.float :merit_rate
      t.string :group_code
      t.string :minimum_premium_percentage
      t.string :rate_adjust_factor
      t.date :em_effective_date
      t.float :regular_balance_amount
      t.float :attorney_general_balance_amount
      t.float :appealed_balance_amount
      t.float :pending_balance_amount
      t.float :advance_deposit_amount
      t.string :data_source

      t.timestamps null: false
    end
  end
end
