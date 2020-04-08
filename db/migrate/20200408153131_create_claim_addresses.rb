class CreateClaimAddresses < ActiveRecord::Migration
  def change
    create_table :claim_addresses do |t|
      t.string :claim_number
      t.integer :policy_number
      t.integer :representative_number
      t.text :address

      t.timestamps null: false
    end
  end
end
