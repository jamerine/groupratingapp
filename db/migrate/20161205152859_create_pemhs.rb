class CreatePemhs < ActiveRecord::Migration
  def change
    create_table :pemhs do |t|
      t.string :single_rec

      # t.timestamps null: false
    end
  end
end
