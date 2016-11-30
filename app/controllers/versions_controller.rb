class VersionsController < ApplicationController
  def show

  end

  def index
    @model_type = params[:item_type].constantize
    @model = @model_type.find(params[:item_id])

    @versions = @model.versions.order("created_at DESC").each.map{|v| [v.created_at, v.changeset, v.whodunnit]}
    user_ids = @model.versions.each.map{|v| [v.whodunnit.to_i]}
    @version_users = User.where(:id => user_ids)
  end

end
