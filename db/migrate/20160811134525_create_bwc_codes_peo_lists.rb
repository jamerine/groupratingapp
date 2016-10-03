class CreateBwcCodesPeoLists < ActiveRecord::Migration
  def change
    create_table :bwc_codes_peo_lists do |t|
      t.string :policy_type
      t.integer :policy_number

      t.timestamps null: true
    end
  end
end
