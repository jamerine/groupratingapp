class CreateBwcCodesBaseRatesExpLossRates < ActiveRecord::Migration
  def change
    create_table :bwc_codes_base_rates_exp_loss_rates do |t|
      t.integer :class_code
      t.float :base_rate
      t.float :expected_loss_rate

      t.timestamps null: true
    end
  end
end
