# == Schema Information
#
# Table name: weekly_mira_detail_records
#
#  id                                                     :integer          not null, primary key
#  average_weekly_wage                                    :float
#  business_sequence_number                               :integer
#  catastrophic_claim                                     :string
#  chiropractor                                           :string
#  claim_activity_status                                  :string
#  claim_activity_status_effective_date                   :date
#  claim_filing_date                                      :date
#  claim_handicap_percent                                 :float
#  claim_handicap_percent_effective_date                  :date
#  claim_hire_date                                        :date
#  claim_indicator                                        :string
#  claim_injury_date                                      :date
#  claim_manual_number                                    :integer
#  claim_number                                           :string
#  claim_status                                           :string
#  claim_status_effective_date                            :date
#  claim_sub_manual_number                                :integer
#  claim_type                                             :integer
#  claimant_age_at_injury                                 :string
#  claimant_date_of_birth                                 :date
#  claimant_date_of_death                                 :date
#  claimant_name                                          :string
#  claimant_zip_code                                      :string
#  estimated_return_to_work_date                          :date
#  gender                                                 :string
#  icd1_code                                              :float
#  icd1_code_type                                         :string           default("P")
#  icd2_code                                              :float
#  icd2_code_type                                         :string           default("S")
#  icd3_code                                              :float
#  icd3_code_type                                         :string           default("T")
#  indemnity_attorney_fee_payments                        :float
#  indemnity_change_of_occupation_payments                :float
#  indemnity_change_of_occupation_reserve_amount          :float
#  indemnity_change_of_occupation_reserve_prediction      :string
#  indemnity_death_benefit_payments                       :float
#  indemnity_death_benefit_reserve_amount                 :float
#  indemnity_death_benefit_reserve_prediction             :string
#  indemnity_facial_disfigurement_payments                :float
#  indemnity_facial_disfigurement_reserve_amount          :float
#  indemnity_facial_disfigurement_reserve_prediction      :string
#  indemnity_living_maintenance_payments                  :float
#  indemnity_living_maintenance_reserve_amount            :float
#  indemnity_living_maintenance_reserve_prediction        :string
#  indemnity_living_maintenance_wage_loss_payments        :float
#  indemnity_lump_sum_settlement_payments                 :float
#  indemnity_other_benefit_payments                       :float
#  indemnity_percent_permanent_partial_payments           :float
#  indemnity_percent_permanent_partial_reserve_amount     :float
#  indemnity_percent_permanent_partial_reserve_prediction :string
#  indemnity_permanent_partial_payments                   :float
#  indemnity_ptd_payments                                 :float
#  indemnity_ptd_reserve_amount                           :float
#  indemnity_ptd_reserve_prediction                       :string
#  indemnity_temporary_total_reserve_amount               :float
#  indemnity_temporary_total_reserve_prediction           :string
#  industry_code                                          :integer
#  injured_worked_represented                             :string
#  injury_or_litigation_type                              :string
#  last_date_worked                                       :date
#  last_indemnity_period_end_date                         :date
#  last_medical_date_of_service                           :date
#  marital_status                                         :string
#  medical_ambulance_payments                             :float
#  medical_clinic_or_nursing_home_payments                :float
#  medical_court_cost_payments                            :float
#  medical_doctors_payments                               :float
#  medical_drug_and_pharmacy_payments                     :float
#  medical_emergency_room_payments                        :float
#  medical_funeral_payments                               :float
#  medical_hospital_payments                              :float
#  medical_medical_device_payments                        :float
#  medical_misc_payments                                  :float
#  medical_nursing_services_payments                      :float
#  medical_prostheses_device_payments                     :float
#  medical_prostheses_exam_payments                       :float
#  medical_reserve_prediction                             :string
#  medical_travel_payments                                :float
#  medical_x_rays_and_radiology_payments                  :float
#  mmi_date                                               :date
#  physical_therapy                                       :string
#  policy_number                                          :integer
#  prediction_close_status_effective_date                 :date
#  prediction_status                                      :string
#  record_type                                            :integer
#  reduction_amount                                       :float
#  reduction_reason                                       :string
#  representative_number                                  :integer
#  requestor_number                                       :integer
#  return_to_work_date                                    :date
#  salary_continuation                                    :string
#  temporary_partial_payments                             :float
#  temporary_total_payments                               :float
#  total_indemnity_paid_amount                            :float
#  total_indemnity_reserve_amount                         :float
#  total_medical_paid                                     :float
#  total_medical_reserve_amount                           :float
#  total_original_reserve_amount                          :float
#  total_reserve_amount_for_rates                         :float
#  valid_policy_number                                    :string
#  wage_loss_payments                                     :float
#  created_at                                             :datetime         not null
#  updated_at                                             :datetime         not null
#

class WeeklyMiraDetailRecord < ActiveRecord::Base
  scope :filter_by, -> (representative_number) { where(representative_number: representative_number) }

  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

  def age_at_injury
    self.claimant_age_at_injury || (claim_injury_date - claimant_date_of_birth)
  end
end
