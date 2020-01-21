# == Schema Information
#
# Table name: process_policy_experience_period_peos
#
#  id                                         :integer          not null, primary key
#  data_source                                :string
#  manual_class_sf_peo_lease_effective_date   :date
#  manual_class_sf_peo_lease_termination_date :date
#  manual_class_si_peo_lease_effective_date   :date
#  manual_class_si_peo_lease_termination_date :date
#  policy_number                              :integer
#  policy_type                                :string
#  representative_number                      :integer
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#
# Indexes
#
#  index_process_policy_experience_period_peos_on_policy_number  (policy_number)
#

class ProcessPolicyExperiencePeriodPeo < ActiveRecord::Base
end
