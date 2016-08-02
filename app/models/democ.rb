class Democ < ActiveRecord::Base
require 'activerecord-import'
require 'open-uri'

  def self.import_file(url)
    time1 = Time.new
    puts "Start Time: " + time1.inspect
    Democ.transaction do
      democs = []
      IO.foreach(open(url)) do |row|
        democs << Democ.new(single_rec: row)
      end
      Democ.import democs
    end
    time2 = Time.new
    puts "End Time: " + time2.inspect
  end

end
