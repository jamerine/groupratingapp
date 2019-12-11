class ImportsController < ApplicationController
  def show
    @import = Import.find(params[:id])
    @representative = Representative.find_by(id: @import.representative_id)
  end

  def index
    @imports = Import.all
    @import_count = Import.count
    @last_import = Import.last
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
    @import = Import.new
    @representatives = Representative.all
  end

  def create
    @import = Import.new(import_params)
    @representative = Representative.find(@import.representative_id)
    @import.process_representative = @representative.representative_number
    @import.import_status = 'Queuing'
    @import.parse_status = 'Queuing'
      # Flat files
      if @import.save
        Democ.delete_all
        Mrcl.delete_all
        Mremp.delete_all
        Pcomb.delete_all
        Phmgn.delete_all
        Sc220.delete_all
        Sc230.delete_all
        Mira.delete_all
        Clicd.delete_all
        DemocDetailRecord.delete_all
        MrclDetailRecord.delete_all
        MrempEmployeeExperiencePolicyLevel.delete_all
        MrempEmployeeExperienceManualClassLevel.delete_all
        MrempEmployeeExperienceClaimLevel.delete_all
        PcombDetailRecord.delete_all
        PhmgnDetailRecord.delete_all
        MiraDetailRecord.delete_all
        ClicdDetailRecord.delete_all
        Sc220Rec1EmployerDemographic.delete_all
        Sc220Rec2EmployerManualLevelPayroll.delete_all
        Sc220Rec3EmployerArTransaction.delete_all
        Sc220Rec4PolicyNotFound.delete_all
        Sc230EmployerDemographic.delete_all
        Sc230ClaimMedicalPayment.delete_all
        Sc230ClaimIndemnityAward.delete_all
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

        # ImportFile.perform_async("https://s3.amazonaws.com/grouprating/ARM/DEMOCFILE", "democs", @import.id)
        # ImportFile.perform_async("https://s3.amazonaws.com/grouprating/ARM/MRCLSFILE", "mrcls", @import.id)
        # ImportFile.perform_async("https://s3.amazonaws.com/grouprating/ARM/MREMPFILE", "mremps", @import.id)
        # ImportFile.perform_async("https://s3.amazonaws.com/grouprating/ARM/PCOMBFILE", "pcombs", @import.id)
        # ImportFile.perform_async("https://s3.amazonaws.com/grouprating/ARM/PHMGNFILE", "phmgns", @import.id)
        # ImportFile.perform_async("https://s3.amazonaws.com/grouprating/ARM/SC220FILE", "sc220s", @import.id)
        # ImportFile.perform_async("https://s3.amazonaws.com/grouprating/ARM/SC230FILE", "sc230s", @import.id)
        ImportProcess.perform_async(@import.process_representative, @import.id, @representative.abbreviated_name)
        # Resque.enqueue(ParseProcess, @import.process_representative, @import.id)

        redirect_to imports_path, notice: "Files to be imported and parse have been queued."
      end
      # Resque.enqueue(ImportProcess, process_representative_name)
      # Democ.import_file("https://s3.amazonaws.com/grouprating/ARM/DEMOCFILE")
      # Mrcl.import_file("https://s3.amazonaws.com/grouprating/ARM/MRCLSFILE")
      # Mremp.import_file("https://s3.amazonaws.com/grouprating/ARM/MREMPFILE")
      # Pcomb.import_file("https://s3.amazonaws.com/grouprating/ARM/PCOMBFILE")
      # Phmgn.import_file("https://s3.amazonaws.com/grouprating/ARM/PHMGNFILE")
      # Sc220.import_file("https://s3.amazonaws.com/grouprating/ARM/SC220FILE")
      # Sc230.import_file("https://s3.amazonaws.com/grouprating/ARM/SC230FILE")

      # BWC Support Tables
      # BwcCodesBaseRatesExpLossRate.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_expected_loss.csv')
      # BwcCodesCredibilityMaxLoss.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_credibility_max_loss.csv')
      # BwcCodesIndustryGroupSavingsRatioCriterium.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/Industry+Group+Savings+Ratio+Criteria.csv')
      # BwcCodesLimitedLossRatio.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/limited_loss_ratio.csv')
      # BwcCodesNcciManualClass.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/NCCI+Manual+Classes.csv')
      # BwcCodesPolicyEffectiveDate.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/BWC+History+with+Pol+and+Eff+Date.csv')
      # BwcCodesPeoList.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/peo_list.csv')
      # BwcCodesConstantValue.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_codes_constant_values.csv')

    #   redirect_to imports_path, notice: "All files have been queued to import.  Please wait."
    # time2 = Time.new
    # puts "Process End Time: " + time2.inspect

  end
  #
  private

  def import_params
    params.require(:import).permit(:process_representative, :import_status, :parse_status, :representative_id, :group_rating_id)
  end
end
