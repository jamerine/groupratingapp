class VersionsController < ApplicationController
  def show

  end

  def index
    @model_type = params[:item_type].constantize
    @model = @model_type.find(params[:item_id])
    @versions = @model.versions.order("created_at DESC").each.map{|v| [v.created_at, v.changeset, v.whodunnit]}
  end

end
