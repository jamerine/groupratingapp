class PcombDetailRecord < ActiveRecord::Base
  require 'activerecord-import'

  def self.parse_table
    time1 = Time.new
      Resque.enqueue(ParseFile, "pcomb")
    time2 = Time.new
    puts 'Completed Pcomb Parse in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end
end
