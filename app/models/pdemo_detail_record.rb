# == Schema Information
#
# Table name: pdemo_detail_records
#
#  id                                            :integer          not null, primary key
#  representative_number                         :integer
#  record_type                                   :integer
#  requestor_number                              :integer
#  policy_number                                 :integer
#  business_sequence_number                      :integer
#  valid_policy_number                           :string
#  current_coverage_status                       :string
#  coverage_status_effective_date                :date
#  federal_identification_number                 :integer
#  business_name                                 :string
#  trading_as_name                               :string
#  valid_mailing_address                         :string
#  mailing_address_line_1                        :string
#  mailing_address_line_2                        :string
#  mailing_city                                  :string
#  mailing_state                                 :string
#  mailing_zip_code                              :integer
#  mailing_zip_code_plus_4                       :integer
#  mailing_country_code                          :integer
#  mailing_county                                :integer
#  valid_location_address                        :string
#  location_address_line_1                       :string
#  location_address_line_2                       :string
#  location_city                                 :string
#  location_state                                :string
#  location_zip_code                             :integer
#  location_zip_code_plus_4                      :integer
#  location_country_code                         :integer
#  location_county                               :integer
#  currently_assigned_clm_representative_number  :integer
#  currently_assigned_risk_representative_number :integer
#  currently_assigned_erc_representative_number  :integer
#  currently_assigned_grc_representative_number  :integer
#  immediate_successor_policy_number             :integer
#  immediate_successor_business_sequence_number  :integer
#  ultimate_successor_policy_number              :integer
#  ultimate_successor_business_sequence_number   :integer
#  employer_type                                 :string
#  coverage_type                                 :string
#  created_at                                    :datetime         not null
#  updated_at                                    :datetime         not null
#

class PdemoDetailRecord < ActiveRecord::Base

end
