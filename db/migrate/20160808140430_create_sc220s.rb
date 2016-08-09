class CreateSc220s < ActiveRecord::Migration
  def change
    create_table :sc220s do |t|
      t.string :single_rec

      # t.timestamps null: false
    end
  end
end
