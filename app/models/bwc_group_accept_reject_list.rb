# == Schema Information
#
# Table name: bwc_group_accept_reject_lists
#
#  id            :integer          not null, primary key
#  policy_number :integer
#  name          :string
#  tpa           :string
#  bwc_rep_id    :string
#  created_at    :datetime
#  updated_at    :datetime
#

class BwcGroupAcceptRejectList < ActiveRecord::Base
  require 'activerecord-import'
  require 'open-uri'

  def self.import_table(url)
    time1 = Time.new
    puts "Start Time: " + time1.inspect
    # Democ.transaction do
      conn = ActiveRecord::Base.connection
      rc = conn.raw_connection
      rc.exec("COPY bwc_group_accept_reject_lists (policy_number, name, tpa, bwc_rep_id) FROM STDIN WITH CSV")

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
