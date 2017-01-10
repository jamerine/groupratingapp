class CreateAccountPrograms < ActiveRecord::Migration
  def change
    create_table :account_programs do |t|
      t.references :account, index: true, foreign_key: true
      t.integer :program_type
      t.integer :status
      t.float :fees_amount
      t.float :paid_amount
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
      t.date :invoice_received_on
      t.date :program_paid_on
      t.string :group_code
      t.string :check_number


      t.timestamps null: false
    end
  end
end
