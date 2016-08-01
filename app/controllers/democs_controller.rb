class DemocsController < ApplicationController
  def index
    @democs = Democ.all
  end

  def import
    Democ.import(params[:file])
    redirect_to root_url, notice: "Democs imported."
  end
end
