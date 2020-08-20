class AddEcpToDifferentTables < ActiveRecord::Migration
  def change
    add_column :claim_calculations, :enhanced_care_program_indicator, :string, default: 'Y'
    add_column :final_claim_cost_calculation_tables, :enhanced_care_program_indicator, :string, default: 'Y'
  end
end
