class GroupRatingMarkComplete
  require 'sidekiq/api'
  include Sidekiq::Worker

  sidekiq_options queue: :group_rating_mark_complete, retry: 3

  def perform(group_rating_id, all_process = nil)
    @representatives_count = Representative.last&.id
    @group_rating          = GroupRating.find_by(id: group_rating_id)
    @group_rating.status   = "Completed"
    @group_rating.save

    if all_process == 1
      if @group_rating.representative_id <= @representatives_count
        i = @group_rating.representative_id
        while i <= @representatives_count
          i               += 1
          @representative = Representative.find_by(id: i)
          break unless @representative.nil?
        end
        GroupRating.where(representative_id: (@representative&.id)).destroy_all
        @new_group_rating                        = GroupRating.new(experience_period_lower_date: @representative.experience_period_lower_date, experience_period_upper_date: @representative.experience_period_upper_date, current_payroll_period_lower_date: @representative.current_payroll_period_lower_date, current_payroll_period_upper_date: @representative.current_payroll_period_upper_date, current_payroll_year: @representative.current_payroll_year, program_year_lower_date: @representative.program_year_lower_date, program_year_upper_date: @representative.program_year_upper_date, program_year: @representative.program_year, quote_year_lower_date: @representative.quote_year_lower_date, quote_year_upper_date: @representative.quote_year_upper_date, quote_year: @representative.quote_year, representative_id: @representative.id)
        @new_group_rating.process_representative = @representative.representative_number
        @new_group_rating.status                 = 'Queuing'
        if @new_group_rating.save
          @import = Import.new(process_representative: @new_group_rating.process_representative, representative_id: @new_group_rating.representative_id, group_rating_id: @new_group_rating.id, import_status: 'Queuing', parse_status: 'Queuing')
          # Flat files
          if @import.save
            ImportProcess.perform_in(2.minutes, @import.process_representative, @import.id, @representative.abbreviated_name, @new_group_rating.id, false, all_process)
          end
        end
      else
        # No other files to process, finish up with the Manual Policy Updates (September 2019)
        HandleManualPolicyCalculations.perform_async
      end
    end
  end
end
