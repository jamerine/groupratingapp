# == Schema Information
#
# Table name: group_ratings
#
#  id                                :integer          not null, primary key
#  current_payroll_period_lower_date :date
#  current_payroll_period_upper_date :date
#  current_payroll_year              :integer
#  experience_period_lower_date      :date
#  experience_period_upper_date      :date
#  process_representative            :integer
#  program_year                      :integer
#  program_year_lower_date           :date
#  program_year_upper_date           :date
#  quote_year                        :integer
#  quote_year_lower_date             :date
#  quote_year_upper_date             :date
#  status                            :text
#  total_accounts_updated            :integer
#  total_claims_updated              :integer
#  total_manual_classes_updated      :integer
#  total_payrolls_updated            :integer
#  total_policies_updated            :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  representative_id                 :integer
#
# Indexes
#
#  index_group_ratings_on_representative_id  (representative_id)
#
# Foreign Keys
#
#  fk_rails_...  (representative_id => representatives.id)
#

require 'test_helper'

class GroupRatingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
