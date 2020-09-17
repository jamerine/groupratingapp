class ImportsController < ApplicationController
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
    @import                        = Import.new(import_params)
    @representative                = Representative.find(@import.representative_id)
    @import.process_representative = @representative.representative_number
    @import.import_status          = 'Queuing'
    @import.parse_status           = 'Queuing'
    # Flat files
    if @import.save
      @new_group_rating                        = GroupRating.new(experience_period_lower_date: @representative.experience_period_lower_date, experience_period_upper_date: @representative.experience_period_upper_date, current_payroll_period_lower_date: @representative.current_payroll_period_lower_date, current_payroll_period_upper_date: @representative.current_payroll_period_upper_date, current_payroll_year: @representative.current_payroll_year, program_year_lower_date: @representative.program_year_lower_date, program_year_upper_date: @representative.program_year_upper_date, program_year: @representative.program_year, quote_year_lower_date: @representative.quote_year_lower_date, quote_year_upper_date: @representative.quote_year_upper_date, quote_year: @representative.quote_year, representative_id: @representative.id)
      @new_group_rating.status                 = 'Queuing'
      @new_group_rating.process_representative = @representative.representative_number
      if @new_group_rating.save
        ImportProcess.perform_async(@import.process_representative, @import.id, @representative.abbreviated_name, @new_group_rating.id, true)
      end
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

  def import_miras
    @representative = Representative.find(import_params[:representative_id])

    ImportMiraFilesProcess.perform_async(@representative.representative_number, @representative.abbreviated_name)

    redirect_to imports_path, notice: "Files to be imported and parse have been queued."
  end

  def import_democs
    require 'open-uri'
    @representative = Representative.find(import_params[:representative_id])

    ImportDemocProcess.perform_async(@representative.representative_number, @representative.abbreviated_name)

    redirect_to imports_path, notice: "Files to be imported and parse have been queued."
  end

  def import_pdemos
    require 'open-uri'
    @representative = Representative.find(import_params[:representative_id])

    ImportPdemoProcess.perform_async(@representative.representative_number, @representative.abbreviated_name)

    redirect_to imports_path, notice: "Files to be imported and parse have been queued."
  end

  def import_pcombs
    require 'open-uri'
    @representative = Representative.find(import_params[:representative_id])

    ImportPcombProcess.new.perform(@representative.representative_number, @representative.abbreviated_name)

    redirect_to imports_path, notice: "Files to be imported and parse have been queued."
  end

  def import_clicds
    @representative = Representative.find(import_params[:representative_id])

    ImportClicdFilesProcess.perform_async(@representative.representative_number, @representative.abbreviated_name)

    redirect_to imports_path, notice: "Files to be imported and parse have been queued."
  end

  def import_all_miras
    Representative.all.find_each do |representative|
      ImportMiraFilesProcess.perform_async(representative.representative_number, representative.abbreviated_name)
    end

    redirect_to imports_path, notice: "Files to be imported and parse have been queued."
  end

  def import_all_democs
    Representative.all.find_each do |representative|
      ImportDemocProcess.perform_async(representative.representative_number, representative.abbreviated_name)
    end

    redirect_to imports_path, notice: "Files to be imported and parse have been queued."
  end

  def import_all_clicds
    Representative.all.find_each do |representative|
      ImportClicdFilesProcess.perform_async(representative.representative_number, representative.abbreviated_name)
    end

    redirect_to imports_path, notice: "Files to be imported and parse have been queued."
  end

  private

  def import_params
    params.require(:import).permit(:process_representative, :import_status, :parse_status, :representative_id, :group_rating_id)
  end
end
