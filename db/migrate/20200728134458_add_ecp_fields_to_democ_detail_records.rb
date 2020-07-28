class AddEcpFieldsToDemocDetailRecords < ActiveRecord::Migration
  def change
    add_column :democ_detail_records, :enhanced_care_program_indicator, :string
    add_column :democ_detail_records, :enhanced_care_program_indicator_effective_date, :date
  end
end
