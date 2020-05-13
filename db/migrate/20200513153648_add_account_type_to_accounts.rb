class AddAccountTypeToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :account_type, :integer, null: true
  end
end
