class HandleManualPolicyCalculationsProcess
  require 'sidekiq/api'
  include Sidekiq::Worker

  sidekiq_options queue: :handle_manual_policy_calculations_process, retry: 1

  def perform(calculation_id)
    return if calculation_id.nil?

    PayrollCalculation.find(calculation_id)&.update_attribute(:manual_class_payroll, 0.00)
  end
end