class ImportClicdFilesProcess
  include Sidekiq::Worker
  sidekiq_options queue: :import_clicd_files_process, retry: 3

  def perform(representative_number, representative_abbreviated_name)
    Clicd.by_representative(representative_number).delete_all

    import_file("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/CLICDFILE", 'clicds')

    Clicd.by_representative(representative_number).by_record_type.find_each do |clicd|
      record = ClicdDetailRecord.find_or_create_by({ representative_number:    clicd.representative_number,
                                                     record_type:              clicd.record_type,
                                                     requestor_number:         clicd.requestor_number,
                                                     business_sequence_number: clicd.business_sequence_number,
                                                     policy_number:            clicd.policy_number,
                                                     claim_number:             clicd.claim_number
                                                   })
      record.update_attributes(gather_attributes(clicd))
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
        if line[40, 4] == "0000"
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

  def gather_attributes(clicd)
    { valid_policy_number:                  clicd.valid_policy_number,
      current_policy_status:                clicd.current_policy_status,
      current_policy_status_effective_date: clicd.current_policy_status_effective_date,
      policy_year:                          clicd.policy_year,
      policy_year_rating_plan:              clicd.policy_year_rating_plan,
      claim_indicator:                      clicd.claim_indicator,
      icd_codes_assigned:                   clicd.icd_codes_assigned,
      icd_code:                             clicd.icd_code,
      icd_status:                           clicd.icd_status,
      icd_status_effective_date:            clicd.icd_status_effective_date,
      icd_injury_location_code:             clicd.icd_injury_location_code,
      icd_digit_tooth_number:               clicd.icd_digit_tooth_number,
      primary_icd:                          clicd.primary_icd }
  end
end
