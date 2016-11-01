class CreateGroupRatingExceptions < ActiveRecord::Migration
  def change
    create_table :group_rating_exceptions do |t|
      t.references :account, index: true, foreign_key: true
      t.references :representative, index: true, foreign_key: true
      t.string :exception_reason


      t.timestamps null: false
    end
  end
end
