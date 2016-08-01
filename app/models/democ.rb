class Democ < ActiveRecord::Base
  require 'csv'

  def self.import(file)
    CSV.foreach(file.path) do |row|
      Democ.create!(single_rec: row)
    end
  end

end
