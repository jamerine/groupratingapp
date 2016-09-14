class ManualClassUpdateCreate
    include Sidekiq::Worker

    sidekiq_options queue: :manual_class_update_create

  def perform(
    representative_number,
    policy_number,
    policy_calculation_id,
    manual_number,
    manual_class_four_year_period_payroll,
    manual_class_expected_loss_rate,
    manual_class_base_rate,
    manual_class_expected_losses,
    manual_class_limited_loss_rate,
    manual_class_limited_losses,
    manual_class_industry_group,
    manual_class_industry_group_premium_total,
    manual_class_current_estimated_payroll,
    manual_class_industry_group_premium_percentage,
    manual_class_modification_rate,
    manual_class_individual_total_rate,
    manual_class_group_total_rate,
    manual_class_standard_premium,
    manual_class_estimated_group_premium,
    manual_class_estimated_individual_premium,
    data_source,
    representative_id
    )
      ManualClassCalculation.where(policy_number: policy_number, manual_number: manual_number, representative_number: representative_number).update_or_create(
        representative_number: representative_number,
        policy_number: policy_number,
        policy_calculation_id: policy_calculation_id,
        manual_number: manual_number,
        manual_class_four_year_period_payroll: manual_class_four_year_period_payroll,
        manual_class_expected_loss_rate: manual_class_expected_loss_rate,
        manual_class_base_rate: manual_class_base_rate,
        manual_class_expected_losses: manual_class_expected_losses,
        manual_class_limited_loss_rate: manual_class_limited_loss_rate,
        manual_class_limited_losses: manual_class_limited_losses,
        manual_class_industry_group: manual_class_industry_group,
        manual_class_industry_group_premium_total: manual_class_industry_group_premium_total,
        manual_class_current_estimated_payroll: manual_class_current_estimated_payroll,
        manual_class_industry_group_premium_percentage: manual_class_industry_group_premium_percentage,
        manual_class_modification_rate: manual_class_modification_rate,
        manual_class_individual_total_rate: manual_class_individual_total_rate,
        manual_class_group_total_rate: manual_class_group_total_rate,
        manual_class_standard_premium: manual_class_standard_premium,
        manual_class_estimated_group_premium: manual_class_estimated_group_premium,
        manual_class_estimated_individual_premium: manual_class_estimated_individual_premium,
        data_source: data_source
      )
    end

end
