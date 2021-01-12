class AddPhoneExtensionToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :business_phone_extension, :string
  end
end
