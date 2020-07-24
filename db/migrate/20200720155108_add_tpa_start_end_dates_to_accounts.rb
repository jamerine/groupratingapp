class AddTpaStartEndDatesToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :tpa_start_date, :date
    add_column :accounts, :tpa_end_date, :date
  end
end
