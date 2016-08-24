class ManualClassUpdateCreateSingle
  @queue = :manual_class_update_single_create

  def self.perform(group_rating_id, policy_calculation_id)
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Manual Classes Updating"
    @group_rating.save
    @policy_calculation = PolicyCalculation.find(id: policy_calculation_id )
    FinalManualClassGroupRatingAndPremiumProjection.find_each(policy_number: @policy_calculation.policy_number) do |man_class_proj|
        man_class_exp = FinalManualClassFourYearPayrollAndExpLoss.find_by(policy_number: manual_class_proj.policy_number, manual_number: man_class_proj.manual_number, representative_number: man_class_proj.representative_number)
        unless @policy_calculation.nil?
          @manual_class_calculation = ManualClassCalculation.where(policy_number: man_class_proj.policy_number, manual_number: man_class_proj.manual_number, representative_number: man_class_proj.representative_number).update_or_create(
            representative_number: man_class_exp.representative_number,
            policy_number: man_class_exp.policy_number,
            policy_calculation_id: @policy_calculation.id,
            manual_number: man_class_exp.manual_number,
            manual_class_four_year_period_payroll: man_class_exp.manual_class_four_year_period_payroll,
            manual_class_expected_loss_rate: man_class_exp.manual_class_expected_loss_rate,
            manual_class_base_rate: man_class_exp.manual_class_base_rate,
            manual_class_expected_losses: man_class_exp.manual_class_expected_losses,
            manual_class_limited_loss_rate: man_class_exp.manual_class_limited_loss_rate,
            manual_class_limited_losses: man_class_exp.manual_class_limited_losses,
            manual_class_industry_group: man_class_proj.manual_class_industry_group,
            manual_class_industry_group_premium_total: man_class_proj.manual_class_industry_group_premium_total,
            manual_class_current_estimated_payroll: man_class_proj.manual_class_current_estimated_payroll,
            manual_class_industry_group_premium_percentage: man_class_proj.manual_class_industry_group_premium_percentage,
            manual_class_modification_rate: man_class_proj.manual_class_modification_rate,
            manual_class_individual_total_rate: man_class_proj.manual_class_individual_total_rate,
            manual_class_group_total_rate: man_class_proj.manual_class_group_total_rate,
            manual_class_standard_premium: man_class_proj.manual_class_standard_premium,
            manual_class_estimated_group_premium: man_class_proj.manual_class_estimated_group_premium,
            manual_class_estimated_individual_premium: man_class_proj.manual_class_estimated_individual_premium,
            data_source: man_class_proj.data_source
          )
        end
    end
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Completed"
    @group_rating.save

  end

end
