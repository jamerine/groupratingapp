class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :description
      t.integer :category
      t.references :account, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
