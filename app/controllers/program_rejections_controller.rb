class ProgramRejectionsController < ApplicationController

  def index

    @program_rejections = GroupRatingRejection.with_active_policy.where(representative_id: @representatives, hide: nil).paginate(page: params[:page], per_page: 50)

    @rejection_reasons = GroupRatingRejection.where.not(reject_reason: 'reject_inactive_policy').pluck(:reject_reason).uniq
    @program_types = GroupRatingRejection.all.pluck(:program_type).uniq

    # IF present section
    @program_rejections = @program_rejections.where(representative_id: params[:representative_id]).paginate(page: params[:page], per_page: 50) if params[:representative_id].present?
    @program_rejections = @program_rejections.program_type(params[:program_type]).paginate(page: params[:page], per_page: 50) if params[:program_type].present?
    @program_rejections = @program_rejections.reject_reason(params[:reject_reason]).paginate(page: params[:page], per_page: 50) if params[:reject_reason].present?

    # Remove inactive policies

    respond_to do |format|
        format.html
        format.js
    end
  end

  def resolve
    @program_rejection = GroupRatingRejection.find(params[:program_rejection_id])
    @program_rejection.assign_attributes(hide: true)
    if @program_rejection.save
      @message = "Rejection was hidden"
    else
      @message = "Rejection was not hidden. Try again."
    end
    respond_to do |format|
      format.html { result ? flash[:notice] = @message : flash[:alert] = @message }
      format.js
    end
  end

  def after_resolve
    @program_rejections = GroupRatingRejection.where("id in (?)", params[:program_rejection_ids])
  end

end
