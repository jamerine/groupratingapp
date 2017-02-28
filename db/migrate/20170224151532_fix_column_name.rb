class FixColumnName < ActiveRecord::Migration
  def change
    add_column :quotes, :quote, :string
  end
end
