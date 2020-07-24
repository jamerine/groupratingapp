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

class Quote < ActiveRecord::Base
  belongs_to :account
  has_one :representative, through: :account

  enum program_type: [:group_rating, :group_retro, :retainer, :grow_ohio, :one_claim_program, :em_cap]

  enum status: [:accepted, :quoted, :sent, :void, :withdraw]

  mount_uploader :quote_generated, QuoteUploader

  delegate :status, to: :account, prefix: true, allow_nil: true

  def client_packet?
    self.account_status&.to_sym&.in?([:client, :new_account, :suspended]) || false
  end

  def prospect_packet?
    !client_packet?
  end

  def generate_invoice_number
    policy_year = self.quote_year
    s           = "#{self.account.policy_number_entered}-#{policy_year}-#{self.id}"
    update_attributes(invoice_number: s)
  end

end
