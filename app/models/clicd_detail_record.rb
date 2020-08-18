# == Schema Information
#
# Table name: clicd_detail_records
#
#  id                                   :integer          not null, primary key
#  business_sequence_number             :integer
#  claim_indicator                      :string
#  claim_number                         :string
#  current_policy_status                :string
#  current_policy_status_effective_date :date
#  icd_code                             :string
#  icd_codes_assigned                   :string
#  icd_digit_tooth_number               :string
#  icd_injury_location_code             :string
#  icd_status                           :string
#  icd_status_effective_date            :date
#  policy_number                        :integer
#  policy_year                          :integer
#  policy_year_rating_plan              :string
#  primary_icd                          :string
#  record_type                          :integer
#  representative_number                :integer
#  requestor_number                     :integer
#  valid_policy_number                  :string
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class ClicdDetailRecord < ActiveRecord::Base
  scope :filter_by, -> (representative_number) { where(representative_number: representative_number) }

  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

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
