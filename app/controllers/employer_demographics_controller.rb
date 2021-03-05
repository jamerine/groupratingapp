class EmployerDemographicsController < ApplicationController

  def index
    @field_names  = EmployerDemographic.column_names.reject { |col| col if col.to_sym.in? [:created_at, :representative_id, :employer_state, :id, :business_sequence_number] }.compact
    @demographics = EmployerDemographic.order(:policy_number)
    @demographics = @demographics.where('LOWER(primary_name) LIKE :search OR policy_number::VARCHAR LIKE :search', search: "%#{params[:search]&.downcase}%") if params[:search].present?
    @demographics = @demographics.page(params[:page]).per(25)
  end

  def purge
    ids   = EmployerDemographic.pluck(:id)
    count = EmployerDemographic.purge(ids)
    count == ids.count ? flash[:success] = 'Purged Data Successfully!' : flash[:danger] = 'Something Went Wrong Purging Data!'

    redirect_to action: :index
  end

  def import
    begin
      EmployerDemographicsImportProcess.perform_async(params[:file].path)

      flash[:notice] = "The Employer Demographics Import Has Been Queued!"
      redirect_to action: :index
    rescue
      flash[:alert] = "There was an error importing file.  Please ensure file columns and file type are correct"
      redirect_to action: :index
    end
  end
end