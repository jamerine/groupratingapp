class Sc230 < ActiveRecord::Base

  require 'activerecord-import'
  require 'open-uri'

      
    def self.import_file(url)
      time1 = Time.new
      puts "Start Time: " + time1.inspect
      # Democ.transaction do
        Resque.enqueue(ImportFile, url, "sc230s")
      # end
      time2 = Time.new
      puts "End Time: " + time2.inspect
    end

end
