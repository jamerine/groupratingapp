class GroupRatingExceptionsController < ApplicationController
  def index
    @representatives_users = RepresentativesUser.where(user_id: current_user.id).pluck(:representative_id)
    @representatives = Representative.where(id: @representatives_users)
    @group_rating_exceptions = GroupRatingException.where(representative_id: @representatives)
  end
end
