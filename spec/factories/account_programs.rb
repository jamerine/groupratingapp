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

FactoryGirl.define do
  factory :account_program do
    
  end
end
