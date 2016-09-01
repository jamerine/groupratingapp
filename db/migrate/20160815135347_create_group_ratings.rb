class CreateGroupRatings < ActiveRecord::Migration
  def change
    create_table :group_ratings do |t|
      t.integer :process_representative
      t.text :status
      t.date :experience_period_lower_date
      t.date :experience_period_upper_date
      t.date :current_payroll_period_lower_date
      t.integer :total_policies_updated
      t.integer :total_manual_classes_updated
      t.integer :total_payrolls_updated
      t.integer :total_claims_updated
      t.timestamps null: false
    end
  end
end
