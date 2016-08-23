class PolicyCalculation < ActiveRecord::Base

  has_many :manual_class_calculations, dependent: :destroy

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end


end
