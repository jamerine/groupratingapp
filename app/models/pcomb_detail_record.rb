# == Schema Information
#
# Table name: pcomb_detail_records
#
#  id                                   :integer          not null, primary key
#  representative_number                :integer
#  representative_type                  :integer
#  record_type                          :integer
#  requestor_number                     :integer
#  policy_type                          :string
#  policy_number                        :integer
#  business_sequence_number             :integer
#  valid_policy_number                  :string
#  policy_combinations                  :string
#  predecessor_policy_type              :string
#  predecessor_policy_number            :integer
#  predecessor_filler                   :string
#  predecessor_business_sequence_number :string
#  successor_policy_type                :string
#  successor_policy_number              :integer
#  successor_filler                     :string
#  successor_business_sequence_number   :string
#  transfer_type                        :string
#  transfer_effective_date              :date
#  transfer_creation_date               :date
#  partial_transfer_due_to_labor_lease  :string
#  labor_lease_type                     :string
#  partial_transfer_payroll_movement    :string
#  ncci_manual_number                   :integer
#  manual_coverage_type                 :string
#  payroll_reporting_period_from_date   :date
#  payroll_reporting_period_to_date     :date
#  manual_payroll                       :float
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class PcombDetailRecord < ActiveRecord::Base
  require 'activerecord-import'

  scope :filter_by, -> (representative_number) { where(representative_number: representative_number) }

  def self.parse_table
    time1 = Time.new
      Resque.enqueue(ParseFile, "pcomb")
    time2 = Time.new
    puts 'Completed Pcomb Parse in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end
end
