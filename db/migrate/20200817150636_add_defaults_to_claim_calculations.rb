class AddDefaultsToClaimCalculations < ActiveRecord::Migration
  def change
    change_column_default :claim_calculations, :claim_mira_non_reducible_indemnity_paid, 0.0
    change_column_default :claim_calculations, :claim_mira_non_reducible_indemnity_paid_2, 0.0
    change_column_default :claim_calculations, :claim_medical_paid, 0.0
    change_column_default :claim_calculations, :claim_mira_medical_reserve_amount, 0.0
    change_column_default :claim_calculations, :claim_mira_reducible_indemnity_paid, 0.0
    change_column_default :claim_calculations, :claim_mira_indemnity_reserve_amount, 0.0
    change_column_default :claim_calculations, :claim_handicap_percent, 0.0
    change_column_default :claim_calculations, :claim_subrogation_percent, 0.0
  end
end
