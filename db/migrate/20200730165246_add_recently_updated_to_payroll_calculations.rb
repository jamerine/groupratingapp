class AddRecentlyUpdatedToPayrollCalculations < ActiveRecord::Migration
  def change
    add_column :payroll_calculations, :recently_updated, :boolean, default: false
  end
end
