class AddPublicOnlyToBwcCodesGroupRetroTiers < ActiveRecord::Migration
  def change
    add_column :bwc_codes_group_retro_tiers, :public_employer_only, :boolean, default: false
  end
end
