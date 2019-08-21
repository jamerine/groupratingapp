# == Schema Information
#
# Table name: sc230_claim_medical_payments
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
#  from_date                :string
#  to_date                  :string
#  award_type               :string
#  number_of_weeks          :string
#  awarded_weekly_rate      :string
#  award_amount             :integer
#  payment_amount           :float
#  claimant_name            :string
#  payee_name               :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class Sc230ClaimMedicalPayment < ActiveRecord::Base
end
