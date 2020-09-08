class AddIsPinnedToNotesAndClaimNotes < ActiveRecord::Migration
  def change
    add_column :notes, :is_pinned, :boolean, default: false
    add_column :claim_notes, :is_pinned, :boolean, default: false
  end
end
