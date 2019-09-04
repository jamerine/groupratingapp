class HandleManualPolicyCalculations
  require 'sidekiq/api'
  include Sidekiq::Worker

  sidekiq_options queue: :handle_manual_policy_calculations, retry: 1

  def perform
    ManualClassCalculation.pluck(:id).each do |manual_class_calculation_id, index|
      payroll_calculations = PayrollCalculation.select(:id, :manual_class_payroll, :reporting_type, :manual_class_calculation_id).where(manual_class_calculation_id: manual_class_calculation_id)

      unless (%w(A R) & payroll_calculations.map(&:reporting_type).uniq).empty?
        payroll_calculations.each do |payroll_calculation|
          if payroll_calculation.reporting_type == 'E' && payroll_calculation.manual_class_payroll > 0.00
            payroll_calculation.update_attribute(:manual_class_payroll, 0.00)
          end
        end
      end
    end
  end
end