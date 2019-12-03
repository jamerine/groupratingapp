class CreateMiras < ActiveRecord::Migration
  def change
    create_table :miras do |t|
      t.string :single_rec

      t.timestamps null: false
    end

    create_table :mira_detail_records do |t|
      t.integer :representative_number
      t.integer :record_type
      t.integer :requestor_number
      t.integer :policy_number
      t.integer :business_sequence_number
      t.string :valid_policy_number

      t.timestamps null: false
    end

    add_column :imports, :miras_count, :integer
    add_column :imports, :mira_details_record_count, :integer
  end
end
