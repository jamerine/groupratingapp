require 'open-uri'

class AccountImportProcess
  include Sidekiq::Worker

  sidekiq_options queue: :import_file

  def perform(file)
    csv_file = open(file,'rb:UTF-8')

    begin
      CSV.foreach(csv_file, headers: true) do |row|
        hash = row.to_hash # exclude the price field
        AccountImport.perform_async(hash)
      end
      puts "Import successful."
    rescue
      puts "There was an error importing the file."
    end


  end
end
