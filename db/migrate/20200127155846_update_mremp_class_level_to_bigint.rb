class UpdateMrempClassLevelToBigint < ActiveRecord::Migration
  def change
    change_column :mremp_employee_experience_manual_class_levels, :experience_period_payroll, :bigint
  end
end
