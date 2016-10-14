class GroupRatingsController < ApplicationController

  def index
    @group_ratings = GroupRating.all
    @representatives = Representative.all
  end

  def show
    @group_rating = GroupRating.find(params[:id])
    @representative = Representative.find(@group_rating.representative_id)
    @import = Import.find_by(group_rating_id: @group_rating.id)
  end

  def new
    @group_rating = GroupRating.new
    @representatives = Representative.all
  end

  def create
    @group_rating = GroupRating.new(group_rating_params)
    @representative = Representative.find(@group_rating.representative_id)
    @group_rating.process_representative = @representative.representative_number
    @group_rating.status = 'Queuing'
    if @group_rating.save
      @import = Import.new(process_representative: @group_rating.process_representative, representative_id: @group_rating.representative_id, group_rating_id: @group_rating.id)
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


          ImportProcess.perform_async(@import.process_representative, @import.id, @representative.abbreviated_name, @group_rating.id)

          redirect_to group_ratings_path, notice: "Step 1, Step 2, Step 3, Step 4, Step 5, Step 6, Step 7, Step 8 have been queued."
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
    params.require(:group_rating).permit(:process_representative, :experience_period_lower_date,:experience_period_upper_date, :current_payroll_period_lower_date, :representative_id)
  end
end
