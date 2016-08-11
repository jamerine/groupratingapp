class CreateBwcCodesLimitedLossRatios < ActiveRecord::Migration
  def change
    create_table :bwc_codes_limited_loss_ratios do |t|
      t.integer :industry_group
      t.integer :credibility_group
      t.float :limited_loss_ratio
      
      t.timestamps null: true
    end
  end
end
