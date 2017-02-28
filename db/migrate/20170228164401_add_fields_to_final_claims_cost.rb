class AddFieldsToFinalClaimsCost < ActiveRecord::Migration
  def change
    add_column :final_claim_cost_calculation_tables, :claim_combined, :string
    add_column :final_claim_cost_calculation_tables, :combined_into_claim_number, :string
    add_column :final_claim_cost_calculation_tables, :claim_rating_plan_indicator, :string
    add_column :final_claim_cost_calculation_tables, :claim_status, :string
    add_column :final_claim_cost_calculation_tables, :claim_status_effective_date, :date
    add_column :final_claim_cost_calculation_tables, :claim_type, :string
    add_column :final_claim_cost_calculation_tables, :claim_activity_status, :string
    add_column :final_claim_cost_calculation_tables, :claim_activity_status_effective_date, :date
    add_column :final_claim_cost_calculation_tables, :settled_claim, :string
    add_column :final_claim_cost_calculation_tables, :settlement_type, :string
    add_column :final_claim_cost_calculation_tables, :medical_settlement_date, :date
    add_column :final_claim_cost_calculation_tables, :indemnity_settlement_date, :date
    add_column :final_claim_cost_calculation_tables, :maximum_medical_improvement_date, :date
    add_column :final_claim_cost_calculation_tables, :claim_mira_ncci_injury_type, :string

  end
end
