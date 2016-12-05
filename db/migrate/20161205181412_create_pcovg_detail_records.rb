class CreatePcovgDetailRecords < ActiveRecord::Migration
  def change
    create_table :pcovg_detail_records do |t|

      t.integer :representative_number
      t.integer :record_type
      t.integer :requestor_number
      t.integer :policy_number
      t.integer :business_sequence_number
      t.string :valid_policy_number
      t.string :coverage_status
      t.date :coverage_status_effective_date
      t.date :coverage_status_end_date

      t.timestamps null: false
    end
  end
end
