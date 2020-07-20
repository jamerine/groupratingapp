class AddGroupAndRetentionFlagsToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :is_group, :boolean, default: false
    add_column :notes, :is_retention, :boolean, default: false
  end
end
