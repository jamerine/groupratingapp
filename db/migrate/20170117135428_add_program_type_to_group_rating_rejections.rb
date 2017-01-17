class AddProgramTypeToGroupRatingRejections < ActiveRecord::Migration
  def change
    add_column :group_rating_rejections, :program_type, :string
  end
end
