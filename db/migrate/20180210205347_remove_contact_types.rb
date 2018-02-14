class RemoveContactTypes < ActiveRecord::Migration
  def change
    remove_column :contacts, :contact_type
  end
end
