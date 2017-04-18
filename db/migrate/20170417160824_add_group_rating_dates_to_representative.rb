class AddGroupRatingDatesToRepresentative < ActiveRecord::Migration
  def change
    add_column :representatives, :experience_period_lower_date, :date
    add_column :representatives, :experience_period_upper_date, :date
    add_column :representatives, :current_payroll_period_lower_date, :date
    add_column :representatives, :current_payroll_period_upper_date, :date
    add_column :representatives, :current_payroll_year, :integer
    add_column :representatives, :program_year_lower_date, :date
    add_column :representatives, :program_year_upper_date, :date
    add_column :representatives, :program_year, :integer
    add_column :representatives, :quote_year_lower_date, :date
    add_column :representatives, :quote_year_upper_date, :date
    add_column :representatives, :quote_year, :integer
  end
end
