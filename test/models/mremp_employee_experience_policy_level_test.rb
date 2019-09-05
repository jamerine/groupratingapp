# == Schema Information
#
# Table name: mremp_employee_experience_policy_levels
#
#  id                                    :integer          not null, primary key
#  representative_number                 :integer
#  representative_type                   :integer
#  policy_type                           :string
#  policy_number                         :integer
#  business_sequence_number              :integer
#  record_type                           :integer
#  manual_number                         :integer
#  sub_manual_number                     :string
#  claim_reserve_code                    :string
#  claim_number                          :string
#  federal_id                            :string
#  grand_total_modified_losses           :integer
#  grand_total_expected_losses           :integer
#  grand_total_limited_losses            :integer
#  policy_maximum_claim_size             :integer
#  policy_credibility                    :float
#  policy_experience_modifier_percent    :float
#  employer_name                         :string
#  doing_business_as_name                :string
#  referral_name                         :string
#  address                               :string
#  city                                  :string
#  state                                 :string
#  zip_code                              :string
#  print_code                            :string
#  policy_year                           :integer
#  extract_date                          :date
#  policy_year_exp_period_beginning_date :date
#  policy_year_exp_period_ending_date    :date
#  green_year                            :string
#  reserves_used_in_the_published_em     :string
#  risk_group_number                     :string
#  em_capped_flag                        :string
#  capped_em_percentage                  :string
#  ocp_flag                              :string
#  construction_cap_flag                 :string
#  published_em_percentage               :float
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#

require 'test_helper'

class MrempEmployeeExperiencePolicyLevelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
