class ManageController < ApplicationController
  require 'open-uri'

  EXCLUDED_NAMES = [:id, :policy_type, :process_payroll_all_transactions_breakdown_by_manual_class_id, :number_of_employees, :payroll_origin, :manual_class_calculation_id, :representative_number, :recently_updated, :created_at, :updated_at].freeze

  before_action :set_payroll_names

  def index
  end

  def payroll
    @representative = Representative.find_by(representative_number: params[:representative_number])
    @payroll        = get_payroll.recently_updated if @representative.present?
  end

  def payroll_diff
    @representative = Representative.find_by(representative_number: 1740) # Matrix
    @payroll        = PolicyCalculation.includes(:payroll_calculations).by_representative(@representative.representative_number).updated_this_week.limit(5).flat_map { |policy| policy.payroll_calculations.not_recently_updated }.uniq
    # @payroll    = []
    pcomb_lines    = File.readlines(Rails.root.join('app', 'assets', 'documents', 'PCOMBFILE.txt'))
    rate_lines     = File.readlines(Rails.root.join('app', 'assets', 'documents', 'RATEFILE.txt'))
    @payroll       = check_pcombfile(pcomb_lines) #returns payroll that doesnt match
    @payroll_count = @payroll.count
    @payroll       = @payroll.compact
  end

  def non_updated_payroll
    @representative = Representative.find_by(representative_number: params[:representative_number])
    @payroll        = get_payroll.not_recently_updated.within_two_years if @representative.present?
  end

  private

  def set_payroll_names
    @payroll_names = PayrollCalculation.attribute_names.map { |name| name.to_sym unless name.to_sym.in?(EXCLUDED_NAMES) }.compact
  end

  def get_payroll
    PayrollCalculation.by_representative(@representative.representative_number).includes(:policy_calculation)
  end

  def check_pcombfile(lines)
    records = []

    @payroll.map do |payroll|
      payroll unless in_pcomb_file(lines, payroll.policy_number, payroll.manual_class_payroll, payroll.manual_number)
    end
  end

  def in_pcomb_file(lines, policy_number, manual_class_payroll, manual_number)
    true.in?(lines.map do |line|
      line[0, 6]&.to_i == 1740 &&
        line[14, 8]&.to_i == policy_number &&
        line[101, 13]&.to_f == manual_class_payroll &&
        line[77, 5]&.to_i == manual_number
    end.uniq)
  end
end