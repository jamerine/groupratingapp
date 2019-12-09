class AddNonAtFaultToDemocDetailRecords < ActiveRecord::Migration
  def change
    add_column :democ_detail_records, :non_at_fault, :string
  end
end
