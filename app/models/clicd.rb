# == Schema Information
#
# Table name: clicds
#
#  id         :integer          not null, primary key
#  single_rec :string
#

class Clicd < ActiveRecord::Base
  scope :by_record_type, -> { where("substring(clicds.single_rec,10,2) = '02'") }
  scope :by_representative, -> (rep_number) { where("cast_to_int(substring(clicds.single_rec,1,6)) = ?", rep_number) }

  attr_accessor :representative_number, :record_type, :requestor_number, :policy_number, :business_sequence_number, :valid_policy_number,
                :current_policy_status, :current_policy_status_effective_date, :policy_year, :policy_year_rating_plan, :claim_indicator, :claim_number,
                :icd_codes_assigned, :icd_code, :icd_status, :icd_status_effective_date, :icd_injury_location_code, :icd_digit_tooth_number, :primary_icd

  def detail_record
    ClicdDetailRecord.find_by(representative_number: representative_number, policy_number: policy_number, claim_number: claim_number)
  end

  def representative_number
    self.single_rec[0, 6]&.to_i
  end

  def record_type
    self.single_rec[9, 2]&.to_i
  end

  def requestor_number
    self.single_rec[12, 3]&.to_i
  end

  def policy_number
    self.single_rec[15, 1] == '0' ? self.single_rec[15, 7]&.to_i : self.single_rec[15, 1]&.to_i
  end

  def business_sequence_number
    self.single_rec[23, 3]&.to_i
  end

  def valid_policy_number
    self.single_rec[26, 1]
  end

  def current_policy_status
    self.single_rec[27, 5]
  end

  def current_policy_status_effective_date
    determine_date(self.single_rec[32, 8])
  end

  def policy_year
    self.single_rec[40, 4]&.to_i
  end

  def policy_year_rating_plan
    self.single_rec[44, 5]
  end

  def claim_indicator
    self.single_rec[49, 1]
  end

  def claim_number
    self.single_rec[50, 10]
  end

  def icd_codes_assigned
    self.single_rec[60, 1]
  end

  def icd_code
    self.single_rec[61, 7]
  end

  def icd_status
    self.single_rec[68, 2]
  end

  def icd_status_effective_date
    determine_date(self.single_rec[70, 8])
  end

  def icd_injury_location_code
    self.single_rec[78, 1]
  end

  def icd_digit_tooth_number
    self.single_rec[79, 2]
  end

  def primary_icd
    self.single_rec[82, 1]
  end

  private

  def determine_date(string)
    date_integer = string.to_i || 0
    date_integer > 0 ? date_integer.to_s.to_date : nil
  end
end
