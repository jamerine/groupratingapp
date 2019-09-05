# == Schema Information
#
# Table name: mremp_employee_experience_claim_levels
#
#  id                                             :integer          not null, primary key
#  representative_number                          :integer
#  representative_type                            :integer
#  policy_type                                    :string
#  policy_number                                  :integer
#  business_sequence_number                       :integer
#  record_type                                    :integer
#  manual_number                                  :integer
#  sub_manual_number                              :string
#  claim_reserve_code                             :string
#  claim_number                                   :string
#  injury_date                                    :date
#  claim_indemnity_paid_using_mira_rules          :integer
#  claim_indemnity_mira_reserve                   :integer
#  claim_medical_paid                             :integer
#  claim_medical_reserve                          :integer
#  claim_indemnity_handicap_paid_using_mira_rules :integer
#  claim_indemnity_handicap_mira_reserve          :integer
#  claim_medical_handicap_paid                    :integer
#  claim_medical_handicap_reserve                 :integer
#  claim_surplus_type                             :string
#  claim_handicap_percent                         :string
#  claim_over_policy_max_value_indicator          :string
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#

class MrempEmployeeExperienceClaimLevel < ActiveRecord::Base
  
end
