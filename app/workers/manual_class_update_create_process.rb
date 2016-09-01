class ManualClassUpdateCreateProcess
    include Sidekiq::Worker

    sidekiq_options queue: :manual_class_update_create_process

  def perform(group_rating_id)
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Manual Classes Updating"
    @group_rating.save
    FinalManualClassGroupRatingAndPremiumProjection.order("policy_number asc").find_each do |man_class_proj|
        @man_class_exp = FinalManualClassFourYearPayrollAndExpLoss.find_by(policy_number: man_class_proj.policy_number, manual_number: man_class_proj.manual_number, representative_number: man_class_proj.representative_number)
        unless @man_class_exp.nil?
          @policy_calculation = PolicyCalculation.find_by(policy_number: man_class_proj.policy_number, representative_number: man_class_proj.representative_number)
          unless @policy_calculation.nil? || @man_class_exp.nil?
            ManualClassUpdateCreate.perform_async(man_class_proj.id, @man_class_exp.id, @policy_calculation.id )
          end
        end
    end
      PayrollUpdateCreateProcess.perform_in(10.seconds, group_rating_id)
      ClaimUpdateCreateProcess.perform_in(10.seconds, group_rating_id)
  end

end
