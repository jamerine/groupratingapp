class EmployerDemographicsImportProcess
  include Sidekiq::Worker

  sidekiq_options queue: :employer_demographics_import_process, retry: 1

  def perform(file_path)
    require 'open-uri'

    file    = open(file_path, encoding: 'utf-16')
    headers = file&.first&.split("\t").map(&:parameterize).map(&:underscore).map(&:to_sym)

    until file&.eof?
      split_line = file.readline.split("\t")

      EmployerDemographicsImport.perform_async(Hash[headers.map.with_index { |header, index| [header, split_line[index]] }])
    end
  end
end
