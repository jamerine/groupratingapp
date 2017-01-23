class AddExternalIdToAffiliate < ActiveRecord::Migration
  def change
    add_column :affiliates, :external_id, :string
  end
end
