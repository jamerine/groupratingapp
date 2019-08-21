# == Schema Information
#
# Table name: mrcl_detail_records
#
#  id                                 :integer          not null, primary key
#  representative_number              :integer
#  representative_type                :integer
#  record_type                        :integer
#  requestor_number                   :integer
#  policy_type                        :string
#  policy_number                      :integer
#  business_sequence_number           :integer
#  valid_policy_number                :string
#  manual_reclassifications           :string
#  re_classed_from_manual_number      :integer
#  re_classed_to_manual_number        :integer
#  reclass_manual_coverage_type       :string
#  reclass_creation_date              :date
#  reclassed_payroll_information      :string
#  payroll_reporting_period_from_date :date
#  payroll_reporting_period_to_date   :date
#  re_classed_to_manual_payroll_total :float
#  created_at                         :datetime
#  updated_at                         :datetime
#

class MrclDetailRecord < ActiveRecord::Base
  require 'activerecord-import'

  def self.parse_table
    time1 = Time.new
    Resque.enqueue(ParseFile, "mrcls")

    time2 = Time.new
    puts 'Completed Mrcl Parse in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end
end
