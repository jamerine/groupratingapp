class Democ < ActiveRecord::Base
require 'activerecord-import'
require 'open-uri'

  def self.import_file(url)
    Democ.transaction do
      democs = []
      IO.foreach(open(url)) do |row|
        democs << Democ.new(single_rec: row)
      end
      Democ.import democs
      # It's good idea to explicitly close your tempfiles
    end
  end
end
