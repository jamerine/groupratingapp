class ImportClicdFilesProcess
  require 'progress_bar/core_ext/enumerable_with_progress'
  include Sidekiq::Worker
  include ImportHelper
  sidekiq_options queue: :import_clicd_files_process, retry: 1

  def perform(representative_number, representative_abbreviated_name, file_url = nil)
    Clicd.by_representative(representative_number).delete_all
    import_single_file(file_url || "https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/CLICDFILE", 'clicds')

    Clicd.by_representative(representative_number).by_record_type.each_with_progress do |clicd|
      ImportClicdData.perform_async(clicd.attributes)
    end
  end
end
