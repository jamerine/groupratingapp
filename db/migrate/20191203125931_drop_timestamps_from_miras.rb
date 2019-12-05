class DropTimestampsFromMiras < ActiveRecord::Migration
  def change
    remove_column :miras, :created_at
    remove_column :miras, :updated_at
  end
end
