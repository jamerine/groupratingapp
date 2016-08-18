class GroupRatingStep
  @queue = :group_rating

  def self.perform(process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date)

    Resque.enqueue(GroupRatingStep, "1", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date )
    Resque.enqueue(GroupRatingStep, "2", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date )
    Resque.enqueue(GroupRatingStep, "3",@group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date )
    Resque.enqueue(GroupRatingStep, "4", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date )
    Resque.enqueue(GroupRatingStep, "5", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date )
    Resque.enqueue(GroupRatingStep, "6", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date )
    Resque.enqueue(GroupRatingStep, "7", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date )
    Resque.enqueue(GroupRatingStep, "8", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date )

  end

end
