class CreateAccountsAffiliates < ActiveRecord::Migration
  def change
    create_table :accounts_affiliates do |t|
      t.references :account, index: true, foreign_key: true
      t.references :affiliate, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
