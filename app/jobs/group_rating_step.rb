class GroupRatingStep
  @queue = :group_rating_step

  def self.perform(step, process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id)

    result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_#{step}(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }')")

    result.clear
    @group_rating = GroupRating.find_by(id: group_rating_id)
    if step == '8'
      @group_rating.status = "Completed"
    else
      @group_rating.status = "Step #{step} completed"
    end
    @group_rating.save
  end

end
