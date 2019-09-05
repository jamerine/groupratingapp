# == Schema Information
#
# Table name: payroll_calculations
#
#  id                                                            :integer          not null, primary key
#  representative_number                                         :integer
#  policy_type                                                   :string
#  policy_number                                                 :integer
#  manual_class_type                                             :string
#  manual_number                                                 :integer
#  manual_class_calculation_id                                   :integer
#  reporting_period_start_date                                   :date
#  reporting_period_end_date                                     :date
#  manual_class_payroll                                          :float
#  reporting_type                                                :string
#  number_of_employees                                           :integer
#  policy_transferred                                            :integer
#  transfer_creation_date                                        :date
#  process_payroll_all_transactions_breakdown_by_manual_class_id :integer
#  payroll_origin                                                :string
#  data_source                                                   :string
#  created_at                                                    :datetime         not null
#  updated_at                                                    :datetime         not null
#  manual_class_rate                                             :float
#  manual_class_transferred                                      :integer
#

class PayrollCalculation < ActiveRecord::Base

  belongs_to :manual_class_calculation

  validates :reporting_period_start_date, :presence => true
  validates :reporting_period_end_date, :presence => true
  validates :manual_class_payroll, :presence => true
  validates :payroll_origin, :presence => true
  validates :data_source, :presence => true

  # after_create :calculate
  # after_destroy :calculate

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

  private

  def calculate
    self.manual_class_calculation.policy_calculation.calculate_experience
    self.manual_class_calculation.policy_calculation.calculate_premium
    self.manual_class_calculation.policy_calculation.account.group_rating
  end

end
