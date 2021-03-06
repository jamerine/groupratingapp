class ImportProcess
  include Sidekiq::Worker
  sidekiq_options queue: :import_process, retry: 3

  def perform(representative_number, import_id, representative_abbreviated_name, group_rating_id, import_only, all_process = nil)
    Democ.delete_all
    DemocDetailRecord.delete_all
    Mrcl.delete_all
    MrclDetailRecord.delete_all
    Mremp.delete_all
    MrempEmployeeExperiencePolicyLevel.delete_all
    MrempEmployeeExperienceManualClassLevel.delete_all
    MrempEmployeeExperienceClaimLevel.delete_all
    Pcomb.delete_all
    PcombDetailRecord.delete_all
    Phmgn.delete_all
    PhmgnDetailRecord.delete_all
    Sc220.delete_all
    Sc220Rec1EmployerDemographic.delete_all
    Sc220Rec2EmployerManualLevelPayroll.delete_all
    Sc220Rec3EmployerArTransaction.delete_all
    Sc220Rec4PolicyNotFound.delete_all
    Sc230.delete_all
    Sc230EmployerDemographic.delete_all
    Sc230ClaimMedicalPayment.delete_all
    Sc230ClaimIndemnityAward.delete_all
    Rate.delete_all
    RateDetailRecord.delete_all
    Pdemo.delete_all
    PdemoDetailRecord.delete_all
    Pemh.delete_all
    PemhDetailRecord.delete_all
    Pcovg.delete_all
    PcovgDetailRecord.delete_all

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

    ImportFile.perform_async("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/DEMOCFILE", "democs", import_id, group_rating_id, all_process, import_only)
    ImportFile.perform_async("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/MRCLSFILE", "mrcls", import_id, group_rating_id, all_process, import_only)
    ImportFile.perform_async("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/MREMPFILE", "mremps", import_id, group_rating_id, all_process, import_only)
    ImportFile.perform_async("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/PCOMBFILE", "pcombs", import_id, group_rating_id, all_process, import_only)
    ImportFile.perform_async("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/PHMGNFILE", "phmgns", import_id, group_rating_id, all_process, import_only)
    # ImportFile.perform_async("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/SC220FILE", "sc220s", import_id, group_rating_id)
    ImportFile.perform_async("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/SC230FILE", "sc230s", import_id, group_rating_id, all_process, import_only)
    ImportFile.perform_async("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/RATEFILE", "rates", import_id, group_rating_id, all_process, import_only)
    ImportFile.perform_async("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/PDEMOFILE", "pdemos", import_id, group_rating_id, all_process, import_only)
    ImportFile.perform_async("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/PEMHSFILE", "pemhs", import_id, group_rating_id, all_process, import_only)
    ImportFile.perform_async("https://s3.amazonaws.com/piarm/#{representative_abbreviated_name}/PCOVGFILE", "pcovgs", import_id, group_rating_id, all_process, import_only)
  end
end
