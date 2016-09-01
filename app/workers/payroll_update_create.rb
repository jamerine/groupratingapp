class PayrollUpdateCreate
  include Sidekiq::Worker

  sidekiq_options queue: :payroll_update_create

  def perform(payroll_transaction_id, manual_class_calculation_id)
        @payroll_transaction = ProcessPayrollAllTransactionsBreakdownByManualClass.find(payroll_transaction_id)
        PayrollCalculation.where(
          policy_number: @payroll_transaction.policy_number,
          manual_number: @payroll_transaction.manual_number,
          representative_number: @payroll_transaction.representative_number,
          manual_class_calculation_id: manual_class_calculation_id,
          manual_class_effective_date: @payroll_transaction.manual_class_effective_date,
          manual_class_payroll: @payroll_transaction.manual_class_payroll,
          payroll_origin: @payroll_transaction.payroll_origin,
          data_source: @payroll_transaction.data_source).update_or_create(
            representative_number: @payroll_transaction.representative_number,
            policy_number: @payroll_transaction.policy_number,
            manual_number: @payroll_transaction.manual_number,
            manual_class_calculation_id: manual_class_calculation_id,
            manual_class_effective_date: @payroll_transaction.manual_class_effective_date,
            manual_class_payroll: @payroll_transaction.manual_class_payroll,
            payroll_origin: @payroll_transaction.payroll_origin,
            data_source: @payroll_transaction.data_source
        )
  end
end
