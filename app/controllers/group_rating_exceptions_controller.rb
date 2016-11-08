class GroupRatingExceptionsController < ApplicationController
  def index
    @group_rating_exceptions = GroupRatingException.all
  end
end
