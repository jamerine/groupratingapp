class ManageController < ApplicationController
  EXCLUDED_NAMES = [:id, :policy_type, :process_payroll_all_transactions_breakdown_by_manual_class_id, :number_of_employees, :payroll_origin, :manual_class_calculation_id, :representative_number, :recently_updated, :created_at, :updated_at].freeze

  before_action :set_payroll_names

  def index
  end

  def payroll
    @representative = Representative.find_by(representative_number: params[:representative_number])

    if @representative.present?
      @payroll = PayrollCalculation.by_representative(@representative.representative_number).recently_updated
    end
  end

  def non_updated_payroll
    @representative = Representative.find_by(representative_number: params[:representative_number])

    if @representative.present?
      @payroll = PayrollCalculation.by_representative(@representative.representative_number).not_recently_updated.within_two_years
    end
  end

  private

  def set_payroll_names
    @payroll_names = PayrollCalculation.attribute_names.map { |name| name.to_sym unless name.to_sym.in?(EXCLUDED_NAMES) }.compact
  end
end