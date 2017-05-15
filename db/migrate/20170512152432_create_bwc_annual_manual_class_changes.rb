class CreateBwcAnnualManualClassChanges < ActiveRecord::Migration
  def change
    create_table :bwc_annual_manual_class_changes do |t|
      t.integer :manual_class_from
      t.integer :manual_class_to
      t.integer :policy_year

      t.timestamps null: false
    end
  end
end
