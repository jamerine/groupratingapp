class AddsOtherFieldsForEmpDemo < ActiveRecord::Migration
  def change
    add_column :employer_demographics, :policy_period_beginning_date, :datetime, null: true
    add_column :employer_demographics, :policy_period_ending_date, :datetime, null: true
    add_column :employer_demographics, :fifteen_program_indicator, :string, null: true
  end
end
