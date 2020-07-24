class AddFieldsToRepresentatives < ActiveRecord::Migration
  def change
    add_column :representatives, :signature, :string
    add_column :representatives, :president, :string
    add_column :representatives, :footer, :string
  end
end
