class AddNonAtFaultToClaimCalculations < ActiveRecord::Migration
  def change
    add_column :claim_calculations, :non_at_fault, :string
  end
end
