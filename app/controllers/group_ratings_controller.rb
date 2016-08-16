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
    @group_rating = GroupRating.new(group_rating_params)
    if @group_rating.save
      GroupRating.step_1(@group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date )

      GroupRating.step_2(@group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date)

      GroupRating.step_3(@group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date)


      GroupRating.step_4(@group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date)

      GroupRating.step_5(@group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date)

      GroupRating.step_6(@group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date)
      redirect_to group_ratings_path, notice: "Step 1, Step 2, Step 3, Step 4, Step 5, Step 6 Completed"
    end
  end

  def destroy
    @group_rating = GroupRating.find(params[:id])

      ExceptionTablePolicyCombinedRequestPayrollInfo.delete_all
      FinalClaimCostCalculationTable.delete_all
      FinalEmployerDemographicsInformation.delete_all
      FinalManualClassFourYearPayrollAndExpLoss.delete_all
      FinalManualClassGroupRatingAndPremiumProjection.delete_all
      FinalPolicyExperienceCalculation.delete_all
      FinalPolicyGroupRatingAndPremiumProjection.delete_all
      ProcessManualClassFourYearPayrollWithCondition.delete_all
      ProcessManualClassFourYearPayrollWithoutCondition.delete_all
      ProcessManualReclassTable.delete_all
      ProcessPayrollAllTransactionsBreakdownByManualClass.delete_all
      ProcessPayrollBreakdownByManualClass.delete_all
      ProcessPolicyCombinationLeaseTermination.delete_all
      ProcessPolicyCombineFullTransfer.delete_all
      ProcessPolicyCombinePartialToFullLease.delete_all
      ProcessPolicyCombinePartialTransferNoLease.delete_all
      ProcessPolicyCoverageStatusHistory.delete_all
    if @group_rating.destroy
      redirect_to group_ratings_path, notice: "All files are deleted."
    end
  end


  private

  def group_rating_params
    params.require(:group_rating).permit(:process_representative, :experience_period_lower_date,:experience_period_upper_date, :current_payroll_period_lower_date)
  end
end
