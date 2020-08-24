class AddMoreDefaultsToClaims < ActiveRecord::Migration
  def change
    change_column_default :claim_calculations, :claim_total_subrogation_collected, 0.0
    change_column_default :claim_calculations, :claim_unlimited_limited_loss, 0.0
    change_column_default :claim_calculations, :policy_individual_maximum_claim_value, 0.0
    change_column_default :claim_calculations, :claim_group_multiplier, 0.0
    change_column_default :claim_calculations, :claim_individual_multiplier, 0.0
    change_column_default :claim_calculations, :claim_group_reduced_amount, 0.0
    change_column_default :claim_calculations, :claim_individual_reduced_amount, 0.0
    change_column_default :claim_calculations, :claim_subrogation_percent, 0.0
    change_column_default :claim_calculations, :claim_modified_losses_group_reduced, 0.0
    change_column_default :claim_calculations, :claim_modified_losses_individual_reduced, 0.0
    change_column_default :claim_calculations, :claim_subrogation_percent, 0.0
  end
end
