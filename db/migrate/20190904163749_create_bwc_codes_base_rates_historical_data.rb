class CreateBwcCodesBaseRatesHistoricalData < ActiveRecord::Migration
  def change
    create_table :bwc_codes_base_rates_historical_data do |t|
      t.integer :year
      t.integer :class_code
      t.integer :industry_group
      t.float :base_rate
      t.float :expected_loss_rate

      t.timestamps null: false
    end

    create_table :bwc_codes_limited_loss_rates_historical_data do |t|
      t.integer :year
      t.integer :industry_group
      t.integer :credibility_group
      t.float :limited_loss_ratio

      t.timestamps null: false
    end
  end
end
