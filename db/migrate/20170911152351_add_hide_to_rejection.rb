class AddHideToRejection < ActiveRecord::Migration
  def change
    add_column :group_rating_rejections, :hide, :boolean
  end
end
