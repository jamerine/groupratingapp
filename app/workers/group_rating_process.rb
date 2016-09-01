class GroupRatingProcess
  include Sidekiq::Worker
  sidekiq_options queue: :group_rating_process

  def perform(process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id)



  end

end
