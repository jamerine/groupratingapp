class AddUserIdToClaimNotes < ActiveRecord::Migration
  def change
    add_column :claim_notes, :user_id, :integer
  end
end
