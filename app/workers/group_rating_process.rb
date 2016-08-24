class GroupRatingProcess
  @queue = :group_rating_process

  def self.perform(process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id)

    Resque.enqueue(GroupRatingStep, "1", process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id )
    Resque.enqueue(GroupRatingStep, "2", process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id )
    Resque.enqueue(GroupRatingStep, "3",process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id )
    Resque.enqueue(GroupRatingStep, "4", process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id)
    Resque.enqueue(GroupRatingStep, "5", process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id )
    Resque.enqueue(GroupRatingStep, "6", process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id )
    Resque.enqueue(GroupRatingStep, "7", process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id )
    Resque.enqueue(GroupRatingStep, "8", process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id )

    Resque.enqueue(PolicyUpdateCreate, group_rating_id)


  end

end
