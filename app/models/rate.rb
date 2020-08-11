# == Schema Information
#
# Table name: rates
#
#  id         :integer          not null, primary key
#  single_rec :string
#

class Rate < ActiveRecord::Base
  attr_accessor :representative_number, :policy_number, :manual_class_payroll, :manual_number

  scope :by_policy_number, -> (policy_number) { where("cast_to_int(split_part(rates.single_rec, '|',4)) = ?", policy_number) }
  scope :by_manual_class_payroll, -> (payroll) { where("cast_to_numeric(split_part(rates.single_rec, '|',23)) = ?", payroll) }
  scope :by_manual_number, -> (payroll) { where("cast_to_int(split_part(rates.single_rec, '|',12)) = ?", payroll) }

  def representative_number
    self.single_rec.split('|')[0]&.to_i
  end

  def policy_number
    self.single_rec.split('|')[3]&.to_i
  end

  def manual_class_payroll
    self.single_rec.split('|')[22]&.to_i
  end

  def manual_number
    self.single_rec.split('|')[11]&.to_i
  end
end
