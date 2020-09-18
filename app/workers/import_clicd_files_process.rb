class ImportClicdFilesProcess
  require 'progress_bar/core_ext/enumerable_with_progress'
  include Sidekiq::Worker
  sidekiq_options queue: :import_clicd_files_process, retry: 1

  def perform(representative_number, representative_abbreviated_name)
    Clicd.by_representative(representative_number).delete_all
    import_file("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/CLICDFILE", 'clicds')

    Clicd.by_representative(representative_number).by_record_type.each_with_progress do |clicd|
      ImportClicdData.perform_async(clicd.attributes)
    end
  end

  def import_file(url, table_name)
    require 'open-uri'

    begin
      puts "Start Time: " + Time.new.inspect
      conn = ActiveRecord::Base.connection
      rc   = conn.raw_connection
      rc.exec("COPY " + table_name + " (single_rec) FROM STDIN WITH DELIMITER AS '|'")

      file = open(url)

      until file.eof?
        # Add row to copy data
        line = file.readline
        if table_name == 'democs' && line[40, 4] == "0000"
          #puts "incorrect characters"
        else
          puts 'Reading....'
          rc.put_copy_data(line)
        end
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

    puts "End Time: " + Time.new.inspect
  end
end
