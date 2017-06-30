class ChangeGroupRetroTierToDouble < ActiveRecord::Migration
  def change
    change_column :accounts, :group_retro_tier, 'float USING CAST(group_retro_tier AS float)'
  end
end
