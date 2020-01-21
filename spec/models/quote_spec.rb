# == Schema Information
#
# Table name: quotes
#
#  id                                :integer          not null, primary key
#  ac26_signed_on                    :date
#  ac2_signed_on                     :date
#  check_number                      :string
#  contract_signed_on                :date
#  created_by                        :string
#  current_payroll_period_lower_date :date
#  current_payroll_period_upper_date :date
#  current_payroll_year              :integer
#  effective_end_date                :date
#  effective_start_date              :date
#  experience_period_lower_date      :date
#  experience_period_upper_date      :date
#  fees                              :float
#  group_code                        :string
#  invoice_number                    :string
#  invoice_signed_on                 :date
#  paid_amount                       :float
#  paid_date                         :date
#  program_type                      :integer
#  program_year                      :integer
#  program_year_lower_date           :date
#  program_year_upper_date           :date
#  questionnaire_question_1          :boolean
#  questionnaire_question_2          :boolean
#  questionnaire_question_3          :boolean
#  questionnaire_question_4          :boolean
#  questionnaire_question_5          :boolean
#  questionnaire_question_6          :boolean
#  questionnaire_signed_on           :date
#  quote                             :string
#  quote_date                        :date
#  quote_generated                   :string
#  quote_tier                        :float
#  quote_year                        :integer
#  quote_year_lower_date             :date
#  quote_year_upper_date             :date
#  status                            :integer
#  u153_signed_on                    :date
#  updated_by                        :string
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  account_id                        :integer
#
# Indexes
#
#  index_quotes_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#

require 'rails_helper'

RSpec.describe Quote, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
