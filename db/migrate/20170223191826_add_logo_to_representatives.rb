class AddLogoToRepresentatives < ActiveRecord::Migration
  def change
    add_column :representatives, :logo, :string
  end
end
