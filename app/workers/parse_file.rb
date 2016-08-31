class ParseFile
  include Sidekiq::Worker
  sidekiq_options :queue => :parse_file


  def perform(table_name, import_id)
    result = ActiveRecord::Base.connection.execute("SELECT public.proc_process_flat_" + table_name + "()")
    result.clear
    @import = Import.find_by(id: import_id)
      if table_name == "sc220"
        @import.parse_status = "#{table_name.capitalize} Parse Completed"
        @import.sc220_rec1_employer_demographics_count = Sc220Rec1EmployerDemographic.count
        @import.sc220_rec2_employer_manual_level_payrolls_count = Sc220Rec2EmployerManualLevelPayroll.count
        @import.sc220_rec3_employer_ar_transactions_count = Sc220Rec3EmployerArTransaction.count
        @import.sc220_rec4_policy_not_founds_count = Sc220Rec4PolicyNotFound.count
      elsif table_name == "democ"
        @import.parse_status = "#{table_name.capitalize} Parse Completed"
        @import.democ_detail_records_count = DemocDetailRecord.count
      elsif table_name == "mrcls"
        @import.parse_status = "#{table_name.capitalize} Parse Completed"
        @import.mrcl_detail_records_count = MrclDetailRecord.count
      elsif table_name == "mremp"
        @import.parse_status = "#{table_name.capitalize} Parse Completed"
        @import.mremp_employee_experience_policy_levels_count = MrempEmployeeExperiencePolicyLevel.count
        @import.mremp_employee_experience_manual_class_levels_count = MrempEmployeeExperienceManualClassLevel.count
        @import.mremp_employee_experience_claim_levels_count = MrempEmployeeExperienceClaimLevel.count
      elsif table_name == "pcomb"
        @import.parse_status = "#{table_name.capitalize} Parse Completed"
        @import.pcomb_detail_records_count = PcombDetailRecord.count
      elsif table_name == "phmgn"
        @import.parse_status = "#{table_name.capitalize} Parse Completed"
        @import.phmgn_detail_records_count = PhmgnDetailRecord.count
      elsif table_name == "sc230"
        @import.parse_status = "Completed"
        @import.sc230_employer_demographics_count = Sc230EmployerDemographic.count
        @import.sc230_claim_medical_payments_count = Sc230ClaimMedicalPayment.count
        @import.sc230_claim_indemnity_awards_count = Sc230ClaimIndemnityAward.count
      else
        @import.parse_status = "#{table_name.capitalize} Parse Completed"
      end
    @import.save
  end
end
