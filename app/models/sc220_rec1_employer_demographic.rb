class Sc220Rec1EmployerDemographic < ActiveRecord::Base
  require 'activerecord-import'

  def self.parse_table
    time1 = Time.new
      Resque.enqueue(ParseFile, "sc220")
    time2 = Time.new
    puts 'Completed SC220 Parse in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end
end
