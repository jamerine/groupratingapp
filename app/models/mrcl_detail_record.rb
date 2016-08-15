class MrclDetailRecord < ActiveRecord::Base
  require 'activerecord-import'

  def self.parse_table
    time1 = Time.new
      result = ActiveRecord::Base.connection.execute("SELECT public.proc_process_flat_mrcls()")
      result.clear
    time2 = Time.new
    puts 'Completed Mrcl Parse in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end
end
