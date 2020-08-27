class FixDefaultsOfEcps < ActiveRecord::Migration
  def change
    change_column_default :claim_calculations, :enhanced_care_program_indicator, 'N'
    change_column_default :final_claim_cost_calculation_tables, :enhanced_care_program_indicator, 'N'
  end
end
