class RemoveConstraintForClicds < ActiveRecord::Migration
  def change
    execute <<-SQL
      ALTER TABLE clicd_detail_records
      DROP CONSTRAINT unique_records_for_clicds;
    SQL
  end
end
