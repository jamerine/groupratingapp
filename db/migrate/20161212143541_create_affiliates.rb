class CreateAffiliates < ActiveRecord::Migration
  def change
    create_table :affiliates do |t|
      t.string :first_name
      t.string :last_name
      t.integer :role, default: 0
      t.string :email
      t.string :salesforce_id

      t.references :representative, index: true, foreign_key: true
      t.integer :internal_external, default: 0

      t.timestamps null: false
    end
  end
end
