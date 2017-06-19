require 'open-uri'

class QuoteImportProcess
  include Sidekiq::Worker

  sidekiq_options queue: :import_file, retry: 1

  def perform(file)
    csv_file = open(file,'rb:UTF-8')

    begin
      CSV.foreach(csv_file, headers: true) do |row|
        hash = row.to_hash # exclude the price field
        QuoteImport.perform_async(hash)
      end
      puts "Import successful."
    rescue
      puts "There was an error importing the file."
    end


  end
end
