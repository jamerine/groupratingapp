class CreateBwcCodesPolicyEffectiveDates < ActiveRecord::Migration
  def change
    create_table :bwc_codes_policy_effective_dates do |t|
      t.integer :policy_number
      t.index :policy_number
      t.date :policy_original_effective_date

      t.timestamps null: true
    end
  end
end
