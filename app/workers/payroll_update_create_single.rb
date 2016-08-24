class PayrollUpdateCreate

  @queue = :payroll_update_create

  def self.perform(group_rating_id, policy_calculation_id, manual_class_calculation_id)
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Payroll Updating"
    @group_rating.save
    ProcessPayrollAllTransactionsBreakdownByManualClass.find_each do |payroll_transaction|
      @manual_class_calculation = ManualClassCalculation.find_by(policy_number: payroll_transaction.policy_number, manual_number: payroll_transaction.manual_number, representative_number: payroll_transaction.representative_number)
      unless @manual_class_calculation.nil?
        PayrollCalculation.where(
          policy_number: payroll_transaction.policy_number,
          manual_number: payroll_transaction.manual_number,
          representative_number: payroll_transaction.representative_number,
          manual_class_calculation_id: @manual_class_calculation.id,
          manual_class_effective_date: payroll_transaction.manual_class_effective_date,
          manual_class_payroll: payroll_transaction.manual_class_payroll,
          payroll_origin: payroll_transaction.payroll_origin,
          data_source: payroll_transaction.payroll_origin).update_or_create(
            representative_number: payroll_transaction.representative_number,
            policy_number: payroll_transaction.policy_number,
            manual_number: payroll_transaction.manual_number,
            manual_class_calculation_id: @manual_class_calculation.id,
            manual_class_effective_date: payroll_transaction.manual_class_effective_date,
            manual_class_payroll: payroll_transaction.manual_class_payroll,
            payroll_origin: payroll_transaction.payroll_origin,
            data_source: payroll_transaction.data_source
        )
      end
    end
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Payroll Updates Complete"
    @group_rating.save
  end

end
