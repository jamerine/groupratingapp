class ProgramRejectionsController < ApplicationController

  def index
    @program_rejections = GroupRatingRejection.where(representative_id: @representatives).includes(:representative, account: [:policy_calculation]).paginate(page: params[:page], per_page: 50)
    @rejection_reasons = GroupRatingRejection.all.pluck(:reject_reason).uniq
    @program_types = GroupRatingRejection.all.pluck(:program_type).uniq
    # if params[:reject_reason].present? && params[:representative_number].present? && params[:program_type].present?
    #   @representative = @representatives.find_by(representative_number: params[:representative_number])
    #   @program_rejections = @program_rejections.where(representative_id: @representative.id).program_type(params[:program_type]).reject_reason(params[:reject_reason]).paginate(page: params[:page], per_page: 50)
    # elsif params[:reject_reason].present? && params[:representative_number].present?
    #   @representative = @representatives.find_by(representative_number: params[:representative_number])
    #   @program_rejections = @program_rejections.where(representative_id: @representative.id).reject_reason(params[:reject_reason]).paginate(page: params[:page], per_page: 50)
    # elsif params[:reject_reason].present? && params[:program_type].present?
    #   @program_rejections = @program_rejections.program_type(params[:program_type]).reject_reason(params[:reject_reason]).paginate(page: params[:page], per_page: 50)
    # elsif params[:representative_number].present? && params[:program_type].present?
    #   @representative = @representatives.find_by(representative_number: params[:representative_number])
    #   @program_rejections = @program_rejections.where(representative_id: @representative.id).program_type(params[:program_type]).paginate(page: params[:page], per_page: 50)
    # elsif params[:representative_number].present?
    #   @representative = @representatives.find_by(representative_number: params[:representative_number])
    #   @program_rejections = @program_rejections.where(representative_id: @representative.id).paginate(page: params[:page], per_page: 50)
    # elsif params[:program_type].present?
    #   @program_rejections = @program_rejections.program_type(params[:program_type]).paginate(page: params[:page], per_page: 50)
    # elsif params[:reject_reason].present?
    #   @program_rejections = @program_rejections.reject_reason(params[:reject_reason]).paginate(page: params[:page], per_page: 50)
    # else
    #   @program_rejections = @program_rejections.paginate(page: params[:page], per_page: 50)
    # end

    # IF present section
    @program_rejections = @program_rejections.where(representative_id: params[:representative_id]).paginate(page: params[:page], per_page: 50) if params[:representative_id].present?
    @program_rejections = @program_rejections.program_type(params[:program_type]).paginate(page: params[:page], per_page: 50) if params[:program_type].present?
    @program_rejections = @program_rejections.reject_reason(params[:reject_reason]).paginate(page: params[:page], per_page: 50) if params[:reject_reason].present?

  respond_to do |format|
      format.html
      format.js
    end
  end




end
