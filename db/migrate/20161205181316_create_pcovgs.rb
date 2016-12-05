class CreatePcovgs < ActiveRecord::Migration
  def change
    create_table :pcovgs do |t|
      t.string :single_rec
      
      # t.timestamps null: false
    end
  end
end
