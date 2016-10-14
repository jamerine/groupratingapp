class CreateGroupRatingRejections < ActiveRecord::Migration
  def change
    create_table :group_rating_rejections do |t|
      t.references :account, index: true, foreign_key: true
      t.references :representative, index: true, foreign_key: true
      t.string :reject_reason


      t.timestamps null: false
    end
  end
end
