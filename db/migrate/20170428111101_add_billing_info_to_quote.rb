class AddBillingInfoToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :paid_amount, :float
    add_column :quotes, :check_number, :string
    add_column :account_programs, :quote_tier, :float
  end
end
