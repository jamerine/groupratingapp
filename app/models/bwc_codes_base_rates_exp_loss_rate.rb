# == Schema Information
#
# Table name: bwc_codes_base_rates_exp_loss_rates
#
#  id                 :integer          not null, primary key
#  class_code         :integer
#  base_rate          :float
#  expected_loss_rate :float
#  created_at         :datetime
#  updated_at         :datetime
#

class BwcCodesBaseRatesExpLossRate < ActiveRecord::Base
  require 'activerecord-import'
  require 'open-uri'

  has_one :bwc_codes_ncci_manual_class, foreign_key: :ncci_manual_classification, primary_key: :class_code

  delegate :industry_group, to: :bwc_codes_ncci_manual_class, prefix: false, allow_nil: true

  def self.import_table(url)
    time1 = Time.new
    puts "Start Time: " + time1.inspect
    # Democ.transaction do
      conn = ActiveRecord::Base.connection
      rc = conn.raw_connection
      rc.exec("COPY bwc_codes_base_rates_exp_loss_rates (class_code, base_rate, expected_loss_rate) FROM STDIN WITH CSV")

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
