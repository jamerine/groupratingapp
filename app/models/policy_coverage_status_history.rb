# == Schema Information
#
# Table name: policy_coverage_status_histories
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
#  policy_calculation_id   :integer
#  representative_id       :integer
#
# Indexes
#
#  index_policy_coverage_status_histories_on_policy_calculation_id  (policy_calculation_id)
#  index_policy_coverage_status_histories_on_representative_id      (representative_id)
#
# Foreign Keys
#
#  fk_rails_...  (policy_calculation_id => policy_calculations.id)
#  fk_rails_...  (representative_id => representatives.id)
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
