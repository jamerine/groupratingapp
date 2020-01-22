class AddClaimNumberAndRespresentativeNumberAndPolicyNumberToClaimNotes < ActiveRecord::Migration
  def change
    add_column :claim_notes, :claim_number, :string
    add_column :claim_notes, :representative_number, :integer
    add_column :claim_notes, :policy_number, :integer
  end
end
