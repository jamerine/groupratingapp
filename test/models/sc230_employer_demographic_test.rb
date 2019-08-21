# == Schema Information
#
# Table name: sc230_employer_demographics
#
#  id                       :integer          not null, primary key
#  representative_number    :integer
#  representative_type      :integer
#  policy_type              :string
#  policy_number            :integer
#  business_sequence_number :integer
#  claim_manual_number      :integer
#  record_type              :string
#  claim_number             :string
#  policy_name              :string
#  doing_business_as_name   :string
#  street_address           :string
#  city                     :string
#  state                    :string
#  zip_code                 :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'test_helper'

class Sc230EmployerDemographicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
