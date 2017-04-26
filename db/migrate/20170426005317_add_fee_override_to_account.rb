class AddFeeOverrideToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :fee_override, :float
  end
end
