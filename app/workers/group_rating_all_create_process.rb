class GroupRatingAllCreateProcess
  require 'progress_bar/core_ext/enumerable_with_progress'
  include Sidekiq::Worker

  sidekiq_options queue: :group_rating_all_create_process, retry: 1

  def perform(group_rating_id, all_process = nil)
    @group_rating        = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Creating/Updating Claims and Payroll"
    @group_rating.save

    all_policy_numbers = (FinalEmployerDemographicsInformation.all.pluck(:policy_number) + ProcessPayrollAllTransactionsBreakdownByManualClass.pluck(:policy_number).uniq).uniq

    all_policy_numbers.each_with_progress do |policy|
      GroupRatingAllCreate.perform_async(@group_rating.id, @group_rating.experience_period_lower_date, @group_rating.process_representative, @group_rating.representative_id, policy)
    end

    FilterClaimsProcess.perform_in(10.minutes, @group_rating.id, all_process)
  end
end
