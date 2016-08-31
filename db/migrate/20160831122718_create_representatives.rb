class CreateRepresentatives < ActiveRecord::Migration
  def change
    create_table :representatives do |t|
      t.integer :representative_number
      t.string :name

      t.timestamps null: false
    end
  end
end
