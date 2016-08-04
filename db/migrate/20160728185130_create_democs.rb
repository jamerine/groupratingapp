class CreateDemocs < ActiveRecord::Migration
  def change
    create_table :democs do |t|
      t.string :single_rec

      # t.timestamps null: false
    end
  end
end
