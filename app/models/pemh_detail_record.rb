# == Schema Information
#
# Table name: pemh_detail_records
#
#  id                                              :integer          not null, primary key
#  representative_number                           :integer
#  record_type                                     :integer
#  requestor_number                                :integer
#  policy_number                                   :integer
#  business_sequence_number                        :integer
#  valid_policy_number                             :string
#  current_coverage_status                         :string
#  coverage_status_effective_date                  :date
#  experience_modifier_rate                        :float
#  em_effective_date                               :date
#  policy_year                                     :integer
#  reporting_period_start_date                     :date
#  reporting_period_end_date                       :date
#  group_participation_indicator                   :string
#  group_code                                      :integer
#  group_type                                      :string
#  rrr_participation_indicator                     :string
#  rrr_tier                                        :integer
#  rrr_policy_claim_limit                          :integer
#  rrr_minimum_premium_percentage                  :integer
#  deductible_participation_indicator              :string
#  deductible_level                                :integer
#  deductible_stop_loss_indicator                  :string
#  deductible_discount_percentage                  :integer
#  ocp_participation_indicator                     :string
#  ocp_participation                               :integer
#  ocp_first_year_of_participation                 :integer
#  grow_ohio_participation_indicator               :string
#  em_cap_participation_indicator                  :string
#  drug_free_program_participation_indicator       :string
#  drug_free_program_type                          :string
#  drug_free_program_participation_level           :string
#  drug_free_program_discount_eligiblity_indicator :string
#  issp_participation_indicator                    :string
#  issp_discount_eligibility_indicator             :string
#  twbns_participation_indicator                   :string
#  twbns_discount_eligibility_indicator            :string
#  created_at                                      :datetime         not null
#  updated_at                                      :datetime         not null
#

class PemhDetailRecord < ActiveRecord::Base
  scope :filter_by, -> (representative_number) { where(representative_number: representative_number) }
end
