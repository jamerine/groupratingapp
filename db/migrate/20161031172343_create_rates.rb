class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.string :single_rec

      # t.timestamps null: false
    end
  end
end
