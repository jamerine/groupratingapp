namespace :heroku do
  desc "This task is called by the Heroku scheduler add-on and calls Arm to begin processing"
  task :process_representative => :environment do
    puts "Group Rating Processing for ARM"
    stats = Sidekiq::Stats.new.fetch_stats!
    if stats[:retry_size] > 0 || stats[:workers_size] > 0 || stats[:enqueued] > 0
      redirect_to group_ratings_path, alert: "Please wait for background update to finish."
    else
      @group_rating = GroupRating.find_by(representative_id: 1)
      @new_group_rating = GroupRating.new(experience_period_lower_date: @group_rating.experience_period_lower_date, experience_period_upper_date: @group_rating.experience_period_upper_date, process_representative: @group_rating.process_representative, current_payroll_period_lower_date: @group_rating.current_payroll_period_lower_date, current_payroll_period_upper_date: @group_rating.current_payroll_period_upper_date, representative_id: @group_rating.representative_id)
      @representative = Representative.find(@group_rating.representative_id)
      @group_rating = GroupRating.where(representative_id: @group_rating.representative_id).destroy_all
      @group_rating.status = 'Queuing'
      if @group_rating.save
        @import = Import.new(process_representative: @group_rating.process_representative, representative_id: @group_rating.representative_id, group_rating_id: @group_rating.id, import_status: 'Queuing', parse_status: 'Queuing')
          # Flat files
          if @import.save
            ImportProcess.perform_async(@import.process_representative, @import.id, @representative.abbreviated_name, @group_rating.id)
          end
        end
    end
    puts "done."
  end
end
