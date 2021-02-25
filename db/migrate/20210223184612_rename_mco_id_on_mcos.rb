class RenameMcoIdOnMcos < ActiveRecord::Migration
  def change
    rename_column :mcos, :mco_id, :bwc_mco_id
  end
end
