class GroupRatingExceptionsController < ApplicationController
  def index
    @group_rating_exceptions = GroupRatingException.where(representative_id: @representatives)
  end
end
