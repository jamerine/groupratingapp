class ImportFile
  @queue = :imports

  def self.perform(url, table_name)
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
      time2 = Time.new
      puts "End Time: " + time2.inspect
  end
end
