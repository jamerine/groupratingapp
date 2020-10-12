class ImportMiraFilesProcess
  require 'progress_bar/core_ext/enumerable_with_progress'
  include Sidekiq::Worker
  include ImportHelper
  sidekiq_options queue: :import_mira_files_process, retry: 3

  def perform(representative_number, representative_abbreviated_name, weekly = false, file_url = nil)
    if weekly
      WeeklyMira.by_representative(representative_number).delete_all
      import_single_file(file_url || "https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/MIRA2FILW", 'weekly_miras')

      WeeklyMira.by_representative(representative_number).by_record_type.each_with_progress do |mira|
        ImportWeeklyMiraData.perform_async(mira.attributes)
      end
    else
      Mira.by_representative(representative_number).delete_all
      import_single_file(file_url || "https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/MIRA2FILE", 'miras')

      Mira.by_representative(representative_number).by_record_type.each_with_progress do |mira|
        ImportMiraData.perform_async(mira.attributes)
      end
    end
  end
end
