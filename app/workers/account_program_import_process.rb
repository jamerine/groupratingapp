class AccountProgramImportProcess
  include Sidekiq::Worker

  sidekiq_options queue: :import_file

  def perform(file)

    begin
      
      CSV.foreach(file, headers: true) do |row|
        hash = row.to_hash # exclude the price field
        AccountProgramImport.perform_async(hash)
        puts "Import successful."
      end
    rescue
      puts "There was an error importing the file."
    end
  end
end
