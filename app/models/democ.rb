class Democ < ActiveRecord::Base
require 'activerecord-import'
require 'open-uri'
  self.table_name = "flat_file_democ"

  def self.import_file(url)
    Democ.transaction do
      democs = []
      IO.foreach(open(url)) do |row|
        democs << Democ.new(single_rec: row)
      end
      Democ.import democs
    end
  end
end
