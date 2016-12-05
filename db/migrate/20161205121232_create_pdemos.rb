class CreatePdemos < ActiveRecord::Migration
  def change
    create_table :pdemos do |t|
      t.string :single_rec

      # t.timestamps null: false
    end
  end
end
