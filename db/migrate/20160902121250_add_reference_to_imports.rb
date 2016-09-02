class AddReferenceToImports < ActiveRecord::Migration
  def change
    add_reference :imports, :representative, index: true
    add_foreign_key :imports, :representatives
  end
end
