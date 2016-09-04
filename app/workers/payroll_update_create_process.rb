class PayrollUpdateCreateProcess
  include Sidekiq::Worker

  sidekiq_options queue: :payroll_update_create_process

  def perform(group_rating_id)
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Payroll Updating"
    @group_rating.save
    ProcessPayrollAllTransactionsBreakdownByManualClass.where("manual_class_effective_date >= :manual_class_effective_date and representative_number = :representative_number",  manual_class_effective_date: @group_rating.experience_period_lower_date, representative_number: @group_rating.process_representative).find_each do |payroll_transaction|
      @manual_class_calculation = ManualClassCalculation.find_by(policy_number: payroll_transaction.policy_number, manual_number: payroll_transaction.manual_number, representative_number: payroll_transaction.representative_number)
      unless @manual_class_calculation.nil? || payroll_transaction.id.nil? || payroll_transaction.manual_number == 0
        PayrollUpdateCreate.perform_async(
        payroll_transaction.representative_number,
        payroll_transaction.policy_number,
        payroll_transaction.manual_number,
        @manual_class_calculation.id,
        payroll_transaction.manual_class_effective_date,
        payroll_transaction.manual_class_payroll,
        payroll_transaction.payroll_origin,
        payroll_transaction.data_source
        )
      end
    end
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Payroll Completed"
    @group_rating.save
    ClaimUpdateCreateProcess.perform_async(group_rating_id)
  end
end
