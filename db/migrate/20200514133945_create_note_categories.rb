class CreateNoteCategories < ActiveRecord::Migration
  def change
    create_table :note_categories do |t|
      t.string :title

      t.timestamps null: false
    end

    add_column :notes, :category_id, :integer, null: true
  end
end
