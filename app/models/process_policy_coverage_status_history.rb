# == Schema Information
#
# Table name: process_policy_coverage_status_histories
#
#  id                      :integer          not null, primary key
#  coverage_effective_date :date
#  coverage_end_date       :date
#  coverage_status         :string
#  data_source             :string
#  lapse_days              :integer
#  policy_number           :integer
#  policy_type             :string
#  representative_number   :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_process_policy_coverage_status_histories_on_policy_number  (policy_number)
#

class ProcessPolicyCoverageStatusHistory < ActiveRecord::Base
end
