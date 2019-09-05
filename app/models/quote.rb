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

class Quote < ActiveRecord::Base
  belongs_to :account
  has_one :representative, through: :account

  enum program_type: [:group_rating, :group_retro, :retainer, :grow_ohio, :one_claim_program, :em_cap]

  enum status: [:accepted, :quoted, :sent, :void, :withdraw]

  mount_uploader :quote_generated, QuoteUploader

  def generate_invoice_number
    policy_year = self.quote_year
    s = "#{self.account.policy_number_entered}-#{policy_year}-#{self.id}"
    update_attributes(invoice_number: s)
  end

end
