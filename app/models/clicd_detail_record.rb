# == Schema Information
#
# Table name: clicd_detail_records
#
#  id                                   :integer          not null, primary key
#  representative_number                :integer
#  record_type                          :integer
#  requestor_number                     :integer
#  policy_number                        :integer
#  business_sequence_number             :integer
#  valid_policy_number                  :string
#  current_policy_status                :string
#  current_policy_status_effective_date :date
#  policy_year                          :integer
#  policy_year_rating_plan              :string
#  claim_indicator                      :string
#  claim_number                         :string
#  icd_codes_assigned                   :string
#  icd_code                             :string
#  icd_status                           :string
#  icd_status_effective_date            :date
#  icd_injury_location_code             :string
#  icd_digit_tooth_number               :string
#  primary_icd                          :string
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class ClicdDetailRecord < ActiveRecord::Base
  scope :filter_by, -> (representative_number) { where(representative_number: representative_number) }

  def icd_status_display
    case self.icd_status
    when "AG"
      "Alleged"
    when "AL"
      "Allowed"
    when "AA"
      "Allow/Appeal"
    when "DA"
      "Disallowed"
    when "DP"
      "Disallow/APPL"
    when "HR"
      "Hearing:"
    when "HD"
      "Hearing-DHO"
    when "DS"
      "Dismissed"
    end
  end
end
