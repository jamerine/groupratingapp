class GroupRatingMarkComplete
  require 'sidekiq/api'
  include Sidekiq::Worker

  sidekiq_options queue: :group_rating_mark_complete

  def perform(group_rating_id, all_process=nil)
    @representatives_count = Representative.all.count
    @group_rating = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Completed"
    @group_rating.save

    if all_process == 1
      if @group_rating.representative_id < @representatives_count
        GroupRating.where(representative_id: (@group_rating.representative_id + 1)).destroy_all
        @new_group_rating = GroupRating.new(experience_period_lower_date: @group_rating.experience_period_lower_date, experience_period_upper_date: @group_rating.experience_period_upper_date, current_payroll_period_lower_date: @group_rating.current_payroll_period_lower_date, current_payroll_period_upper_date: @group_rating.current_payroll_period_upper_date, representative_id: (@group_rating.representative_id + 1) )
        @representative = Representative.find(@new_group_rating.representative_id)
        @new_group_rating.process_representative = @representative.representative_number
        @new_group_rating.status = 'Queuing'
        if @new_group_rating.save
          @import = Import.new(process_representative: @new_group_rating.process_representative, representative_id: @new_group_rating.representative_id, group_rating_id: @new_group_rating.id, import_status: 'Queuing', parse_status: 'Queuing')
            # Flat files
          if @import.save
            ImportProcess.perform_in(2.minutes, @import.process_representative, @import.id, @representative.abbreviated_name, @new_group_rating.id, all_process)
          end
        end
      end
    end
  end
end
