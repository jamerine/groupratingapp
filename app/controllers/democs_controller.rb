class DemocsController < ApplicationController
  def index
    @democs = Democ.all
    @democs_count = Democ.count
  end

  def import
    Democ.import_file(params[:file])
    redirect_to root_url, notice: "Democs imported."
  end
end
