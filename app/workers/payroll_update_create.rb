class PayrollUpdateCreate
  include Sidekiq::Worker

  sidekiq_options queue: :payroll_update_create

  def perform(
    representative_number,
    policy_type,
    policy_number,
    manual_type,
    manual_number,
    manual_class_calculation_id,
    manual_class_effective_date,
    manual_class_payroll,
    payroll_origin,
    data_source)
    PayrollCalculation.where(
    representative_number: representative_number,
      policy_type: policy_type,
      policy_number: policy_number,
      manual_type: manual_type,
      manual_number: manual_number,
      manual_class_calculation_id: manual_class_calculation_id,
      manual_class_effective_date: manual_class_effective_date,
      payroll_origin: payroll_origin,
      data_source: data_source).update_or_create(
        representative_number: representative_number,
        policy_type: policy_number,
        policy_number: policy_number,
        manual_type: manual_number,
        manual_number: manual_number,
        manual_class_calculation_id: manual_class_calculation_id,
        manual_class_effective_date: manual_class_effective_date,
        manual_class_payroll: manual_class_payroll,
        payroll_origin: payroll_origin,
        data_source: data_source)
  end
end
