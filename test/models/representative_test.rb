# == Schema Information
#
# Table name: representatives
#
#  id                                :integer          not null, primary key
#  abbreviated_name                  :string
#  bwc_quote_completion_date         :date
#  company_name                      :string
#  current_payroll_period_lower_date :date
#  current_payroll_period_upper_date :date
#  current_payroll_year              :integer
#  email_address                     :string
#  experience_date                   :date
#  experience_period_lower_date      :date
#  experience_period_upper_date      :date
#  fax_number                        :string
#  footer                            :string
#  group_dues                        :string
#  group_fees                        :string
#  internal_quote_completion_date    :date
#  location_address_1                :string
#  location_address_2                :string
#  location_city                     :string
#  location_state                    :string
#  location_zip_code                 :string
#  logo                              :string
#  mailing_address_1                 :string
#  mailing_address_2                 :string
#  mailing_city                      :string
#  mailing_state                     :string
#  mailing_zip_code                  :string
#  phone_number                      :string
#  president                         :string
#  president_first_name              :string
#  president_last_name               :string
#  program_year                      :integer
#  program_year_lower_date           :date
#  program_year_upper_date           :date
#  quote_year                        :integer
#  quote_year_lower_date             :date
#  quote_year_upper_date             :date
#  representative_number             :integer
#  signature                         :string
#  toll_free_number                  :string
#  zip_file                          :string
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#

require 'test_helper'

class RepresentativeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
