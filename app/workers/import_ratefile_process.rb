class ImportRatefileProcess
  include Sidekiq::Worker
  sidekiq_options queue: :import_ratefile_process, retry: 3

  def perform(representative_number, representative_abbreviated_name, file_url = nil)
    Rate.delete_all
    RateDetailRecord.filter_by(representative_number).delete_all
    file_url ||= "https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/RATEFILE"

    import_file(file_url, 'rates')
  end

  def import_file(url, table_name)
    require 'open-uri'

    begin
      puts "Start Time: " + Time.new.inspect
      conn = ActiveRecord::Base.connection
      rc   = conn.raw_connection
      rc.exec("COPY " + table_name + " (single_rec) FROM STDIN WITH DELIMITER AS '~'")

      file = open(url)

      until file.eof?
        # Add row to copy data
        line = file.readline
        puts 'Reading....'
        rc.put_copy_data(line)
      end

      # We are done adding copy data
      rc.put_copy_end
      # Display any error messages
      while (res = rc.get_result)
        if e_message = res.error_message
          p e_message
        end
      end

    rescue OpenURI::HTTPError => e
      rc.put_copy_end unless rc.nil?

      puts "Skipped File..."
    end

    result = ActiveRecord::Base.connection.execute("SELECT public.proc_process_flat_rates()")
    result.clear

    puts "End Time: " + Time.new.inspect
  end
end
