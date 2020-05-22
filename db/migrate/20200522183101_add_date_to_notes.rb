class AddDateToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :date, :datetime, null: true
    add_column :claim_notes, :date, :datetime, null: true
  end
end
