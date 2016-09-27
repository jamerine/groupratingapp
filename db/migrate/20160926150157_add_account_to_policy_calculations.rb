class AddAccountToPolicyCalculations < ActiveRecord::Migration
  def change
    add_reference :policy_calculations, :account, index: true, foreign_key: true
  end
end
