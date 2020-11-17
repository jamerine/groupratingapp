class AddFaxNumberToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :fax_number, :string
  end
end
