class CreatePhmgns < ActiveRecord::Migration
  def change
    create_table :phmgns do |t|
      t.string :single_rec
      
      # t.timestamps null: false
    end
  end
end
