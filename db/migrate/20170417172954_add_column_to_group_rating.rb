class AddColumnToGroupRating < ActiveRecord::Migration
  def change
    add_column :group_ratings, :current_payroll_year, :integer
    add_column :group_ratings, :program_year_lower_date, :date
    add_column :group_ratings, :program_year_upper_date, :date
    add_column :group_ratings, :program_year, :integer
    add_column :group_ratings, :quote_year_lower_date, :date
    add_column :group_ratings, :quote_year_upper_date, :date
    add_column :group_ratings, :quote_year, :integer
  end
end
