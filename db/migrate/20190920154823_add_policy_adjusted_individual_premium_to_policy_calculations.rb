class AddPolicyAdjustedIndividualPremiumToPolicyCalculations < ActiveRecord::Migration
  def change
    add_column :policy_calculations, :policy_adjusted_individual_premium, :float, null: true
  end
end
