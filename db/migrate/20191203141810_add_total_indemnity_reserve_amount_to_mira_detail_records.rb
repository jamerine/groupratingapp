class AddTotalIndemnityReserveAmountToMiraDetailRecords < ActiveRecord::Migration
  def change
    add_column :mira_detail_records, :total_indemnity_reserve_amount, :float
    change_column :mira_detail_records, :claimant_age_at_injury, :string
  end
end
