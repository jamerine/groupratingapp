class CreateClaimNotes < ActiveRecord::Migration
  def change
    create_table :claim_notes do |t|
      t.string :title
      t.integer :claim_note_category_id
      t.text :body
      t.integer :claim_id

      t.timestamps null: false
    end
  end
end
