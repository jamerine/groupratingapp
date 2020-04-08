# == Schema Information
#
# Table name: claim_addresses
#
#  id                    :integer          not null, primary key
#  address               :text
#  claim_number          :string
#  policy_number         :integer
#  representative_number :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class ClaimAddress < ActiveRecord::Base
  def claim_calculation
    ClaimCalculation.find_by(claim_number: claim_number, policy_number: policy_number, representative_number: representative_number)
  end
end
