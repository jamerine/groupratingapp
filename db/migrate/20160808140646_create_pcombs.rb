class CreatePcombs < ActiveRecord::Migration
  def change
    create_table :pcombs do |t|
      t.string :single_rec

      # t.timestamps null: false
    end
  end
end
