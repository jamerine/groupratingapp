class CreateGroupRatings < ActiveRecord::Migration
  def change
    create_table :group_ratings do |t|
      t.integer :process_representative
      t.text :status
      t.text :group_rating_step
      t.date :experience_period_lower_date
      t.date :experience_period_upper_date
      t.date :current_payroll_period_lower_date
      t.timestamps null: false
    end
  end
end
