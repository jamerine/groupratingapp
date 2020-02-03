class HandleManualPolicyCalculationsProcess
  require 'sidekiq/api'
  include Sidekiq::Worker

  sidekiq_options queue: :handle_manual_policy_calculations_process, retry: 3

  def perform(calculation_id)
    return unless calculation_id.present?

    PayrollCalculation.find_by(id: calculation_id)&.update_attribute(:manual_class_payroll, 0.00)
  end
end