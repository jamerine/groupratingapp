# == Schema Information
#
# Table name: pcombs
#
#  id         :integer          not null, primary key
#  single_rec :string
#

class Pcomb < ActiveRecord::Base
  require 'activerecord-import'
  require 'open-uri'

  attr_accessor :representative_number, :policy_number, :manual_class_payroll, :manual_number

  def self.import_file(url)
    time1 = Time.new
    puts "Start Time: " + time1.inspect
    # Democ.transaction do
    Resque.enqueue(ImportFile, url, "pcombs")

    # end
    time2 = Time.new
    puts "End Time: " + time2.inspect
  end

  def representative_number
    self.single_rec[0, 6]&.to_i
  end

  def policy_number
    self.single_rec[14, 8]&.to_i
  end

  def manual_number
    self.single_rec[77, 5]&.to_i
  end

  def manual_class_payroll
    self.single_rec[101, 13]&.to_f
  end

end
