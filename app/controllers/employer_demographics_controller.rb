class EmployerDemographicsController < ApplicationController

  def index
    @representative = Representative.find_by(id: params[:representative_id])
    redirect_to page_not_found_path and return unless @representative.present?

    @field_names  = EmployerDemographic.column_names.reject { |col| col if col.to_sym.in? [:created_at, :representative_id, :employer_state, :id, :business_sequence_number] }.compact
    @demographics = @representative.employer_demographics.order(:policy_number)
  end
end