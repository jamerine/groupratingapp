# == Schema Information
#
# Table name: bwc_codes_industry_group_savings_ratio_criteria
#
#  id               :integer          not null, primary key
#  industry_group   :integer
#  ratio_criteria   :float
#  average_ratio    :float
#  actual_decimal   :float
#  percent_value    :float
#  em               :float
#  market_rate      :float
#  market_em_rate   :float
#  sponsor          :string
#  ac26_group_level :string
#  created_at       :datetime
#  updated_at       :datetime
#

class BwcCodesIndustryGroupSavingsRatioCriterium < ActiveRecord::Base
  require 'activerecord-import'
  require 'open-uri'

  scope :industry_groups, -> { pluck(:industry_group).uniq.sort }

  def self.import_table(url)
    time1 = Time.new
    puts "Start Time: " + time1.inspect
    # Democ.transaction do
      conn = ActiveRecord::Base.connection
      rc = conn.raw_connection
      rc.exec("COPY bwc_codes_industry_group_savings_ratio_criteria (industry_group, ratio_criteria, average_ratio, actual_decimal, percent_value, em, market_rate, market_em_rate, sponsor, ac26_group_level ) FROM STDIN WITH CSV")

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
