class AddExternalIdToAffiliate < ActiveRecord::Migration
  def change
    add_column :affiliates, :external_id, :string
    add_column :affiliates, :company_name, :string
  end
end
