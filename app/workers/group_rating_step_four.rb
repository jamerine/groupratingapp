class GroupRatingStepFour
  include Sidekiq::Worker

  sidekiq_options queue: :group_rating_step_four

  def perform(step, process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, current_payroll_period_upper_date, group_rating_id, all_process = nil)

    result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_#{step}00(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }', '#{current_payroll_period_upper_date }')")

    result.clear
    @group_rating        = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Step #{step} Completed"
    @group_rating.save

    GroupRatingStepFive.perform_async("5", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date, current_payroll_period_upper_date, @group_rating.id, all_process)
  end
end
