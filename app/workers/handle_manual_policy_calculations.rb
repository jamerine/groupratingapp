class HandleManualPolicyCalculations
  require 'sidekiq/api'
  include Sidekiq::Worker

  sidekiq_options queue: :handle_manual_policy_calculations, retry: 1

  def perform(representative_number)
    return unless representative_number.present?
    # Post Task Execution fix to set all Estimates to 0.00. Per client request: September, 2019
    PayrollCalculation.where(reporting_type: 'E', representative_number: representative_number).where('manual_class_payroll > 0.00').each do |payroll_calculation|
      HandleManualPolicyCalculationsProcess.perform_async(payroll_calculation.id)
    end

    # This will get the same records as if I just do it straight to the point as above, which WILL set ALL estimates to 0. Only below difference appears to be if there are ONLY estimates
    # On the PayrollCalculations for a ManualClassCalculation which DOES NOT appear to occur anywhere in the 100K Manual Class Calculations at this time

    # ManualClassCalculation.includes(:payroll_calculations).each do |manual_class_calculation|
    #   payroll_calculations = manual_class_calculation.payroll_calculations.map { |pc| { id: pc.id, reporting_type: pc.reporting_type, manual_class_payroll: pc.manual_class_payroll } }
    #
    #   if payroll_calculations.any? && (%w(A R) & payroll_calculations.map { |pc| pc[:reporting_type] }.uniq).any?
    #     mapped_payroll_calculations = payroll_calculations.map { |pc| pc[:id] if pc[:reporting_type] == 'E' && pc[:manual_class_payroll] > 0.00 }.reject(&:nil?)
    #     mapped_payroll_calculations.each { |mpc| HandleManualPolicyCalculationsProcess.perform_async(mpc) } if mapped_payroll_calculations.any?
    #   end
    # end
  end
end