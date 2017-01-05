class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.references :account, index: true, foreign_key: true
      t.integer :program_type
      t.integer :status
      t.float :fees
      t.float :amount
      t.string :invoice_number
      t.string :quote_generated
      t.date :quote_date
      t.date :quote_sent_date
      t.date :effective_start_date
      t.date :effective_end_date
      t.date :ac2_signed_on
      t.date :ac26_signed_on
      t.date :u153_signed_on
      t.date :contract_signed_on
      t.date :questionnaire_signed_on
      t.date :invoice_signed_on

      t.timestamps null: false
    end
  end
end
