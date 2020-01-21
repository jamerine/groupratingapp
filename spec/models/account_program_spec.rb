# == Schema Information
#
# Table name: account_programs
#
#  id                      :integer          not null, primary key
#  ac26_signed_on          :date
#  ac2_signed_on           :date
#  check_number            :string
#  contract_signed_on      :date
#  effective_end_date      :date
#  effective_start_date    :date
#  fees_amount             :float
#  group_code              :string
#  invoice_number          :string
#  invoice_received_on     :date
#  paid_amount             :float
#  program_paid_on         :date
#  program_type            :integer
#  questionnaire_signed_on :date
#  quote_date              :date
#  quote_generated         :string
#  quote_sent_date         :date
#  quote_tier              :float
#  status                  :integer
#  u153_signed_on          :date
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  account_id              :integer
#
# Indexes
#
#  index_account_programs_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#

require 'rails_helper'

RSpec.describe AccountProgram, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
