class CreateMcos < ActiveRecord::Migration
  def change
    create_table :mcos do |t|
      t.integer :mco_id
      t.string :name

      t.timestamps null: false
    end
  end
end
