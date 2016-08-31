  class GroupRatingStep2
    include Sidekiq::Worker

    sidekiq_options queue: :group_rating_step_2

  def perform(step, process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id)

    result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_#{step}(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }')")

    result.clear
    @group_rating = GroupRating.find_by(id: group_rating_id)
      @group_rating.status = "Step #{step} Completed"
    @group_rating.save
  end

end
