# == Schema Information
#
# Table name: policy_coverage_status_histories
#
#  id                      :integer          not null, primary key
#  policy_calculation_id   :integer
#  representative_id       :integer
#  representative_number   :integer
#  policy_type             :string
#  policy_number           :integer
#  coverage_effective_date :date
#  coverage_end_date       :date
#  coverage_status         :string
#  lapse_days              :integer
#  data_source             :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class PolicyCoverageStatusHistory < ActiveRecord::Base
  belongs_to :policy_calculation
  belongs_to :representative

  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end

end
