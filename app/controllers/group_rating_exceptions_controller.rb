class GroupRatingExceptionsController < ApplicationController
  def index
    @group_rating_exceptions = GroupRatingException.where(representative_id: @representatives, resolved: nil)
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

  def resolve
    @group_rating_exception = GroupRatingException.find(params[:group_rating_exception_id])
    @group_rating_exceptions = GroupRatingException.where("id in (?)", params[:group_rating_exceptions])
    @group_rating_exceptions.delete(@group_rating_exception)
    @group_rating_exception.assign_attributes(resolved: true)
    if @group_rating_exception.save
      @message = "Exception was resolved"
      redirect_to group_rating_exceptions_path, notice: 'Exception was resolved.'
    else
      @message = "Exception was not resolved. Try again."
      redirect_to group_rating_exceptions_path, alert: 'Exception was not resolved. Try again.'

    end

  end

  def after_resolve
    @group_rating_exceptions = GroupRatingException.where("id in (?)", params[:group_rating_exceptions])
  end

end
