class AddUniqueConstraintToClicds < ActiveRecord::Migration
  def change
    add_index :clicd_detail_records,
              [:representative_number,
               :record_type,
               :requestor_number,
               :business_sequence_number,
               :policy_number,
               :claim_number,
               :icd_code],
              unique: true,
              name: :unique_records_for_clicds
  end
end
