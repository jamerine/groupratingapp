# == Schema Information
#
# Table name: employer_demographics
#
#  id                                        :integer          not null, primary key
#  business_city                             :string
#  business_contact_name                     :string
#  business_extension                        :string
#  business_fax                              :string
#  business_phone                            :string
#  business_sequence_number                  :integer          default(0)
#  business_state_code                       :string
#  business_street_address_1                 :string
#  business_street_address_2                 :string
#  business_zip_code                         :string
#  city_name                                 :string
#  county_name                               :string
#  current_industry_description              :string
#  current_industry_number                   :integer
#  deductible_amount                         :float
#  deductible_rating_plan_factor             :string
#  deleted_at                                :datetime
#  drug_free_safety_program_flag             :string
#  em_cap_flag                               :string
#  employer_rep_emplr_risk_claim             :string
#  employer_rep_group_risk_claim             :string
#  employer_rep_risk_management              :string
#  employer_state                            :string           default("OH")
#  employer_year                             :integer
#  fax_extension                             :string
#  fifteen_program_indicator                 :string
#  go_green_flag                             :string
#  governing_class_code                      :integer
#  group_experience_rated_program            :float
#  group_rating_flag                         :string
#  group_retro_flag                          :string
#  group_retro_max_premium_ratio             :float
#  grow_ohio_participation_flag              :string
#  individual_retro_flag                     :string
#  industry_specific_safety_program_flag     :string
#  interstate_experience_modifier            :float
#  interstate_experience_modifier_flag       :string
#  intrastate_retrospective_rating_flag      :string
#  intrastate_retrospective_rating_program   :float
#  lapse_free_discount_flag                  :string
#  mco_id_number                             :integer
#  mco_name                                  :string
#  mco_relationship_beginning_date           :datetime
#  one_claim_program_flag                    :string
#  penalty_rated_flag                        :string
#  policy_number                             :integer
#  policy_original_effective_date            :datetime
#  policy_period_beginning_date              :datetime
#  policy_period_ending_date                 :datetime
#  policy_status                             :string
#  policy_status_reason                      :string
#  policy_type                               :string
#  premium_range                             :string
#  primary_contact_email                     :string
#  primary_dba_name                          :string
#  primary_name                              :string
#  risk_group_number                         :integer
#  safety_council_participation_factor       :string
#  safety_council_performance_factor         :string
#  state_code                                :string
#  status_reason_effective_date              :datetime
#  street_address_line_1                     :string
#  street_address_line_2                     :string
#  transitional_work_performance_rate_factor :string
#  zip_code                                  :string
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#
# Indexes
#
#  index_employer_demographics_on_deleted_at  (deleted_at)
#

require 'rails_helper'

RSpec.describe EmployerDemographic, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
