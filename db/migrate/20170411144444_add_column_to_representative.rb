class AddColumnToRepresentative < ActiveRecord::Migration
  def change
    add_column :representatives, :zip_file, :string
  end
end
