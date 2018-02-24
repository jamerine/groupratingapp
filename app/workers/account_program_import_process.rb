require 'open-uri'
require 'csv'

class AccountProgramImportProcess
  include Sidekiq::Worker

  sidekiq_options queue: :import_file, retry: 1

  def perform(file)
    csv_file = open(file,'rb:UTF-8')

    begin

      rows = CSV.parse(csv_file, { headers: true })

      rows.each do |row|
        hash = row.to_hash # exclude the price field
        AccountProgramImport.perform_async(hash)
        puts "Import successful."
      end
    rescue
      puts "There was an error importing the file."
    end
  end
end
