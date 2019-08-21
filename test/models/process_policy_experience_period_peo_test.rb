# == Schema Information
#
# Table name: process_policy_experience_period_peos
#
#  id                                         :integer          not null, primary key
#  representative_number                      :integer
#  policy_type                                :string
#  policy_number                              :integer
#  manual_class_sf_peo_lease_effective_date   :date
#  manual_class_sf_peo_lease_termination_date :date
#  manual_class_si_peo_lease_effective_date   :date
#  manual_class_si_peo_lease_termination_date :date
#  data_source                                :string
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#

require 'test_helper'

class ProcessPolicyExperiencePeriodPeoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
