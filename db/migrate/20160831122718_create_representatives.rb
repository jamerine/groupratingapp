class CreateRepresentatives < ActiveRecord::Migration
  def change
    create_table :representatives do |t|
      t.integer :representative_number
      t.string :company_name
      t.string :abbreviated_name
      t.string :group_fees
      t.string :group_dues


      t.timestamps null: false
    end
  end
end
