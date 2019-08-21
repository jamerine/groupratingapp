# == Schema Information
#
# Table name: sc230_claim_indemnity_awards
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
#  hearing_date             :date
#  injury_date              :date
#  from_date                :date
#  to_date                  :date
#  award_type               :string
#  number_of_weeks          :string
#  awarded_weekly_rate      :float
#  award_amount             :float
#  payment_amount           :integer
#  claimant_name            :string
#  payee_name               :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'test_helper'

class Sc230ClaimIndemnityAwardTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
