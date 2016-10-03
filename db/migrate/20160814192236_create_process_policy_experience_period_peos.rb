class CreateProcessPolicyExperiencePeriodPeos < ActiveRecord::Migration
  def change
    create_table :process_policy_experience_period_peos do |t|
      t.integer :representative_number
      t.string :policy_type
      t.integer :policy_number
      t.index :policy_number
      t.date :manual_class_sf_peo_lease_effective_date
      t.date :manual_class_sf_peo_lease_termination_date
      t.date :manual_class_si_peo_lease_effective_date
      t.date :manual_class_si_peo_lease_termination_date
      t.string :data_source
      t.timestamps null: false
    end
  end
end
