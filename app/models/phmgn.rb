# == Schema Information
#
# Table name: phmgns
#
#  id         :integer          not null, primary key
#  single_rec :string
#

class Phmgn < ActiveRecord::Base

  require 'activerecord-import'
  require 'open-uri'


    def self.import_file(url)
      time1 = Time.new
      puts "Start Time: " + time1.inspect
      # Democ.transaction do
        Resque.enqueue(ImportFile, url, "phmgns")

      # end
      time2 = Time.new
      puts "End Time: " + time2.inspect
    end

end
