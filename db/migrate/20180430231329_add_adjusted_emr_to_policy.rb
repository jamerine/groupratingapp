class AddAdjustedEmrToPolicy < ActiveRecord::Migration
  def change
    add_column :policy_calculations, :policy_individual_adjusted_experience_modified_rate, :float
  end
end
