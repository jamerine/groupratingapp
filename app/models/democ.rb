class Democ < ActiveRecord::Base


  def self.import_file(file)
      democs = []
      IO.foreach(file.path) do |row|
        democs << Democ.new(single_rec: row)
      end
      Democ.import democs
  end
end
