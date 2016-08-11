class CreateBwcCodesNcciManualClasses < ActiveRecord::Migration
  def change
    create_table :bwc_codes_ncci_manual_classes do |t|
      t.integer :industry_group
      t.integer :ncci_manual_classification

      t.timestamps null: true
    end
  end
end
