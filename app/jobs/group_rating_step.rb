class GroupRatingStep
  @queue = :group_rating_step

  def self.perform(step, process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date)

    result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_" + step + "(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }')")
    puts result

    result.clear
    GroupRating.

  end

end
