class AddReferenceToPolicyCalculations < ActiveRecord::Migration
  def change
    add_reference :policy_calculations, :representative, index: true
    add_foreign_key :policy_calculations, :representatives
  end
end
