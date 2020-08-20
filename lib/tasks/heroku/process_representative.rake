require 'sidekiq/api'

namespace :heroku do
  desc "This task is called by the Heroku scheduler add-on and calls Arm to begin processing"
  task :process_representative => :environment do

    puts "Group Rating Processing for ARM"
    stats = Sidekiq::Stats.new.fetch_stats!
    if stats[:workers_size] > 0 || stats[:enqueued] > 0
      puts "Please wait for background update to finish."
    else
      @representative                          = Representative.find(1)
      @group_rating                            = GroupRating.find_by(representative_id: @representative.id)
      @new_group_rating                        = GroupRating.new(experience_period_lower_date: @representative.experience_period_lower_date, experience_period_upper_date: @representative.experience_period_upper_date, current_payroll_period_lower_date: @representative.current_payroll_period_lower_date, current_payroll_period_upper_date: @representative.current_payroll_period_upper_date, current_payroll_year: @representative.current_payroll_year, program_year_lower_date: @representative.program_year_lower_date, program_year_upper_date: @representative.program_year_upper_date, program_year: @representative.program_year, quote_year_lower_date: @representative.quote_year_lower_date, quote_year_upper_date: @representative.quote_year_upper_date, quote_year: @representative.quote_year, representative_id: @representative.id)
      @group_rating                            = GroupRating.where(representative_id: @representative.id).destroy_all
      @new_group_rating.status                 = 'Queuing'
      @new_group_rating.process_representative = @representative.representative_number
      if @new_group_rating.save
        @import = Import.new(process_representative: @representative.representative_number, representative_id: @new_group_rating.representative_id, group_rating_id: @new_group_rating.id, import_status: 'Queuing', parse_status: 'Queuing')
        # Flat files
        if @import.save
          ImportProcess.perform_async(@import.process_representative, @import.id, @representative.abbreviated_name, @new_group_rating.id, false, 1)
          AllRepresentativesProcess.perform_in(3.hours)
        end
      end
    end
    puts "done."
  end
end