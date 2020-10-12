class ImportPdemoProcess
  include Sidekiq::Worker
  include ImportHelper
  sidekiq_options queue: :import_pdemo_process, retry: 3

  def perform(representative_number, representative_abbreviated_name, file_url = nil)
    Pdemo.delete_all
    PdemoDetailRecord.filter_by(representative_number).delete_all

    import_single_file(file_url || "https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/PDEMOFILE", 'pdemos')
  end
end
