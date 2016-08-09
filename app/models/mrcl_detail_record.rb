class MrclDetailRecord < ActiveRecord::Base
  require 'activerecord-import'

  def self.parse_table
    time1 = Time.new
    puts "Start Time: " + time1.inspect
      result = ActiveRecord::Base.connection.execute("SELECT public.proc_process_flat_mrcl()")
    time2 = Time.new
    puts "End Time: " + time2.inspect
  end
end
