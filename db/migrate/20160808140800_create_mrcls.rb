class CreateMrcls < ActiveRecord::Migration
  def change
    create_table :mrcls do |t|
      t.string :single_rec

      # t.timestamps null: false
    end
  end
end
