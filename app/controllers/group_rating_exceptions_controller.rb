class GroupRatingExceptionsController < ApplicationController
  def index
    @group_rating_exceptions = GroupRatingException.where(representative_id: @representatives)
    @exception_reasons = GroupRatingException.all.pluck(:exception_reason).uniq
    if params[:exception_reason].present? && params[:representative_number].present?
      @representative = @representatives.find_by(representative_number: params[:representative_number])
      @group_rating_exceptions = @group_rating_exceptions.where(representative_id: @representative.id).search(params[:exception_reason]).paginate(page: params[:page], per_page: 50)
    elsif params[:exception_reason].present?
      @group_rating_exceptions = @group_rating_exceptions.search(params[:exception_reason]).paginate(page: params[:page], per_page: 50)
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
