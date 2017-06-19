class AddColummnsToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :questionnaire_question_6, :boolean
    add_column :quotes, :updated_by, :string
    add_column :quotes, :created_by, :string
    add_column :quotes, :paid_date, :date
    remove_column :quotes, :amount, :float
    remove_column :quotes, :quote_sent_date, :date

  end
end
