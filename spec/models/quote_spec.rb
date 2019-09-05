# == Schema Information
#
# Table name: quotes
#
#  id                                :integer          not null, primary key
#  account_id                        :integer
#  program_type                      :integer
#  status                            :integer
#  fees                              :float
#  invoice_number                    :string
#  quote_generated                   :string
#  quote_date                        :date
#  effective_start_date              :date
#  effective_end_date                :date
#  ac2_signed_on                     :date
#  ac26_signed_on                    :date
#  u153_signed_on                    :date
#  contract_signed_on                :date
#  questionnaire_signed_on           :date
#  invoice_signed_on                 :date
#  group_code                        :string
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  questionnaire_question_1          :boolean
#  questionnaire_question_2          :boolean
#  questionnaire_question_3          :boolean
#  questionnaire_question_4          :boolean
#  questionnaire_question_5          :boolean
#  quote                             :string
#  quote_tier                        :float
#  experience_period_lower_date      :date
#  experience_period_upper_date      :date
#  current_payroll_period_lower_date :date
#  current_payroll_period_upper_date :date
#  current_payroll_year              :integer
#  program_year_lower_date           :date
#  program_year_upper_date           :date
#  program_year                      :integer
#  quote_year_lower_date             :date
#  quote_year_upper_date             :date
#  quote_year                        :integer
#  paid_amount                       :float
#  check_number                      :string
#  questionnaire_question_6          :boolean
#  updated_by                        :string
#  created_by                        :string
#  paid_date                         :date
#

require 'rails_helper'

RSpec.describe Quote, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
