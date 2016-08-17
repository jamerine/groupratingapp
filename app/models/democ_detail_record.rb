class DemocDetailRecord < ActiveRecord::Base
  require 'activerecord-import'

  def self.parse_table
    time1 = Time.new
    Resque.enqueue(ParseFile, "democ")

    time2 = Time.new
        puts 'Completed Democ Parse in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end
end
