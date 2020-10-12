module ImportHelper
  def import_types
    [
      [:miras, 'Miras'],
      [:weekly_miras, 'Weekly Miras'],
      [:clicds, 'Clicds'],
      [:democs, 'Democs'],
      [:rates, 'Rates'],
      [:pdemos, 'Pdemos'],
      [:pcombs, 'Pcombs'],
      [:mrcls, 'Mrcls'],
      [:mremps, 'Mremps'],
      [:phmgns, 'Phmgns'],
      [:sc230, 'SC230'],
      [:pemhs, 'Pemhs'],
      [:pcovgs, 'Pcovgs']
    ]
  end

  def import_single_file(url, table_name, delimiter = "|")
    require 'open-uri'

    begin
      puts "Start Time: " + Time.new.inspect
      conn = ActiveRecord::Base.connection
      rc   = conn.raw_connection
      rc.exec("COPY " + table_name + " (single_rec) FROM STDIN WITH DELIMITER AS '#{delimiter}'")

      file = open(url)

      until file.eof?
        # Add row to copy data
        line = file.readline

        if table_name == 'democs' && line[40, 4] == "0000"
          puts "Incorrect characters...ignoring..."
        elsif table_name == 'pdemos' && line.include?('|')
          new_line = line.gsub('|', ' ')
          puts 'Reading....'
          rc.put_copy_data(new_line)
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

    rescue OpenURI::HTTPError
      rc.put_copy_end unless rc.nil?

      puts "Skipped File due to error..."
    end

    unless table_name.in?(%w[miras clicds weekly_miras])
      result = ActiveRecord::Base.connection.execute("SELECT public.proc_process_flat_#{table_name}()")
      result.clear
    end

    puts "End Time: " + Time.new.inspect
  end
end
