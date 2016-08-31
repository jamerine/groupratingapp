class GroupRatingsController < ApplicationController

  def index
    @group_ratings = GroupRating.all
  end

  def show
    @group_rating = GroupRating.find(params[:id])
  end

  def new
    @group_rating = GroupRating.new
  end

  def create

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

    @group_rating = GroupRating.new(group_rating_params)
    @group_rating.status = 'Queuing'
    if @group_rating.save
      GroupRatingStep1.perform_async("1", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date, @group_rating.id)
      GroupRatingStep2.perform_async("2", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date, @group_rating.id)
      GroupRatingStep3.perform_async("3",@group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date, @group_rating.id)
      GroupRatingStep4.perform_async("4", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date, @group_rating.id)
      GroupRatingStep5.perform_async("5", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date, @group_rating.id)
      GroupRatingStep6.perform_async("6", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date, @group_rating.id)
      GroupRatingStep7.perform_async("7", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date, @group_rating.id)
      GroupRatingStep8.perform_async("8", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date, @group_rating.id)

      redirect_to group_ratings_path, notice: "Step 1, Step 2, Step 3, Step 4, Step 5, Step 6, Step 7, Step 8 have been queued."
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
    params.require(:group_rating).permit(:process_representative, :experience_period_lower_date,:experience_period_upper_date, :current_payroll_period_lower_date)
  end
end
