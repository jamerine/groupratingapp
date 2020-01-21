# == Schema Information
#
# Table name: policy_program_histories
#
#  id                                              :integer          not null, primary key
#  business_sequence_number                        :integer
#  deductible_discount_percentage                  :integer
#  deductible_level                                :integer
#  deductible_participation_indicator              :string
#  deductible_stop_loss_indicator                  :string
#  drug_free_program_discount_eligiblity_indicator :string
#  drug_free_program_participation_indicator       :string
#  drug_free_program_participation_level           :string
#  drug_free_program_type                          :string
#  em_cap_participation_indicator                  :string
#  em_effective_date                               :date
#  experience_modifier_rate                        :float
#  group_code                                      :integer
#  group_participation_indicator                   :string
#  group_type                                      :string
#  grow_ohio_participation_indicator               :string
#  issp_discount_eligibility_indicator             :string
#  issp_participation_indicator                    :string
#  ocp_first_year_of_participation                 :integer
#  ocp_participation                               :integer
#  ocp_participation_indicator                     :string
#  policy_number                                   :integer
#  policy_year                                     :integer
#  reporting_period_end_date                       :date
#  reporting_period_start_date                     :date
#  representative_number                           :integer
#  rrr_minimum_premium_percentage                  :integer
#  rrr_participation_indicator                     :string
#  rrr_policy_claim_limit                          :integer
#  rrr_tier                                        :integer
#  twbns_discount_eligibility_indicator            :string
#  twbns_participation_indicator                   :string
#  created_at                                      :datetime         not null
#  updated_at                                      :datetime         not null
#  policy_calculation_id                           :integer
#  representative_id                               :integer
#
# Indexes
#
#  index_policy_program_histories_on_policy_calculation_id  (policy_calculation_id)
#  index_policy_program_histories_on_representative_id      (representative_id)
#
# Foreign Keys
#
#  fk_rails_...  (policy_calculation_id => policy_calculations.id)
#  fk_rails_...  (representative_id => representatives.id)
#

require 'rails_helper'

RSpec.describe PolicyProgramHistory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
