class CreateBwcCodesCredibilityMaxLosses < ActiveRecord::Migration
  def change
    create_table :bwc_codes_credibility_max_losses do |t|
      t.integer :credibility_group
      t.integer :expected_losses
      t.float :credibility_percent
      t.integer :group_maximum_value

      t.timestamps null: true
    end
  end
end
