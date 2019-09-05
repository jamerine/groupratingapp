# == Schema Information
#
# Table name: mremps
#
#  id         :integer          not null, primary key
#  single_rec :string
#

class Mremp < ActiveRecord::Base

  require 'activerecord-import'
  require 'open-uri'


    def self.import_file(url)
      time1 = Time.new
      puts "Start Time: " + time1.inspect
      # Democ.transaction do
      Resque.enqueue(ImportFile, url, "mremps")

      # end
      time2 = Time.new
      puts "End Time: " + time2.inspect
    end

end
