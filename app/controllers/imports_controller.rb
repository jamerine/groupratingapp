class ImportsController < ApplicationController
  def show
    @import = Import.find(params[:id])



  end

  def index
    @imports = Import.all
    @import_count = Import.count
    @last_import = Import.last
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
    @import = Import.find(params[:id])
    if @import.destroy
      flash[:notice] = "Import was deleted successfully."
      redirect_to imports_path
    else
      flash.now[:alert] = "There was an error deleting the import."
      redirect_to imports_path
    end

    redirect_to imports_path
  end

  def new
    @import = Import.new
  end

  def create
    @import = Import.new(import_params)
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
        DemocDetailRecord.delete_all
        MrclDetailRecord.delete_all
        MrempEmployeeExperiencePolicyLevel.delete_all
        MrempEmployeeExperienceManualClassLevel.delete_all
        MrempEmployeeExperienceClaimLevel.delete_all
        PcombDetailRecord.delete_all
        PhmgnDetailRecord.delete_all
        Sc220Rec1EmployerDemographic.delete_all
        Sc220Rec2EmployerManualLevelPayroll.delete_all
        Sc220Rec3EmployerArTransaction.delete_all
        Sc220Rec4PolicyNotFound.delete_all
        Sc230EmployerDemographic.delete_all
        Sc230ClaimMedicalPayment.delete_all
        Sc230ClaimIndemnityAward.delete_all

        Resque.enqueue(ImportProcess, @import.process_representative, @import.id)
        Resque.enqueue(ParseProcess, @import.process_representative, @import.id)

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
    params.require(:import).permit(:process_representative, :import_status, :parse_status)
  end
end
