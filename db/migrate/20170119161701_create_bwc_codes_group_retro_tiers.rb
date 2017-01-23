class CreateBwcCodesGroupRetroTiers < ActiveRecord::Migration
  def change
    create_table :bwc_codes_group_retro_tiers do |t|
      t.integer :industry_group
      t.float   :discount_tier
      
      t.timestamps null: false
    end
  end
end
