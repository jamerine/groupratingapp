class ActuallyAddConstraintForClicdsDetailRecords < ActiveRecord::Migration
  def change
    remove_index :clicd_detail_records, name: :unique_records_for_clicds

    execute <<-SQL
      ALTER TABLE clicd_detail_records
      ADD CONSTRAINT unique_records_for_clicds UNIQUE (representative_number, record_type, requestor_number, business_sequence_number, policy_number, claim_number, icd_code);
    SQL
  end
end
