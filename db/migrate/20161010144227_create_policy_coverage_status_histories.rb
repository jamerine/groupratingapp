class CreatePolicyCoverageStatusHistories < ActiveRecord::Migration
  def change
    create_table :policy_coverage_status_histories do |t|
      t.references :policy_calculation, index: true, foreign_key: true
      t.references :representative, index: true, foreign_key: true
      t.integer :representative_number
      t.string :policy_type
      t.integer :policy_number
      t.date :coverage_effective_date
      t.date :coverage_end_date
      t.string :coverage_status
      t.integer :lapse_days
      t.string :data_source

      t.timestamps null: false
    end
  end
end
