class AddColumnsToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :experience_period_lower_date, :date
    add_column :quotes, :experience_period_upper_date, :date
    add_column :quotes, :current_payroll_period_lower_date, :date
    add_column :quotes, :current_payroll_period_upper_date, :date
    add_column :quotes, :current_payroll_year, :integer
    add_column :quotes, :program_year_lower_date, :date
    add_column :quotes, :program_year_upper_date, :date
    add_column :quotes, :program_year, :integer
    add_column :quotes, :quote_year_lower_date, :date
    add_column :quotes, :quote_year_upper_date, :date
    add_column :quotes, :quote_year, :integer
  end
end
