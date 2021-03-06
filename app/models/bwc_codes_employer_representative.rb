# == Schema Information
#
# Table name: bwc_codes_employer_representatives
#
#  id                    :integer          not null, primary key
#  rep_id                :integer
#  employer_rep_name     :string
#  rep_id_text           :string
#  representative_number :integer
#  created_at            :datetime
#  updated_at            :datetime
#

class BwcCodesEmployerRepresentative < ActiveRecord::Base
  require 'activerecord-import'
  require 'open-uri'

  def self.import_table(url)
    time1 = Time.new
    puts "Start Time: " + time1.inspect
    # Democ.transaction do
      conn = ActiveRecord::Base.connection
      rc = conn.raw_connection
      rc.exec("COPY bwc_codes_employer_representatives (rep_id, employer_rep_name, rep_id_text, representative_number) FROM STDIN WITH CSV")

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
