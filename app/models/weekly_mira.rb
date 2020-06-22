# == Schema Information
#
# Table name: weekly_miras
#
#  id         :integer          not null, primary key
#  single_rec :string
#

class WeeklyMira < ActiveRecord::Base
  scope :by_record_type, -> { where("substring(weekly_miras.single_rec,10,2) = '02'") }
  scope :by_representative, -> (rep_number) { where("cast_to_int(substring(weekly_miras.single_rec,1,6)) = ?", rep_number) }

  attr_accessor :representative_number, :record_type, :requestor_number, :policy_number, :business_sequence_number, :valid_policy_number,
                :claim_indicator, :claim_number, :claim_injury_date, :claim_filing_date, :claim_hire_date,
                :gender, :marital_status, :injured_worked_represented, :claim_status, :claim_status_effective_date,
                :claimant_name, :claim_manual_number, :claim_sub_manual_number, :industry_code, :claim_type,
                :claimant_date_of_birth, :claimant_age_at_injury, :claimant_date_of_death, :claim_activity_status,
                :claim_activity_status_effective_date, :prediction_status, :prediction_close_status_effective_date, :claimant_zip_code,
                :catastrophic_claim, :icd1_code, :icd1_code_type, :icd2_code, :icd2_code_type, :icd3_code, :icd3_code_type,
                :average_weekly_wage, :claim_handicap_percent, :claim_handicap_percent_effective_date, :chiropractor,
                :physical_therapy, :salary_continuation, :last_date_worked, :estimated_return_to_work_date, :return_to_work_date,
                :mmi_date, :last_medical_date_of_service, :last_indemnity_period_end_date, :injury_or_litigation_type,
                :medical_ambulance_payments, :medical_clinic_or_nursing_home_payments, :medical_court_cost_payments, :medical_doctors_payments,
                :medical_drug_and_pharmacy_payments, :medical_emergency_room_payments, :medical_funeral_payments,
                :medical_hospital_payments, :medical_medical_device_payments, :medical_misc_payments, :medical_nursing_services_payments,
                :medical_prostheses_device_payments, :medical_prostheses_exam_payments, :medical_travel_payments, :medical_x_rays_and_radiology_payments,
                :total_medical_paid, :medical_reserve_prediction, :total_medical_reserve_amount, :indemnity_change_of_occupation_payments,
                :indemnity_change_of_occupation_reserve_prediction, :indemnity_change_of_occupation_reserve_amount, :indemnity_death_benefit_payments,
                :indemnity_death_benefit_reserve_prediction, :indemnity_death_benefit_reserve_amount, :indemnity_facial_disfigurement_payments,
                :indemnity_facial_disfigurement_reserve_prediction, :indemnity_facial_disfigurement_reserve_amount, :indemnity_living_maintenance_payments,
                :indemnity_living_maintenance_wage_loss_payments, :indemnity_living_maintenance_reserve_prediction, :indemnity_living_maintenance_reserve_amount,
                :indemnity_permanent_partial_payments, :indemnity_percent_permanent_partial_payments, :indemnity_percent_permanent_partial_reserve_prediction,
                :indemnity_percent_permanent_partial_reserve_amount, :indemnity_ptd_payments, :indemnity_ptd_reserve_prediction, :indemnity_ptd_reserve_amount,
                :temporary_total_payments, :temporary_partial_payments, :wage_loss_payments, :indemnity_temporary_total_reserve_prediction,
                :indemnity_temporary_total_reserve_amount, :indemnity_lump_sum_settlement_payments, :indemnity_attorney_fee_payments,
                :indemnity_other_benefit_payments, :total_indemnity_paid_amount, :total_indemnity_reserve_amount, :total_original_reserve_amount,
                :reduction_amount, :total_reserve_amount_for_rates, :reduction_reason

  def detail_record
    WeeklyMiraDetailRecord.where('weekly_mira_detail_records.claim_number IN (?)', [claim_number, claim_number&.strip]).find_by(representative_number: representative_number, policy_number: policy_number)
  end

  def representative_number
    self.single_rec[0, 6]&.to_i
  end

  def record_type
    self.single_rec[9, 2]&.to_i
  end

  def requestor_number
    self.single_rec[11, 3]&.to_i
  end

  def policy_number
    self.single_rec[14, 8]&.to_i
  end

  def business_sequence_number
    self.single_rec[23, 3]&.to_i
  end

  def valid_policy_number
    self.single_rec[26, 1]
  end

  def claim_indicator
    self.single_rec[27, 1]
  end

  def claim_number
    self.single_rec[28, 10]&.strip
  end

  def claim_injury_date
    determine_date(self.single_rec[38, 8])
  end

  def claim_filing_date
    determine_date(self.single_rec[46, 8])
  end

  def claim_hire_date
    determine_date(self.single_rec[54, 8])
  end

  def gender
    self.single_rec[62, 1]
  end

  def marital_status
    self.single_rec[63, 1]
  end

  def injured_worked_represented
    self.single_rec[64, 1]
  end

  def claim_status
    self.single_rec[65, 2]
  end

  def claim_status_effective_date
    determine_date(self.single_rec[67, 8])
  end

  def claimant_name
    self.single_rec[76, 20]&.strip
  end

  def claim_manual_number
    self.single_rec[95, 4]&.to_i
  end

  def claim_sub_manual_number
    self.single_rec[99, 2]&.to_i
  end

  def industry_code
    self.single_rec[101, 2]&.to_i
  end

  def claim_type
    self.single_rec[103, 4]&.to_i
  end

  def claimant_date_of_birth
    determine_date(self.single_rec[107, 8])
  end

  def claimant_age_at_injury
    self.single_rec[115, 2]
  end

  def claimant_date_of_death
    determine_date(self.single_rec[117, 8])
  end

  def claim_activity_status
    self.single_rec[125, 1]
  end

  def claim_activity_status_effective_date
    determine_date(self.single_rec[126, 8])
  end

  def prediction_status
    self.single_rec[134, 1]
  end

  def prediction_close_status_effective_date
    determine_date(self.single_rec[135, 8])
  end

  def claimant_zip_code
    self.single_rec[143, 5]
  end

  def catastrophic_claim
    self.single_rec[148, 1]
  end

  def icd1_code
    self.single_rec[149, 8]&.to_f
  end

  def icd1_code_type
    self.single_rec[157, 1]
  end

  def icd2_code
    self.single_rec[158, 8]&.to_f
  end

  def icd2_code_type
    self.single_rec[166, 1]
  end

  def icd3_code
    self.single_rec[167, 8]&.to_f
  end

  def icd3_code_type
    self.single_rec[175, 1]
  end

  def average_weekly_wage
    self.single_rec[176, 8]&.to_f
  end

  def claim_handicap_percent
    self.single_rec[184, 3]&.to_f
  end

  def claim_handicap_percent_effective_date
    determine_date(self.single_rec[187, 8])
  end

  def chiropractor
    self.single_rec[195, 1]
  end

  def physical_therapy
    self.single_rec[196, 1]
  end

  def salary_continuation
    self.single_rec[197, 1]
  end

  def last_date_worked
    determine_date(self.single_rec[198, 8])
  end

  def estimated_return_to_work_date
    determine_date(self.single_rec[206, 8])
  end

  def return_to_work_date
    determine_date(self.single_rec[214, 8])
  end

  def mmi_date
    determine_date(self.single_rec[222, 8])
  end

  def last_medical_date_of_service
    determine_date(self.single_rec[230, 8])
  end

  def last_indemnity_period_end_date
    determine_date(self.single_rec[238, 8])
  end

  def injury_or_litigation_type
    self.single_rec[246, 2]
  end

  def medical_ambulance_payments
    self.single_rec[248, 12]&.to_f
  end

  def medical_clinic_or_nursing_home_payments
    self.single_rec[260, 12]&.to_f
  end

  def medical_court_cost_payments
    self.single_rec[272, 12]&.to_f
  end

  def medical_doctors_payments
    self.single_rec[284, 12]&.to_f
  end

  def medical_drug_and_pharmacy_payments
    self.single_rec[298, 12]&.to_f
  end

  def medical_emergency_room_payments
    self.single_rec[308, 12]&.to_f
  end

  def medical_funeral_payments
    self.single_rec[320, 12]&.to_f
  end

  def medical_hospital_payments
    self.single_rec[332, 12]&.to_f
  end

  def medical_medical_device_payments
    self.single_rec[344, 12]&.to_f
  end

  def medical_misc_payments
    self.single_rec[356, 12]&.to_f
  end

  def medical_nursing_services_payments
    self.single_rec[368, 12]&.to_f
  end

  def medical_prostheses_device_payments
    self.single_rec[380, 12]&.to_f
  end

  def medical_prostheses_exam_payments
    self.single_rec[392, 12]&.to_f
  end

  def medical_travel_payments
    self.single_rec[404, 12]&.to_f
  end

  def medical_x_rays_and_radiology_payments
    self.single_rec[416, 12]&.to_f
  end

  def total_medical_paid
    self.single_rec[428, 12]&.to_f
  end

  def medical_reserve_prediction
    self.single_rec[440, 1]
  end

  def total_medical_reserve_amount
    self.single_rec[441, 12]&.to_f
  end

  def indemnity_change_of_occupation_payments
    self.single_rec[453, 12]&.to_f
  end

  def indemnity_change_of_occupation_reserve_prediction
    self.single_rec[465, 1]
  end

  def indemnity_change_of_occupation_reserve_amount
    self.single_rec[466, 12]&.to_f
  end

  def indemnity_death_benefit_payments
    self.single_rec[478, 12]&.to_f
  end

  def indemnity_death_benefit_reserve_prediction
    self.single_rec[490, 1]
  end

  def indemnity_death_benefit_reserve_amount
    self.single_rec[491, 12]&.to_f
  end

  def indemnity_facial_disfigurement_payments
    self.single_rec[503, 12]&.to_f
  end

  def indemnity_facial_disfigurement_reserve_prediction
    self.single_rec[515, 1]
  end

  def indemnity_facial_disfigurement_reserve_amount
    self.single_rec[516, 12]&.to_f
  end

  def indemnity_living_maintenance_payments
    self.single_rec[528, 12]&.to_f
  end

  def indemnity_living_maintenance_wage_loss_payments
    self.single_rec[540, 12]&.to_f
  end

  def indemnity_living_maintenance_reserve_prediction
    self.single_rec[552, 1]
  end

  def indemnity_living_maintenance_reserve_amount
    self.single_rec[553, 12]&.to_f
  end

  def indemnity_permanent_partial_payments
    self.single_rec[565, 12]&.to_f
  end

  def indemnity_percent_permanent_partial_payments
    self.single_rec[577, 12]&.to_f
  end

  def indemnity_percent_permanent_partial_reserve_prediction
    self.single_rec[589, 1]
  end

  def indemnity_percent_permanent_partial_reserve_amount
    self.single_rec[590, 12]&.to_f
  end

  def indemnity_ptd_payments
    self.single_rec[602, 12]&.to_f
  end

  def indemnity_ptd_reserve_prediction
    self.single_rec[614, 1]
  end

  def indemnity_ptd_reserve_amount
    self.single_rec[615, 12]&.to_f
  end

  def temporary_total_payments
    self.single_rec[627, 12]&.to_f
  end

  def temporary_partial_payments
    self.single_rec[639, 12]&.to_f
  end

  def wage_loss_payments
    self.single_rec[651, 12]&.to_f
  end

  def indemnity_temporary_total_reserve_prediction
    self.single_rec[663, 1]
  end

  def indemnity_temporary_total_reserve_amount
    self.single_rec[664, 12]&.to_f
  end

  def indemnity_lump_sum_settlement_payments
    self.single_rec[676, 12]&.to_f
  end

  def indemnity_attorney_fee_payments
    self.single_rec[688, 12]&.to_f
  end

  def indemnity_other_benefit_payments
    self.single_rec[700, 12]&.to_f
  end

  def total_indemnity_paid_amount
    self.single_rec[712, 12]&.to_f
  end

  def total_indemnity_reserve_amount
    self.single_rec[724, 12]&.to_f
  end

  def total_original_reserve_amount
    self.single_rec[736, 12]&.to_f
  end

  def reduction_amount
    self.single_rec[748, 12]&.to_f
  end

  def total_reserve_amount_for_rates
    self.single_rec[760, 12]&.to_f
  end

  def reduction_reason
    self.single_rec[772, 1]
  end

  private

  def determine_date(string)
    date_integer = string.to_i || 0
    date_integer > 0 ? date_integer.to_s.to_date : nil
  end
end
