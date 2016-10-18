  class GroupRatingStepEight
    include Sidekiq::Worker

    sidekiq_options queue: :group_rating_step_eight

  def perform(step, process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id)

    result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_#{step}(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }')")

    result.clear
    @group_rating = GroupRating.find_by(id: group_rating_id)
      @group_rating.status = "Step #{step} Completed"
    @group_rating.save

    predecessor_policies = ExceptionTablePolicyCombinedRequestPayrollInfo.all

    PredecessorAccountUpdateCreateProcess.perform_async(@group_rating.id)
    GroupRatingAllCreateProcess.perform_async(@group_rating.id)
  end

end
