class CreateAccountsContacts < ActiveRecord::Migration
  def change
    create_table :accounts_contacts do |t|
      t.references :account, index: true, foreign_key: true
      t.references :contact, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
