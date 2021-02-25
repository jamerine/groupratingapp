class CreateAccountsMcos < ActiveRecord::Migration
  def change
    create_table :accounts_mcos do |t|
      t.integer :account_id
      t.integer :mco_id
      t.datetime :relationship_start_date

      t.timestamps null: false
    end
  end
end
