class ImportsController < ApplicationController
  before_action :delete_calculated_tables, only: [:import_file, :import_files]

  def show
    @import         = Import.find(params[:id])
    @representative = Representative.find_by(id: @import.representative_id)
  end

  def index
    @imports         = Import.all
    @import_count    = Import.count
    @last_import     = Import.last
    @representatives = Representative.all
  end

  def edit
  end

  def update
  end

  def destroy
    Democ.delete_all
    Mrcl.delete_all
    Mremp.delete_all
    Pcomb.delete_all
    Phmgn.delete_all
    Sc220.delete_all
    Sc230.delete_all
    Mira.delete_all
    @import = Import.find(params[:id])

    if @import.destroy
      flash[:notice] = "Import was deleted successfully."
      redirect_to imports_path
    else
      flash.now[:alert] = "There was an error deleting the import."
      redirect_to imports_path
    end

  end

  def new
    @import          = Import.new
    @representatives = Representative.all
  end

  def create
    @import = Import.new(import_params)

    unless @import.representative_id.present?
      flash[:error] = 'No Representative selected, please try again.'
      redirect_to new_import_path and return
    end

    @representative                = Representative.find(@import.representative_id)
    @import.process_representative = @representative.representative_number
    @import.import_status          = 'Queuing'
    @import.parse_status           = 'Queuing'
    @new_group_rating              = GroupRating.new(experience_period_lower_date:      @representative.experience_period_lower_date,
                                                     experience_period_upper_date:      @representative.experience_period_upper_date,
                                                     current_payroll_period_lower_date: @representative.current_payroll_period_lower_date,
                                                     current_payroll_period_upper_date: @representative.current_payroll_period_upper_date,
                                                     current_payroll_year:              @representative.current_payroll_year,
                                                     program_year_lower_date:           @representative.program_year_lower_date,
                                                     program_year_upper_date:           @representative.program_year_upper_date,
                                                     program_year:                      @representative.program_year,
                                                     quote_year_lower_date:             @representative.quote_year_lower_date,
                                                     quote_year_upper_date:             @representative.quote_year_upper_date,
                                                     quote_year:                        @representative.quote_year,
                                                     representative_id:                 @representative.id,
                                                     status:                            'Queuing',
                                                     process_representative:            @representative.representative_number)
    if @new_group_rating.save
      @import.group_rating_id = @new_group_rating.id

      if @import.save
        ImportProcess.perform_async(@import.process_representative, @import.id, @representative.abbreviated_name, @new_group_rating.id, true)
      end

      redirect_to imports_path, notice: "Files to be imported and parse have been queued."
    end
  end

  def import_file
    @import_type    = import_params[:import_type]&.to_sym
    @representative = Representative.find_by(id: import_params[:representative_id])

    unless @import_type.present? && @representative.present?
      flash[:error] = 'No Import Type and/or Representative selected, please try again.'
      redirect_to new_import_path and return
    end

    import_based_on_type(@import_type, @representative, import_params[:custom_file]&.tempfile&.path)

    flash[:success] = "Files to be imported and parse have been queued."
    redirect_to new_import_path
  end

  def import_files
    @import_type = import_params[:import_type]&.to_sym

    unless @import_type.present?
      flash[:error] = 'No Import Type selected, please try again.'
      redirect_to new_import_path and return
    end

    Representative.all.find_each do |representative|
      import_based_on_type(@import_type, representative, import_params[:custom_file]&.tempfile&.path)
    end

    flash[:success] = "Files to be imported and parse have been queued."
    redirect_to new_import_path
  end

  private

  def import_params
    params.require(:import).permit(:process_representative, :import_status, :parse_status, :representative_id, :group_rating_id, :import_type, :custom_file)
  end

  def import_based_on_type(import_type, representative, file_path)
    case import_type
    when :miras
      ImportMiraFilesProcess.perform_async(representative.representative_number, representative.abbreviated_name, false, file_path)
    when :weekly_miras
      ImportMiraFilesProcess.perform_async(representative.representative_number, representative.abbreviated_name, true, file_path)
    when :clicds
      ImportClicdFilesProcess.perform_async(representative.representative_number, representative.abbreviated_name, file_path)
    when :democs
      ImportDemocProcess.perform_async(representative.representative_number, representative.abbreviated_name, file_path)
    when :rates
      ImportRatefileProcess.perform_async(representative.representative_number, representative.abbreviated_name, file_path)
    when :pdemos
      ImportPdemoProcess.perform_async(representative.representative_number, representative.abbreviated_name, file_path)
    when :pcombs
      ImportPcombProcess.perform_async(representative.representative_number, representative.abbreviated_name, file_path)
    when :mrcls
      ImportMrclsProcess.perform_async(representative.representative_number, representative.abbreviated_name, file_path)
    when :mremps
      ImportMrempsProcess.perform_async(representative.representative_number, representative.abbreviated_name, file_path)
    when :phmgns
      ImportPhmgnsProcess.perform_async(representative.representative_number, representative.abbreviated_name, file_path)
    when :sc230
      ImportSc230Process.perform_async(representative.representative_number, representative.abbreviated_name, file_path)
    when :pemhs
      ImportPemhsProcess.perform_async(representative.representative_number, representative.abbreviated_name, file_path)
    when :pcovgs
      ImportPcovgsProcess.perform_async(representative.representative_number, representative.abbreviated_name, file_path)
    else
      ''
    end
  end

  def delete_calculated_tables
    ExceptionTablePolicyCombinedRequestPayrollInfo.where(data_source: 'bwc').delete_all
    FinalClaimCostCalculationTable.where(data_source: 'bwc').delete_all
    FinalEmployerDemographicsInformation.where(data_source: 'bwc').delete_all
    FinalManualClassFourYearPayrollAndExpLoss.where(data_source: 'bwc').delete_all
    FinalManualClassGroupRatingAndPremiumProjection.where(data_source: 'bwc').delete_all
    FinalPolicyExperienceCalculation.where(data_source: 'bwc').delete_all
    FinalPolicyGroupRatingAndPremiumProjection.where(data_source: 'bwc').delete_all
    ProcessManualClassFourYearPayrollWithCondition.where(data_source: 'bwc').delete_all
    ProcessManualClassFourYearPayrollWithoutCondition.where(data_source: 'bwc').delete_all
    ProcessManualReclassTable.where(data_source: 'bwc').delete_all
    ProcessPayrollAllTransactionsBreakdownByManualClass.where(data_source: 'bwc').delete_all
    ProcessPayrollBreakdownByManualClass.where(data_source: 'bwc').delete_all
    ProcessPolicyCombinationLeaseTermination.where(data_source: 'bwc').delete_all
    ProcessPolicyCombineFullTransfer.where(data_source: 'bwc').delete_all
    ProcessPolicyCombinePartialToFullLease.where(data_source: 'bwc').delete_all
    ProcessPolicyCombinePartialTransferNoLease.where(data_source: 'bwc').delete_all
    ProcessPolicyCoverageStatusHistory.where(data_source: 'bwc').delete_all
  end
end
