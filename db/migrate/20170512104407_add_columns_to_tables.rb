class AddColumnsToTables < ActiveRecord::Migration
  def change
    add_column :process_payroll_all_transactions_breakdown_by_manual_classes, :manual_class_transferred, :integer
    add_column :process_payroll_breakdown_by_manual_classes, :manual_class_transferred, :integer
    add_column :payroll_calculations, :manual_class_transferred, :integer
  end
end
