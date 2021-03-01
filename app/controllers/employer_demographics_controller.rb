class EmployerDemographicsController < ApplicationController

  def index
    @field_names    = EmployerDemographic.column_names.reject { |col| col if col.to_sym.in? [:created_at, :representative_id, :employer_state, :id, :business_sequence_number] }.compact
    @representative = Representative.find_by(id: params[:representative_id])
    redirect_to page_not_found_path and return unless @representative.present?

    @demographics = @representative.employer_demographics.order(:policy_number)
    @demographics = @demographics.where('LOWER(primary_name) LIKE :search OR policy_number::VARCHAR LIKE :search', search: "%#{params[:search]&.downcase}%") if params[:search].present?
    @demographics = @demographics.page(params[:page]).per(25)
  end

  def purge
    @representative = Representative.find_by(id: params[:representative_id])
    redirect_to page_not_found_path and return unless @representative.present?

    ids   = @representative.employer_demographics.pluck(:id)
    count = EmployerDemographic.purge(ids)
    count == ids.count ? flash[:success] = 'Purged Data Successfully!' : flash[:danger] = 'Something Went Wrong Purging Data!'

    redirect_to action: :index
  end
end