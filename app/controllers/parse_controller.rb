class ParseController < ApplicationController
  def index
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
  end

  def create
    time1 = Time.new
    Sc220Rec1EmployerDemographic.parse_table
    # DemocDetailRecord.parse_table
    # MrclDetailRecord.parse_table
    # MrempEmployeeExperiencePolicyLevel.parse_table
    # PcombDetailRecord.parse_table
    # PhmgnDetailRecord.parse_table
    # Sc230EmployerDemographic.parse_table

    redirect_to parse_index_path, notice: "The Democ, Mrcl, Mremp, Pcomb, Phmgn, SC220, and SC230 files have been parsed into seperate tables"
    time2 = Time.new
    puts 'Completed Parse Process in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end

  def destroy
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
    redirect_to parse_index_path, notice: "All files are deleted."
  end
end
