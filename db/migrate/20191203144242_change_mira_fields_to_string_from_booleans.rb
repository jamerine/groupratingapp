class ChangeMiraFieldsToStringFromBooleans < ActiveRecord::Migration
  def change
    change_column :mira_detail_records, :claim_indicator, :string
    change_column :mira_detail_records, :injured_worked_represented, :string
    change_column :mira_detail_records, :catastrophic_claim, :string
    change_column :mira_detail_records, :chiropractor, :string
    change_column :mira_detail_records, :physical_therapy, :string
    change_column :mira_detail_records, :salary_continuation, :string
    change_column :mira_detail_records, :medical_reserve_prediction, :string
    change_column :mira_detail_records, :indemnity_change_of_occupation_reserve_prediction, :string
    change_column :mira_detail_records, :indemnity_death_benefit_reserve_prediction, :string
    change_column :mira_detail_records, :indemnity_facial_disfigurement_reserve_prediction, :string
    change_column :mira_detail_records, :indemnity_living_maintenance_reserve_prediction, :string
    change_column :mira_detail_records, :indemnity_percent_permanent_partial_reserve_prediction, :string
    change_column :mira_detail_records, :indemnity_ptd_reserve_prediction, :string
    change_column :mira_detail_records, :indemnity_temporary_total_reserve_prediction, :string
  end
end
