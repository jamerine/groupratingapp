class AddFeeChangePercentToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :fee_change, :float
  end
end
