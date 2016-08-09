class WelcomeController < ApplicationController
  def index
    @democs = Democ.all
    @democ_count = Democ.count
    @democ_detail_records = DemocDetailRecord.all
    @democ_detail_records_count = DemocDetailRecord.count
    @mrcl_detail_records = MrclDetailRecord.all
    @mrcl_detail_records_count = MrclDetailRecord.count
    @mremp_employee_experience_policy_level = MrempEmployeeExperiencePolicyLevel.all
    @mremp_employee_experience_policy_level_count = MrempEmployeeExperiencePolicyLevel.count
    @mremp_employee_experience_manual_class_level = MrempEmployeeExperienceManualClassLevel.all
    @mremp_employee_experience_manual_class_level_count = MrempEmployeeExperienceManualClassLevel.count
    @mremp_employee_experience_claim_level = MrempEmployeeExperienceClaimLevel.all
    @mremp_employee_experience_claim_level_count = MrempEmployeeExperienceClaimLevel.count
    @pcomb_detail_records = PcombDetailRecord.all
    @pcomb_detail_records_count = PcombDetailRecord.count
    @phmgn_detail_records = PhmgnDetailRecord.all
    @phmgn_detail_records_count = PhmgnDetailRecord.count
    @sc220_rec1_employer_demographics = Sc220Rec1EmployerDemographic.all
    @sc220_rec1_employer_demographics_count = Sc220Rec1EmployerDemographic.count
    @sc220_rec2_employer_manual_level_payrolls = Sc220Rec2EmployerManualLevelPayroll.all
    @sc220_rec2_employer_manual_level_payrolls_count = Sc220Rec2EmployerManualLevelPayroll.count
    @sc220_rec3_employer_ar_transactions = Sc220Rec3EmployerArTransaction.all
    @sc220_rec3_employer_ar_transactions_count = Sc220Rec3EmployerArTransaction.count
    @sc220_rec4_policy_not_founds = Sc220Rec4PolicyNotFound.all
    @sc220_rec4_policy_not_founds_count = Sc220Rec4PolicyNotFound.count
    @sc230_employer_demographics = Sc230EmployerDemographic.all
    @sc230_employer_demographics_count = Sc230EmployerDemographic.count
    @sc230_claim_medical_payments = Sc230ClaimMedicalPayment.all
    @sc230_claim_medical_payments_count = Sc230ClaimMedicalPayment.count
    @sc230_claim_indemnity_awards = Sc230ClaimIndemnityAward.all
    @sc230_claim_indemnity_awards_count = Sc230ClaimIndemnityAward.count
    @mrcls = Mrcl.all
    @mrcl_count = Mrcl.count
    @mremps = Mremp.all
    @mremp_count = Mremp.count
    @pcombs = Pcomb.all
    @pcomb_count = Pcomb.count
    @phmgns = Phmgn.all
    @phmgn_count = Phmgn.count
    @sc220s = Sc220.all
    @sc220_count = Sc220.count
    @sc230s = Sc230.all
    @sc230_count = Sc230.count

  end

  def import
    time1 = Time.new
    puts "Process Start Time: " + time1.inspect
      Democ.import_file("https://s3.amazonaws.com/grouprating/ARM/DEMOCFILE")
      Mrcl.import_file("https://s3.amazonaws.com/grouprating/ARM/MRCLSFILE")
      Mremp.import_file("https://s3.amazonaws.com/grouprating/ARM/MREMPFILE")
      Pcomb.import_file("https://s3.amazonaws.com/grouprating/ARM/PCOMBFILE")
      Phmgn.import_file("https://s3.amazonaws.com/grouprating/ARM/PHMGNFILE")
      Sc220.import_file("https://s3.amazonaws.com/grouprating/ARM/SC220FILE")
      Sc230.import_file("https://s3.amazonaws.com/grouprating/ARM/SC230FILE")
    redirect_to root_url, notice: "The Democ, Mrcl, Mremp, Pcomb, Phmgn, SC220, and SC230 files have been imported"
    time2 = Time.new
    puts "Process End Time: " + time2.inspect
  end

  def destroy
    @democ_detail_records = DemocDetailRecord.all
    @mrcl_detail_records = MrclDetailRecord.all
    @mremp_employee_experience_policy_level = MrempEmployeeExperiencePolicyLevel.all
    @mremp_employee_experience_manual_class_level = MrempEmployeeExperienceManualClassLevel.all
    @mremp_employee_experience_claim_level = MrempEmployeeExperienceClaimLevel.all
    @pcomb_detail_records = PcombDetailRecord.all
    @phmgn_detail_records = PhmgnDetailRecord.all
    @sc220_rec1_employer_demographics = Sc220Rec1EmployerDemographic.all
    @sc220_rec2_employer_manual_level_payrolls = Sc220Rec2EmployerManualLevelPayroll.all
    @sc220_rec3_employer_ar_transactions = Sc220Rec3EmployerArTransaction.all
    @sc220_rec4_policy_not_founds = Sc220Rec4PolicyNotFound.all
    @sc230_employer_demographics = Sc230EmployerDemographics.all
    @sc230_claim_medical_payments = Sc230ClaimMedicalPayments.all
    @sc230_claim_indemnity_awards = Sc230ClaimIndemnityAwards.all
    @democs = Democ.all
    @mrcls = Mrcl.all
    @mremps = Mremp.all
    @pcombs = Pcomb.all
    @phmgns = Phmgn.all
    @sc220s = Sc220.all
    @sc230s = Sc230.all

    @democs.delete_all
    @mrcls.delete_all
    @mremps.delete_all
    @pcombs.delete_all
    @phmgns.delete_all
    @sc220s.delete_all
    @sc230s.delete_all
    @democ_detail_records.delete_all
    @mrcl_detail_records.delete_all
    @mremp_employee_experience_policy_level.delete_all
    @mremp_employee_experience_manual_class_level.delete_all
    @mremp_employee_experience_claim_level.delete_all
    @pcomb_detail_records.delete_all
    @phmgn_detail_records.delete_all
    @sc220_rec1_employer_demographics.delete_all
    @sc220_rec2_employer_manual_level_payrolls.delete_all
    @sc220_rec3_employer_ar_transactions.delete_all
    @sc220_rec4_policy_not_founds.delete_all
    @sc230_employer_demographics.delete_all
    @sc230_claim_medical_payments.delete_all
    @sc230_claim_indemnity_awards.delete_all

    redirect_to root_url, notice: "All files are deleted."
  end


end
