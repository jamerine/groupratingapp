class ManageController < ApplicationController
  require 'open-uri'

  EXCLUDED_NAMES = [:id, :policy_type, :process_payroll_all_transactions_breakdown_by_manual_class_id, :number_of_employees, :payroll_origin, :manual_class_calculation_id, :representative_number, :recently_updated, :created_at, :updated_at].freeze

  before_action :set_payroll_names, :set_claim_names

  def index
  end

  def payroll
    @representative = Representative.find_by(representative_number: params[:representative_number])
    @payroll        = get_payroll.recently_updated if @representative.present?
  end

  def payroll_diff_ids
    require 'open-uri'

    @representative = Representative.find_by(representative_number: 1740) # Matrix
    payroll_ids     = File.read(Rails.root.join('app', 'assets', 'documents', 'payroll_ids.txt')).split(',')
    @payroll        = PayrollCalculation.includes(:policy_calculation).where('id IN (?)', payroll_ids)
    @payroll_count  = @payroll.count

    respond_to do |format|
      format.html
      format.csv { send_data @payroll.to_csv }
    end
  end

  # def payroll_diff
  #   require 'open-uri'
  #
  #   @representative = Representative.find_by(representative_number: 1740) # Matrix
  #   # Rate.delete_all
  #   # import_file(Rails.root.join('app', 'assets', 'documents', 'RATEFILE.txt'), 'rates')
  #   #
  #   # Pcomb.delete_all
  #   # import_file(Rails.root.join('app', 'assets', 'documents', 'PCOMBFILE.txt'), 'pcombs')
  #
  #   respond_to do |format|
  #     format.html
  #     format.js do
  #       payroll = PayrollCalculation.by_representative(1740).not_recently_updated.with_policy_updated_in_quarterly_report
  #       # pcomb_lines    = File.readlines(Rails.root.join('app', 'assets', 'documents', 'PCOMBFILE.txt'))
  #       #     rate_lines     = File.readlines(Rails.root.join('app', 'assets', 'documents', 'RATEFILE.txt'))
  #       #     @pcomb_lines   = prepare_pcomb_lines(pcomb_lines)
  #       #     @rate_lines    = prepare_rate_lines(rate_lines)
  #       payroll        = check_rates(payroll).compact
  #       @payroll       = check_pcombs(payroll).compact # Returns payroll that doesnt match
  #       @payroll       = @payroll.uniq
  #       @payroll_count = @payroll.count
  #
  #       render partial: 'manage/payroll_table'
  #       # render json: { success: true, html: (render_to_string 'manage/_payroll_table', layout: false) }
  #     end
  #   end
  # end

  def claim_diff
    require 'open-uri'

    @representative = Representative.find_by(representative_number: 1740) # Matrix
    # Democ.delete_all
    # DemocDetailRecord.filter_by(1740).delete_all
    # import_file(Rails.root.join('app', 'assets', 'documents', 'DEMOCFILE.txt'), 'democs')

    @representative = Representative.find_by(representative_number: 1740) # Matrix
    claim_ids       = File.readlines(Rails.root.join('app', 'assets', 'documents', 'claim_ids.txt')).map(&:strip)
    @claims         = ClaimCalculation.where('id IN (?)', claim_ids)
    @claim_count    = @claims.count

    respond_to do |format|
      format.html
      format.csv { send_data @claims.to_csv }
    end
  end

  def non_updated_payroll
    @representative = Representative.find_by(representative_number: params[:representative_number])
    @payroll        = get_payroll.not_recently_updated.within_two_years if @representative.present?
  end

  private

  def set_payroll_names
    @payroll_names = PayrollCalculation.attribute_names.map { |name| name.to_sym unless name.to_sym.in?(EXCLUDED_NAMES) }.compact
  end

  def set_claim_names
    @claim_names = ClaimCalculation.attribute_names.map { |name| name.to_sym unless name.to_sym.in?(EXCLUDED_NAMES) }.compact
  end

  def get_payroll
    PayrollCalculation.by_representative(@representative.representative_number).includes(:policy_calculation)
  end

  def prepare_pcomb_lines(lines)
    lines.map { |line| [line[0, 6]&.to_i, line[14, 8]&.to_i, line[101, 13]&.to_f, line[77, 5]&.to_i] }.uniq
  end

  def prepare_rate_lines(lines)
    lines.map do |line|
      line_parts = line.split('|')
      [line_parts[1]&.to_i, line_parts[3]&.to_i, line_parts[22]&.to_f, line_parts[11]&.to_i]
    end.uniq
  end

  def check_file(payroll, lines)
    require 'progress_bar/core_ext/enumerable_with_progress'

    payroll.with_progress.select { |payroll_item| !in_file(lines, payroll_item.policy_number, payroll_item.manual_class_payroll, payroll_item.manual_number) }
  end

  def check_rates(payroll)
    require 'progress_bar/core_ext/enumerable_with_progress'

    payroll.select { |payroll_item| !RateDetailRecord.exists?(representative_number: 1740, payroll: payroll_item.manual_class_payroll, policy_number: payroll_item.policy_number, manual_class: payroll_item.manual_number) }
  end

  def check_pcombs(payroll)
    require 'progress_bar/core_ext/enumerable_with_progress'

    payroll.select { |payroll_item| !PcombDetailRecord.exists?(representative_number: 1740, manual_payroll: payroll_item.manual_class_payroll, policy_number: payroll_item.policy_number, ncci_manual_number: payroll_item.manual_number) }
  end

  def in_file(lines, policy_number, manual_class_payroll, manual_number)
    [1740, policy_number, manual_class_payroll, manual_number].in? lines
  end

  def import_file(url, table_name)
    begin
      time1 = Time.new
      puts "Start Time: " + time1.inspect
      conn = ActiveRecord::Base.connection
      rc   = conn.raw_connection
      if table_name == 'rates'
        rc.exec("COPY " + table_name + " (single_rec) FROM STDIN WITH DELIMITER AS '~'")
      else
        rc.exec("COPY " + table_name + " (single_rec) FROM STDIN WITH DELIMITER AS '|'")
      end

      file = open(url)

      while !file.eof?
        # Add row to copy data
        line = file.readline
        if table_name == 'democs' && line[40, 4] == "0000"
          #puts "incorrect characters"
        else
          rc.put_copy_data(line)
        end
      end


      # We are done adding copy data
      rc.put_copy_end
      # Display any error messages
      while res = rc.get_result
        if e_message = res.error_message
          p e_message
        end
      end

    rescue OpenURI::HTTPError => e
      rc.put_copy_end unless rc.nil?
      # The CLICD File doesn't exist
      puts "Skipped File..."
    end

    result = ActiveRecord::Base.connection.execute("SELECT public.proc_process_flat_" + table_name + "()")
    result.clear
  end
end