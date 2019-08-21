# == Schema Information
#
# Table name: pcovg_detail_records
#
#  id                             :integer          not null, primary key
#  representative_number          :integer
#  record_type                    :integer
#  requestor_number               :integer
#  policy_number                  :integer
#  business_sequence_number       :integer
#  valid_policy_number            :string
#  coverage_status                :string
#  coverage_status_effective_date :date
#  coverage_status_end_date       :date
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

require 'rails_helper'

RSpec.describe PcovgDetailRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
