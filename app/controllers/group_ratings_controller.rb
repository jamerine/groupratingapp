class GroupRatingsController < ApplicationController
  require 'sidekiq/api'

# @representatives is scoped at the application level

  def index
    @group_ratings = GroupRating.where(representative_id: @representatives).includes(:import)
    @representatives = Representative.where(representative_id: @representatives)
  end

  def show
    @group_rating = GroupRating.find(params[:id])
    @representative = Representative.find(@group_rating.representative_id)
    @import = Import.find_by(group_rating_id: @group_rating.id)
  end

  def new
    @group_rating = GroupRating.new
  end

  def create
    stats = Sidekiq::Stats.new.fetch_stats!
    if stats[:retry_size] > 0 || stats[:workers_size] > 0 || stats[:enqueued] > 0
      redirect_to group_ratings_path, alert: "Please wait for background update to finish."
    else
      @group_rating = GroupRating.where(representative_id: group_rating_params[:representative_id]).destroy_all
      @group_rating = GroupRating.new(group_rating_params)
      @representative = Representative.find(@group_rating.representative_id)
      @group_rating.process_representative = @representative.representative_number
      @group_rating.status = 'Queuing'
      if @group_rating.save
        @import = Import.new(process_representative: @group_rating.process_representative, representative_id: @group_rating.representative_id, group_rating_id: @group_rating.id, import_status: 'Queuing', parse_status: 'Queuing')
          # Flat files
          if @import.save

            ImportProcess.perform_async(@import.process_representative, @import.id, @representative.abbreviated_name, @group_rating.id)

            redirect_to @group_rating, notice: "Import, processing and group rating have been queued."
          end
        end
    end
  end

  def destroy
    @group_rating = GroupRating.find(params[:id])

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
    if @group_rating.destroy
      redirect_to group_ratings_path, notice: "All files are deleted."
    end
  end


  private

  def group_rating_params
    params.require(:group_rating).permit(:process_representative, :experience_period_lower_date, :experience_period_upper_date, :current_payroll_period_lower_date, :current_payroll_period_upper_date, :representative_id)
  end
end
