# == Schema Information
#
# Table name: rate_detail_records
#
#  id                           :integer          not null, primary key
#  create_date                  :date
#  representative_number        :integer
#  representative_name          :string
#  policy_number                :integer
#  business_sequence_number     :integer
#  policy_name                  :string
#  tax_id                       :integer
#  policy_status_effective_date :date
#  policy_status                :string
#  reporting_period_start_date  :date
#  reporting_period_end_date    :date
#  manual_class                 :integer
#  manual_class_type            :string
#  manual_class_description     :string
#  bwc_customer_id              :integer
#  individual_first_name        :string
#  individual_middle_name       :string
#  individual_last_name         :string
#  individual_tax_id            :integer
#  manual_class_rate            :float
#  reporting_type               :string
#  number_of_employees          :integer
#  payroll                      :float
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

class RateDetailRecord < ActiveRecord::Base
  scope :filter_by, -> (representative_number) { where(representative_number: representative_number) }
end
