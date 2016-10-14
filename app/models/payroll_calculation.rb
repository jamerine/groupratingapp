class PayrollCalculation < ActiveRecord::Base

  belongs_to :manual_class_calculation

  validates :manual_class_effective_date, :presence => true
  validates :manual_class_payroll, :presence => true
  validates :payroll_origin, :presence => true
  validates :data_source, :presence => true


  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

  # def self.assign_or_new(attributes)
  #   obj = first || new
  #   obj.assign_attributes(attributes)
  #   obj
  # end


end
