class ManualClassUpdateCreateProcess
    include Sidekiq::Worker

    sidekiq_options queue: :manual_class_update_create_process

  def perform(group_rating_id, representative_id)
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Manual Classes Updating"
    @group_rating.save
    FinalManualClassFourYearPayrollAndExpLoss.order("policy_number asc").find_each do |man_class_exp|
        man_class_proj = FinalManualClassGroupRatingAndPremiumProjection.find_by(policy_number: man_class_exp.policy_number, manual_number: man_class_exp.manual_number, representative_number: man_class_exp.representative_number)
          policy_calculation_id = PolicyCalculation.find_by(policy_number: man_class_exp.policy_number, representative_number: man_class_exp.representative_number).id
          unless policy_calculation_id.nil? || man_class_proj.nil?
            ManualClassUpdateCreate.perform_async(
            man_class_proj.representative_number,
            man_class_proj.policy_number,
            policy_calculation_id,
            man_class_exp.manual_number,
            man_class_exp.manual_class_four_year_period_payroll,
            man_class_exp.manual_class_expected_loss_rate,
            man_class_exp.manual_class_base_rate,
            man_class_exp.manual_class_expected_losses,
            man_class_exp.manual_class_limited_loss_rate,
            man_class_exp.manual_class_limited_losses,
            man_class_proj.manual_class_industry_group,
            man_class_proj.manual_class_industry_group_premium_total,
            man_class_proj.manual_class_current_estimated_payroll,
            man_class_proj.manual_class_industry_group_premium_percentage,
            man_class_proj.manual_class_modification_rate,
            man_class_proj.manual_class_individual_total_rate,
            man_class_proj.manual_class_group_total_rate,
            man_class_proj.manual_class_standard_premium,
            man_class_proj.manual_class_estimated_group_premium,
            man_class_proj.manual_class_estimated_individual_premium,
            man_class_proj.data_source,
            representative_id)
          end
          if man_class_proj.nil?
            ManualClassUpdateCreate.perform_async(
            man_class_exp.representative_number,
            man_class_exp.policy_number,
            policy_calculation_id,
            man_class_exp.manual_number,
            man_class_exp.manual_class_four_year_period_payroll,
            man_class_exp.manual_class_expected_loss_rate,
            man_class_exp.manual_class_base_rate,
            man_class_exp.manual_class_expected_losses,
            man_class_exp.manual_class_limited_loss_rate,
            man_class_exp.manual_class_limited_losses,
            man_class_exp.manual_class_industry_group,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            man_class_exp.data_source,
            representative_id)
          end
        end
      PayrollUpdateCreateProcess.perform_in(10.seconds, group_rating_id)
  end
end
