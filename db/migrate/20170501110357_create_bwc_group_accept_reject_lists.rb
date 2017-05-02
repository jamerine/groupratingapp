class CreateBwcGroupAcceptRejectLists < ActiveRecord::Migration
  def change
    create_table :bwc_group_accept_reject_lists do |t|
      t.integer :policy_number
      t.string :name
      t.string :tpa
      t.string :bwc_rep_id

      t.timestamps null: true
    end
  end
end
