# == Schema Information
#
# Table name: bwc_codes_constant_values
#
#  id             :integer          not null, primary key
#  completed_date :date
#  employer_type  :integer          default(0)
#  name           :string
#  rate           :float
#  start_date     :date
#  created_at     :datetime
#  updated_at     :datetime
#

class BwcCodesConstantValue < ActiveRecord::Base
  require 'activerecord-import'
  require 'open-uri'

  scope :current_rate, -> { find_by(name: :administrative_rate, completed_date: nil) }

  def self.import_table(url)
    time1 = Time.new
    puts "Start Time: " + time1.inspect
    # Democ.transaction do
      conn = ActiveRecord::Base.connection
      rc = conn.raw_connection
      rc.exec("COPY bwc_codes_constant_values (name, rate, start_date) FROM STDIN WITH CSV")

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
