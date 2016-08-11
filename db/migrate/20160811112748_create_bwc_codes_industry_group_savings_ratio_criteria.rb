class CreateBwcCodesIndustryGroupSavingsRatioCriteria < ActiveRecord::Migration
  def change
    create_table :bwc_codes_industry_group_savings_ratio_criteria do |t|
      t.integer :industry_group
      t.float :ratio_criteria
      t.float :average_ratio
      t.float :actual_decimal
      t.float :percent_value
      t.float :em
      t.float :market_rate
      t.float :market_em_rate
      t.string :sponsor
      t.string :ac26_group_level

      t.timestamps null: true
    end
  end
end
