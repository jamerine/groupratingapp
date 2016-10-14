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
