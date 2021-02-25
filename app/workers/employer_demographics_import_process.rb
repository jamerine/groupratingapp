class EmployerDemographicsImportProcess
  include Sidekiq::Worker

  sidekiq_options queue: :employer_demographics_import_process, retry: 2

  def perform(headers, file_line, representative_id)
    split_line = file_line.split("\t")

    EmployerDemographicsImport.perform_async(Hash[headers.map.with_index { |header, index| [header, split_line[index]] }], representative_id)
  end
end
