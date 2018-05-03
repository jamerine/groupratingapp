class AddPremiumSizeFactors < ActiveRecord::Migration
  def change
    add_column :policy_calculations, :policy_adjusted_standard_premium, :float
  end
end
