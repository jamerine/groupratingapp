class CreateBwcCodesEmployerRepresentatives < ActiveRecord::Migration
  def change
    create_table :bwc_codes_employer_representatives do |t|
      t.integer :rep_id
      t.string :employer_rep_name
      t.string :rep_id_text
      t.integer :representative_number

      t.timestamps null: true
    end
  end
end
