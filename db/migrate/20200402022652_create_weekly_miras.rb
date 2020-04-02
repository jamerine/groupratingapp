class CreateWeeklyMiras < ActiveRecord::Migration
  def change
    create_table :weekly_miras do |t|
      t.string :single_rec
    end

    create_table :weekly_mira_detail_records do |t|
      t.integer :representative_number
      t.integer :record_type
      t.integer :requestor_number
      t.integer :policy_number
      t.integer :business_sequence_number
      t.string :valid_policy_number

      t.timestamps null: false
    end

    add_column :imports, :weekly_miras_count, :integer
    add_column :imports, :weekly_mira_details_records_count, :integer
  end
end
