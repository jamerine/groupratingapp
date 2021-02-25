class EmployerDemographicsController < ApplicationController

  def index
    @field_names    = EmployerDemographic.column_names.reject { |col| col if col.to_sym.in? [:created_at, :representative_id, :employer_state, :id, :business_sequence_number] }.compact
    @representative = Representative.find_by(id: params[:representative_id])
    redirect_to page_not_found_path and return unless @representative.present?

    @demographics = @representative.employer_demographics.order(:policy_number).page(params[:page]).per(25)
    # @demographics = @representative.employer_demographics
  end
end