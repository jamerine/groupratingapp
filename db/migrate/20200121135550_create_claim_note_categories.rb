class CreateClaimNoteCategories < ActiveRecord::Migration
  def change
    create_table :claim_note_categories do |t|
      t.string :title
      t.text :note

      t.timestamps null: false
    end
  end
end
