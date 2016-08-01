class DemocsController < ApplicationController
  def index
    @democs = Democ.all
    @democs_count = Democ.count
  end

  def import
    Democ.import_file("https://s3.amazonaws.com/grouprating/flat_files/DEMOCFILE")
    redirect_to root_url, notice: "Democs imported."
  end
end
