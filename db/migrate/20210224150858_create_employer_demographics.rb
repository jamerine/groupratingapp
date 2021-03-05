class CreateEmployerDemographics < ActiveRecord::Migration
  def change
    create_table :employer_demographics do |t|
      t.string :employer_state, default: 'OH'
      t.integer :representative_id, null: false
      t.integer :policy_number, null: true
      t.string :primary_name, null: true
      t.string :primary_dba_name, null: true
      t.string :street_address_line_1, null: true
      t.string :street_address_line_2, null: true
      t.string :city_name, null: true
      t.string :state_code, null: true
      t.string :zip_code, null: true
      t.string :county_name, null: true
      t.string :business_phone, null: true
      t.string :business_extension, null: true
      t.string :business_fax, null: true
      t.string :fax_extension, null: true
      t.string :business_contact_name, null: true
      t.string :primary_contact_email, null: true
      t.string :business_street_address_1, null: true
      t.string :business_city, null: true
      t.string :business_state_code, null: true
      t.string :business_zip_code, null: true
      t.datetime :policy_original_effective_date, null: true
      t.string :policy_type, null: true
      t.string :policy_status, null: true
      t.string :policy_status_reason, null: true
      t.datetime :status_reason_effective_date, null: true
      t.integer :risk_group_number, null: true
      t.float :interstate_experience_modifier, null: true
      t.float :group_retro_max_premium_ratio, null: true
      t.float :group_experience_rated_program, null: true
      t.float :intrastate_retrospective_rating_program, null: true
      t.string :employer_rep_group_risk_claim, null: true
      t.string :employer_rep_emplr_risk_claim, null: true
      t.string :employer_rep_risk_management, null: true
      t.integer :current_industry_number, null: true
      t.string :current_industry_description, null: true
      t.integer :mco_id_number, null: true
      t.string :mco_name, null: true
      t.datetime :mco_relationship_beginning_date, null: true
      t.string :premium_range, null: true
      t.string :penalty_rated_flag, null: true
      t.string :group_rating_flag, null: true
      t.string :group_retro_flag, null: true
      t.string :individual_retro_flag, null: true
      t.string :one_claim_program_flag, null: true
      t.string :em_cap_flag, null: true
      t.float :deductible_amount, null: true
      t.integer :employer_year, null: true
      t.string :grow_ohio_participation_flag, null: true
      t.integer :governing_class_code, null: true
      t.string :drug_free_safety_program_flag, null: true
      t.string :go_green_flag, null: true
      t.string :industry_specific_safety_program_flag, null: true
      t.string :interstate_experience_modifier_flag, null: true
      t.string :intrastate_retrospective_rating_flag, null: true
      t.string :lapse_free_discount_flag, null: true
      t.string :safety_council_participation_factor, null: true
      t.string :safety_council_performance_factor, null: true
      t.string :deductible_rating_plan_factor, null: true
      t.string :transitional_work_performance_rate_factor, null: true
      t.datetime :deleted_at, null: true

      t.index :deleted_at
      t.timestamps null: false
    end
  end
end
