# == Schema Information
#
# Table name: account_programs
#
#  id                      :integer          not null, primary key
#  account_id              :integer
#  program_type            :integer
#  status                  :integer
#  fees_amount             :float
#  paid_amount             :float
#  invoice_number          :string
#  quote_generated         :string
#  quote_date              :date
#  quote_sent_date         :date
#  effective_start_date    :date
#  effective_end_date      :date
#  ac2_signed_on           :date
#  ac26_signed_on          :date
#  u153_signed_on          :date
#  contract_signed_on      :date
#  questionnaire_signed_on :date
#  invoice_received_on     :date
#  program_paid_on         :date
#  group_code              :string
#  check_number            :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  quote_tier              :float
#

class AccountProgram < ActiveRecord::Base
  belongs_to :account
  has_one :representative, through: :account

  enum program_type: [:group_rating, :group_retro, :retainer, :grow_ohio, :one_claim_program, :em_cap]

  enum status: [:accepted, :rejected, :void, :withdraw]

  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

end
