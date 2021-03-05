class AddsDeletedAtToMcos < ActiveRecord::Migration
  def change
    add_column :mcos, :deleted_at, :datetime, allow_null: true
    add_index :mcos, :deleted_at

    add_column :accounts_mcos, :deleted_at, :datetime, allow_null: true
    add_index :accounts_mcos, :deleted_at
  end
end
