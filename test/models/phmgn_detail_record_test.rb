# == Schema Information
#
# Table name: phmgn_detail_records
#
#  id                                                              :integer          not null, primary key
#  representative_number                                           :integer
#  representative_type                                             :integer
#  record_type                                                     :integer
#  requestor_number                                                :integer
#  policy_type                                                     :string
#  policy_number                                                   :integer
#  business_sequence_number                                        :integer
#  valid_policy_number                                             :string
#  experience_payroll_premium_information                          :string
#  industry_code                                                   :string
#  ncci_manual_number                                              :integer
#  manual_coverage_type                                            :string
#  manual_payroll                                                  :float
#  manual_premium                                                  :float
#  premium_percentage                                              :float
#  upcoming_policy_year                                            :integer
#  policy_year_extracted_for_experience_payroll_determining_premiu :integer
#  policy_year_extracted_beginning_date                            :date
#  policy_year_extracted_ending_date                               :date
#  created_at                                                      :datetime         not null
#  updated_at                                                      :datetime         not null
#

require 'test_helper'

class PhmgnDetailRecordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
