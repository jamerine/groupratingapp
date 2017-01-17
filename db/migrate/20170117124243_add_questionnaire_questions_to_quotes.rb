class AddQuestionnaireQuestionsToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :questionnaire_question_1, :boolean
    add_column :quotes, :questionnaire_question_2, :boolean
    add_column :quotes, :questionnaire_question_3, :boolean
    add_column :quotes, :questionnaire_question_4, :boolean
    add_column :quotes, :questionnaire_question_5, :boolean
  end
end
