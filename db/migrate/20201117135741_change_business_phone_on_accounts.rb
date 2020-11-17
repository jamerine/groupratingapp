class ChangeBusinessPhoneOnAccounts < ActiveRecord::Migration
  def change
    change_column :accounts, :business_phone_number, :string
  end
end
