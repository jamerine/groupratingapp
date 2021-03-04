class ParanoidNotes < ActiveRecord::Migration
  def change
    add_column :claim_notes, :deleted_at, :datetime
    add_column :notes, :deleted_at, :datetime

    add_index :claim_notes, :deleted_at
    add_index :notes, :deleted_at
  end
end
