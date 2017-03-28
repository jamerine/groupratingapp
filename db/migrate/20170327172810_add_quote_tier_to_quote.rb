class AddQuoteTierToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :quote_tier, :float
  end
end
