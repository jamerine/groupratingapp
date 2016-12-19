class GroupRatingExceptionsController < ApplicationController
  def index
    @group_rating_exceptions = GroupRatingException.where(representative_id: @representatives)
    if params[:search].present? && params[:representative_number].present?
      @representative = @representatives.find_by(representative_number: params[:representative_number])
      @group_rating_exceptions = @group_rating_exceptions.where(representative_id: @representative.id).search(params[:search]).paginate(page: params[:page], per_page: 50)
    elsif params[:search_name].present? && params[:representative_number].present?
      @representative = @representatives.find_by(representative_number: params[:representative_number])
      @group_rating_exceptions = @group_rating_exceptions.where(representative_id: @representative.id).search(params[:search_name]).paginate(page: params[:page], per_page: 50)
    elsif params[:search].present?
      @group_rating_exceptions = @group_rating_exceptions.search(params[:search]).paginate(page: params[:page], per_page: 50)
    elsif params[:search].present?
      @group_rating_exceptions = @group_rating_exceptions.search_name(params[:search_name]).paginate(page: params[:page], per_page: 50)
    elsif params[:representative_number].present?
      @representative = @representatives.find_by(representative_number: params[:representative_number])
      @group_rating_exceptions = @group_rating_exceptions.where(representative_id: @representative.id).paginate(page: params[:page], per_page: 50)
    else
      @group_rating_exceptions = @group_rating_exceptions.paginate(page: params[:page], per_page: 50)
    end

  respond_to do |format|
      format.html
      format.js
    end
  end

end
