class AddFieldsToClaimCalculation < ActiveRecord::Migration
  def change
    add_column :claim_calculations, :claim_combined, :string
    add_column :claim_calculations, :combined_into_claim_number, :string
    add_column :claim_calculations, :claim_rating_plan_indicator, :string
    add_column :claim_calculations, :claim_status, :string
    add_column :claim_calculations, :claim_status_effective_date, :date
    add_column :claim_calculations, :claim_type, :string
    add_column :claim_calculations, :claim_activity_status, :string
    add_column :claim_calculations, :claim_activity_status_effective_date, :date
    add_column :claim_calculations, :settled_claim, :string
    add_column :claim_calculations, :settlement_type, :string
    add_column :claim_calculations, :medical_settlement_date, :date
    add_column :claim_calculations, :indemnity_settlement_date, :date
    add_column :claim_calculations, :maximum_medical_improvement_date, :date
    add_column :claim_calculations, :claim_mira_ncci_injury_type, :string
  end
end
