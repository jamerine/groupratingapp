class RepresentativesController < ApplicationController

  def index
    @representatives = Representatives.all
  end

  
end
