class RenameClaimIdOnClaimNotes < ActiveRecord::Migration
  def change
    rename_column :claim_notes, :claim_id, :claim_calculation_id
  end
end
