class AddContactNameToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :business_contact_name, :string
  end
end
