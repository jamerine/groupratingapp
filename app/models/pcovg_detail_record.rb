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

class PcovgDetailRecord < ActiveRecord::Base
  scope :filter_by, -> (representative_number) { where(representative_number: representative_number) }
end
