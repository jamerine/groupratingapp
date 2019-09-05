# == Schema Information
#
# Table name: democ_detail_records
#
#  id                                        :integer          not null, primary key
#  representative_number                     :integer
#  representative_type                       :integer
#  record_type                               :integer
#  requestor_number                          :integer
#  policy_type                               :string
#  policy_number                             :integer
#  business_sequence_number                  :integer
#  valid_policy_number                       :string
#  current_policy_status                     :string
#  current_policy_status_effective_date      :date
#  claimant_name                             :string
#  policy_year                               :integer
#  policy_year_rating_plan                   :string
#  claim_indicator                           :string
#  claim_number                              :string
#  claim_injury_date                         :date
#  claim_combined                            :string
#  combined_into_claim_number                :string
#  claim_rating_plan_indicator               :string
#  claim_status                              :string
#  claim_status_effective_date               :date
#  claim_manual_number                       :integer
#  claim_sub_manual_number                   :string
#  claim_type                                :string
#  claimant_date_of_death                    :date
#  claimant_date_of_birth                    :date
#  claim_activity_status                     :string
#  claim_activity_status_effective_date      :date
#  settled_claim                             :string
#  settlement_type                           :string
#  medical_settlement_date                   :date
#  indemnity_settlement_date                 :date
#  maximum_medical_improvement_date          :date
#  last_paid_medical_date                    :date
#  last_paid_indemnity_date                  :date
#  average_weekly_wage                       :float
#  full_weekly_wage                          :float
#  claim_handicap_percent                    :string
#  claim_handicap_percent_effective_date     :date
#  claim_mira_ncci_injury_type               :string
#  claim_medical_paid                        :integer
#  claim_mira_medical_reserve_amount         :integer
#  claim_mira_non_reducible_indemnity_paid   :integer
#  claim_mira_reducible_indemnity_paid       :integer
#  claim_mira_indemnity_reserve_amount       :integer
#  industrial_commission_appeal_indicator    :string
#  claim_mira_non_reducible_indemnity_paid_2 :integer
#  claim_total_subrogation_collected         :integer
#  created_at                                :datetime
#  updated_at                                :datetime
#

require 'test_helper'

class DemocDetailRecordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
