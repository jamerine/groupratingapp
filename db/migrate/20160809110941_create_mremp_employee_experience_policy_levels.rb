class CreateMrempEmployeeExperiencePolicyLevels < ActiveRecord::Migration
  def change
    create_table :mremp_employee_experience_policy_levels do |t|
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
        t.string :federal_id
        t.integer :grand_total_modified_losses
        t.integer :grand_total_expected_losses
        t.integer :grand_total_limited_losses
        t.integer :policy_maximum_claim_size
        t.float :policy_credibility
        t.float :policy_experience_modifier_percent
        t.string :employer_name
        t.string :doing_business_as_name
        t.string :referral_name
        t.string :address
        t.string :city
        t.string :state
        t.string :zip_code
        t.string :print_code
        t.integer :policy_year
        t.date :extract_date
        t.date :policy_year_exp_period_beginning_date
        t.date :policy_year_exp_period_ending_date
        t.string :green_year
        t.string :reserves_used_in_the_published_em
        t.string :risk_group_number
        t.string :em_capped_flag
        t.string :capped_em_percentage
        t.string :ocp_flag
        t.string :construction_cap_flag
        t.float :published_em_percentage

      t.timestamps null: false
    end
  end
end
