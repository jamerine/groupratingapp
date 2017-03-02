class AddColumnToPayrollCalculation < ActiveRecord::Migration
  def change
    add_column :payroll_calculations, :manual_class_rate, :float
  end
end
