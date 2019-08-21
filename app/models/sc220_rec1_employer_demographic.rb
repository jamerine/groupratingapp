# == Schema Information
#
# Table name: sc220_rec1_employer_demographics
#
#  id                                       :integer          not null, primary key
#  representative_number                    :integer
#  representative_type                      :integer
#  description_ar                           :string
#  record_type                              :integer
#  request_type                             :integer
#  policy_type                              :string
#  policy_number                            :integer
#  business_sequence_number                 :integer
#  federal_identification_number            :string
#  business_name                            :string
#  trading_as_name                          :string
#  in_care_name_contact_name                :string
#  address_1                                :string
#  address_2                                :string
#  city                                     :string
#  state                                    :string
#  zip_code                                 :string
#  zip_code_plus_4                          :string
#  country_code                             :string
#  county                                   :string
#  currently_assigned_representative_number :integer
#  currently_assigned_representative_type   :string
#  successor_policy_number                  :integer
#  successor_business_sequence_number       :integer
#  merit_rate                               :float
#  group_code                               :string
#  minimum_premium_percentage               :string
#  rate_adjust_factor                       :string
#  em_effective_date                        :date
#  n2nd_merit_rate                          :float
#  n2nd_group_code                          :string
#  n2nd_minimum_premium_percentage          :string
#  n2nd_rate_adjust_factor                  :string
#  n2nd_em_effective_date                   :date
#  n3rd_merit_rate                          :float
#  n3rd_group_code                          :string
#  n3rd_minimum_premium_percentage          :string
#  n3rd_rate_adjust_factor                  :string
#  n3rd_em_effective_date                   :date
#  n4th_merit_rate                          :float
#  n4th_group_code                          :string
#  n4th_minimum_premium_percentage          :string
#  n4th_rate_adjust_factor                  :string
#  n4th_em_effective_date                   :date
#  n5th_merit_rate                          :float
#  n5th_group_code                          :string
#  n5th_minimum_premium_percentage          :string
#  n5th_rate_adjust_factor                  :string
#  n5th_em_effective_date                   :date
#  n6th_merit_rate                          :float
#  n6th_group_code                          :string
#  n6th_minimum_premium_percentage          :string
#  n6th_rate_adjust_factor                  :string
#  n6th_em_effective_date                   :date
#  n7th_merit_rate                          :float
#  n7th_group_code                          :string
#  n7th_minimum_premium_percentage          :string
#  n7th_rate_adjust_factor                  :string
#  n7th_em_effective_date                   :date
#  n8th_merit_rate                          :float
#  n8th_group_code                          :string
#  n8th_minimum_premium_percentage          :string
#  n8th_rate_adjust_factor                  :string
#  n8th_em_effective_date                   :date
#  n9th_merit_rate                          :float
#  n9th_group_code                          :string
#  n9th_minimum_premium_percentage          :string
#  n9th_rate_adjust_factor                  :string
#  n9th_em_effective_date                   :date
#  n10th_merit_rate                         :float
#  n10th_group_code                         :string
#  n10th_minimum_premium_percentage         :string
#  n10th_rate_adjust_factor                 :string
#  n10th_em_effective_date                  :date
#  n11th_merit_rate                         :float
#  n11th_group_code                         :string
#  n11th_minimum_premium_percentage         :string
#  n11th_rate_adjust_factor                 :string
#  n11th_em_effective_date                  :date
#  n12th_merit_rate                         :float
#  n12th_group_code                         :string
#  n12th_minimum_premium_percentage         :string
#  n12th_rate_adjust_factor                 :string
#  n12th_em_effective_date                  :date
#  coverage_status                          :string
#  coverage_effective_date                  :date
#  coverage_end_date                        :date
#  n2nd_coverage_status                     :string
#  n2nd_coverage_effective_date             :date
#  n2nd_coverage_end_date                   :date
#  n3rd_coverage_status                     :string
#  n3rd_coverage_effective_date             :date
#  n3rd_coverage_end_date                   :date
#  n4th_coverage_status                     :string
#  n4th_coverage_effective_date             :date
#  n4th_coverage_end_date                   :date
#  n5th_coverage_status                     :string
#  n5th_coverage_effective_date             :date
#  n5th_coverage_end_date                   :date
#  n6th_coverage_status                     :string
#  n6th_coverage_effective_date             :date
#  n6th_coverage_end_date                   :date
#  regular_balance_amount                   :float
#  attorney_general_balance_amount          :float
#  appealed_balance_amount                  :float
#  pending_balance_amount                   :float
#  advance_deposit_amount                   :float
#  created_at                               :datetime         not null
#  updated_at                               :datetime         not null
#

class Sc220Rec1EmployerDemographic < ActiveRecord::Base
  require 'activerecord-import'

  def self.parse_table
    time1 = Time.new
      Resque.enqueue(ParseFile, "sc220")
    time2 = Time.new
    puts 'Completed SC220 Parse in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end
end
