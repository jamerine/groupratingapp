class CreateAccountsContactsContactTypes < ActiveRecord::Migration
  def change
    create_table :accounts_contacts_contact_types do |t|
      t.references :accounts_contact, index: true, foreign_key: true
      t.references :contact_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
