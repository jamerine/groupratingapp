# == Schema Information
#
# Table name: sc220_rec2_employer_manual_level_payrolls
#
#  id                                :integer          not null, primary key
#  representative_number             :integer
#  representative_type               :integer
#  description_ar                    :string
#  record_type                       :integer
#  request_type                      :integer
#  policy_type                       :string
#  policy_number                     :integer
#  business_sequence_number          :integer
#  manual_number                     :integer
#  manual_type                       :string
#  year_to_date_payroll              :float
#  manual_class_rate                 :float
#  year_to_date_premium_billed       :float
#  manual_effective_date             :date
#  n2nd_year_to_date_payroll         :float
#  n2nd_manual_class_rate            :float
#  n2nd_year_to_date_premium_billed  :float
#  n2nd_manual_effective_date        :date
#  n3rd_year_to_date_payroll         :float
#  n3rd_manual_class_rate            :float
#  n3rd_year_to_date_premium_billed  :float
#  n3rd_manual_effective_date        :date
#  n4th_year_to_date_payroll         :float
#  n4th_manual_class_rate            :float
#  n4th_year_to_date_premium_billed  :float
#  n4th_manual_effective_date        :date
#  n5th_year_to_date_payroll         :float
#  n5th_manual_class_rate            :float
#  n5th_year_to_date_premium_billed  :float
#  n5th_manual_effective_date        :date
#  n6th_year_to_date_payroll         :float
#  n6th_manual_class_rate            :float
#  n6th_year_to_date_premium_billed  :float
#  n6th_manual_effective_date        :date
#  n7th_year_to_date_payroll         :float
#  n7th_manual_class_rate            :float
#  n7th_year_to_date_premium_billed  :float
#  n7th_manual_effective_date        :date
#  n8th_year_to_date_payroll         :float
#  n8th_manual_class_rate            :float
#  n8th_year_to_date_premium_billed  :float
#  n8th_manual_effective_date        :date
#  n9th_year_to_date_payroll         :float
#  n9th_manual_class_rate            :float
#  n9th_year_to_date_premium_billed  :float
#  n9th_manual_effective_date        :date
#  n10th_year_to_date_payroll        :float
#  n10th_manual_class_rate           :float
#  n10th_year_to_date_premium_billed :float
#  n10th_manual_effective_date       :date
#  n11th_year_to_date_payroll        :float
#  n11th_manual_class_rate           :float
#  n11th_year_to_date_premium_billed :float
#  n11th_manual_effective_date       :date
#  n12th_year_to_date_payroll        :float
#  n12th_manual_class_rate           :float
#  n12th_year_to_date_premium_billed :float
#  n12th_manual_effective_date       :date
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#

class Sc220Rec2EmployerManualLevelPayroll < ActiveRecord::Base
end
