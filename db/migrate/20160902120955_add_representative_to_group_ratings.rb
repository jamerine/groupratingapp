class AddRepresentativeToGroupRatings < ActiveRecord::Migration
  def change
    add_reference :group_ratings, :representative, index: true
    add_foreign_key :group_ratings, :representatives
  end
end
