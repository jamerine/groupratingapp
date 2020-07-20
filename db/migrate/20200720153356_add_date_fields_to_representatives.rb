class AddDateFieldsToRepresentatives < ActiveRecord::Migration
  def change
    add_column :representatives, :internal_quote_completion_date, :date
    add_column :representatives, :bwc_quote_completion_date, :date
    add_column :representatives, :experience_date, :date
  end
end
