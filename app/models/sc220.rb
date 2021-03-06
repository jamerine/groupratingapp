# == Schema Information
#
# Table name: sc220s
#
#  id         :integer          not null, primary key
#  single_rec :string
#

class Sc220 < ActiveRecord::Base
  require 'activerecord-import'
  require 'open-uri'
    def self.import_file(url)
      time1 = Time.new
      puts "Start Time: " + time1.inspect
      # Democ.transaction do
        Resque.enqueue(ImportFile, url, "sc220s")

      # end
      time2 = Time.new
      puts "End Time: " + time2.inspect
    end
end
