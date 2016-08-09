class CreateSc220Rec4PolicyNotFounds < ActiveRecord::Migration
  def change
    create_table :sc220_rec4_policy_not_founds do |t|
      t.integer :representative_number
      t.integer :representative_type
      t.string :description
      t.integer :record_type
      t.integer :request_type
      t.integer :policy_type
      t.integer :policy_number
      t.integer :business_sequence_number
      t.string :error_message

      t.timestamps null: false
    end
  end
end
