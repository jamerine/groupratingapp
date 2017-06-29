class PayrollImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file

  def perform(payroll_hash)

    representative = Representative.find_by(representative_number: payroll_hash["representative_number"])
    account = Account.find_by(representative_id: representative.id, policy_number_entered: payroll_hash["policy_number"] )

    if account
      policy_calculation = PolicyCalculation.find_by(account_id: account.id)
      if policy_calculation
        manual_class_calculation = ManualClassCalculation.find_by(policy_calculation_id: policy_calculation.id, manual_number: payroll_hash["manual_number"])

        if manual_class_calculation
          @payroll_calculation = PayrollCalculation.new(representative_number: representative.representative_number, policy_number: policy_calculation.policy_number, manual_class_calculation_id: manual_class_calculation.id, payroll_origin: 'mass_insert', data_source: 'user' )
          @payroll_calculation.assign_attributes(payroll_hash.except("representative_number", "policy_number"))
          @process_payroll = ProcessPayrollAllTransactionsBreakdownByManualClass.create(representative_number: @payroll_calculation.representative_number, policy_number: @payroll_calculation.policy_number, manual_number: @payroll_calculation.manual_number, manual_class_type: @payroll_calculation.manual_class_type, reporting_period_start_date: @payroll_calculation.reporting_period_start_date, reporting_period_end_date: @payroll_calculation.reporting_period_end_date,  manual_class_payroll: @payroll_calculation.manual_class_payroll, payroll_origin: @payroll_calculation.payroll_origin, data_source: @payroll_calculation.data_source)
          @payroll_calculation.assign_attributes(process_payroll_all_transactions_breakdown_by_manual_class_id: @process_payroll.id)
          @payroll_calculation.save!
        end
      end
    end

  end
end
