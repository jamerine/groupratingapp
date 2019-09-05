# == Schema Information
#
# Table name: representatives
#
#  id                                :integer          not null, primary key
#  representative_number             :integer
#  company_name                      :string
#  abbreviated_name                  :string
#  group_fees                        :string
#  group_dues                        :string
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  logo                              :string
#  zip_file                          :string
#  experience_period_lower_date      :date
#  experience_period_upper_date      :date
#  current_payroll_period_lower_date :date
#  current_payroll_period_upper_date :date
#  current_payroll_year              :integer
#  program_year_lower_date           :date
#  program_year_upper_date           :date
#  program_year                      :integer
#  quote_year_lower_date             :date
#  quote_year_upper_date             :date
#  quote_year                        :integer
#  location_address_1                :string
#  location_address_2                :string
#  location_city                     :string
#  location_state                    :string
#  location_zip_code                 :string
#  mailing_address_1                 :string
#  mailing_address_2                 :string
#  mailing_city                      :string
#  mailing_state                     :string
#  mailing_zip_code                  :string
#  phone_number                      :string
#  toll_free_number                  :string
#  fax_number                        :string
#  email_address                     :string
#  president_first_name              :string
#  president_last_name               :string
#

require 'test_helper'

class RepresentativeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
