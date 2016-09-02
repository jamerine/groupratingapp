class ImportProcess
  include Sidekiq::Worker

      sidekiq_options queue: :import_process
    def perform(process_representative_id, import_id, representative_abbreviated_name)

      ImportFile.perform_async("https://s3.amazonaws.com/grouprating/#{representative_abbreviated_name}/DEMOCFILE", "democs", import_id)
      ImportFile.perform_async("https://s3.amazonaws.com/grouprating/#{representative_abbreviated_name}/MRCLSFILE", "mrcls", import_id)
      ImportFile.perform_async("https://s3.amazonaws.com/grouprating/#{representative_abbreviated_name}/MREMPFILE", "mremps", import_id)
      ImportFile.perform_async("https://s3.amazonaws.com/grouprating/#{representative_abbreviated_name}/PCOMBFILE", "pcombs", import_id)
      ImportFile.perform_async("https://s3.amazonaws.com/grouprating/#{representative_abbreviated_name}/PHMGNFILE", "phmgns", import_id)
      ImportFile.perform_async("https://s3.amazonaws.com/grouprating/#{representative_abbreviated_name}/SC220FILE", "sc220s", import_id)
      ImportFile.perform_async("https://s3.amazonaws.com/grouprating/#{representative_abbreviated_name}/SC230FILE", "sc230s", import_id)

    end
end
