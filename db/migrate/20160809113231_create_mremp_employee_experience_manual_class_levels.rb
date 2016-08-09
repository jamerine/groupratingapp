class CreateMrempEmployeeExperienceManualClassLevels < ActiveRecord::Migration
  def change
    create_table :mremp_employee_experience_manual_class_levels do |t|
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
      t.integer :experience_period_payroll
      t.float :manual_class_base_rate
      t.float :manual_class_expected_loss_rate
      t.integer :manual_class_expected_losses
      t.string :merit_rated_flag
      t.string :policy_manual_status
      t.float :limited_loss_ratio
      t.integer :limited_losses

      t.timestamps null: false
    end
  end
end
