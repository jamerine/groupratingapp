class CreateBwcCodesConstantValues < ActiveRecord::Migration
  def change
    create_table :bwc_codes_constant_values do |t|
      t.string :name
      t.float :rate
      t.date :start_date
      t.date :completed_date

      t.timestamps null: true
    end
  end
end
