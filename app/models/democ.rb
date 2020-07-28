# == Schema Information
#
# Table name: democs
#
#  id         :integer          not null, primary key
#  single_rec :string
#

class Democ < ActiveRecord::Base
  require 'activerecord-import'
  require 'open-uri'

  scope :by_representative, -> (rep_number) { where("cast_to_int(substring(democs.single_rec,1,6)) = ?", rep_number) }

  def self.import_file(url)
    time1 = Time.new
    puts "Start Time: " + time1.inspect
    # Democ.transaction do
    Resque.enqueue(ImportFile, url, "democs")

    # end
    time2 = Time.new
    puts "End Time: " + time2.inspect
  end

end
