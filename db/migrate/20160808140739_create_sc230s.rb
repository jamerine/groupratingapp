class CreateSc230s < ActiveRecord::Migration
  def change
    create_table :sc230s do |t|
      t.string :single_rec
      
      # t.timestamps null: false
    end
  end
end
