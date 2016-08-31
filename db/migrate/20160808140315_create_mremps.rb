class CreateMremps < ActiveRecord::Migration
  def change
    create_table :mremps do |t|
      t.string :single_rec
      # t.timestamps null: false
    end
  end
end
