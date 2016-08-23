class ImportFile
  @queue = :import_file

  def self.perform(url, table_name, import_id)
    time1 = Time.new
    puts "Start Time: " + time1.inspect
      conn = ActiveRecord::Base.connection
      rc = conn.raw_connection
      rc.exec("COPY " + table_name + " (single_rec) FROM STDIN WITH DELIMITER AS '|'")

      file = open(url)
      while !file.eof?
        # Add row to copy data
        rc.put_copy_data(file.readline)

      end

      # We are done adding copy data
      rc.put_copy_end

      # Display any error messages
      while res = rc.get_result
        if e_message = res.error_message
          p e_message
        end
      end
      @import = Import.find_by(id: import_id)
      if table_name == "sc230s"
        @import.import_status = "Completed"
        @import.sc230s_count = Sc230.count
      elsif table_name == "sc220s"
        @import.import_status = "#{table_name.capitalize} Import Completed"
        @import.sc220s_count = Sc220.count
      elsif table_name == "democs"
        @import.import_status = "#{table_name.capitalize} Import Completed"
        @import.democs_count = Democ.count
      elsif table_name == "mrcls"
        @import.import_status = "#{table_name.capitalize} Import Completed"
        @import.mrcls_count = Mrcl.count
      elsif table_name == "mremps"
        @import.import_status = "#{table_name.capitalize} Import Completed"
        @import.mremps_count = Mremp.count
      elsif table_name == "pcombs"
        @import.import_status = "#{table_name.capitalize} Import Completed"
        @import.pcombs_count = Pcomb.count
      elsif table_name == "phmgns"
        @import.import_status = "#{table_name.capitalize} Import Completed"
        @import.phmgns_count = Phmgn.count
      end
      @import.save
      time2 = Time.new
      puts "End Time: " + time2.inspect
  end
end
