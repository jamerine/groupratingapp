class RenameMiraDetailsRecordCount < ActiveRecord::Migration
  def change
    rename_column :imports, :mira_details_record_count, :mira_detail_records_count
  end
end
