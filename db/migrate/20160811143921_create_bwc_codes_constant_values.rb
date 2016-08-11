class CreateBwcCodesConstantValues < ActiveRecord::Migration
  def change
    create_table :bwc_codes_constant_values do |t|
      t.string :name
      t.float :value
      t.date :start_date

      t.timestamps null: true
    end
  end
end
