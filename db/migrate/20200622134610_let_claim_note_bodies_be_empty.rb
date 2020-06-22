class LetClaimNoteBodiesBeEmpty < ActiveRecord::Migration
  def change
    change_column_default :claim_notes, :body, ''
    change_column_null :claim_notes, :body, true
  end
end
