class CreateExceptionTablePolicyCombinedRequestPayrollInfos < ActiveRecord::Migration
  def change
    create_table :exception_table_policy_combined_request_payroll_infos do |t|
      t.string :predecessor_policy_type
      t.integer :predecessor_policy_number
      t.string :successor_policy_type
      t.integer :successor_policy_number
      t.string :transfer_type
      t.date :transfer_effective_date
      t.date :transfer_creation_date
      t.string :payroll_origin
      t.string :data_source
      t.timestamps null: false
    end
  end
end
