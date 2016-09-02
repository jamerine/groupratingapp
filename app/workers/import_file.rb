class ImportFile
  include Sidekiq::Worker
  sidekiq_options queue: :import_file

  def perform(url, table_name, import_id)
    time1 = Time.new
    puts "Start Time: " + time1.inspect
      conn = ActiveRecord::Base.connection
      rc = conn.raw_connection
      rc.exec("COPY " + table_name + " (single_rec) FROM STDIN WITH DELIMITER AS '|'")

      file = open(url)
      while !file.eof?
        # Add row to copy data
        rc.put_copy_data(file.readline)
      end
      # We are done adding copy data
      rc.put_copy_end
      # Display any error messages
      while res = rc.get_result
        if e_message = res.error_message
          p e_message
        end
      end
      result = ActiveRecord::Base.connection.execute("SELECT public.proc_process_flat_" + table_name + "()")
      result.clear
      @import = Import.find_by(id: import_id)
      if table_name == "sc230s"
        @import.sc230s_count = Sc230.count
        @import.sc230_employer_demographics_count = Sc230EmployerDemographic.count
        @import.sc230_claim_medical_payments_count = Sc230ClaimMedicalPayment.count
        @import.sc230_claim_indemnity_awards_count = Sc230ClaimIndemnityAward.count
        @import.import_status = "#{table_name} Completed"
      elsif table_name == "sc220s"
        @import.sc220s_count = Sc220.count
        @import.sc220_rec1_employer_demographics_count = Sc220Rec1EmployerDemographic.count
        @import.sc220_rec2_employer_manual_level_payrolls_count = Sc220Rec2EmployerManualLevelPayroll.count
        @import.sc220_rec3_employer_ar_transactions_count = Sc220Rec3EmployerArTransaction.count
        @import.sc220_rec4_policy_not_founds_count = Sc220Rec4PolicyNotFound.count
        @import.import_status = "#{table_name} Completed"
      elsif table_name == "democs"
        @import.democs_count = Democ.count
        @import.democ_detail_records_count = DemocDetailRecord.count
        @import.import_status = "#{table_name} Completed"
      elsif table_name == "mrcls"
        @import.mrcls_count = Mrcl.count
        @import.mrcl_detail_records_count = MrclDetailRecord.count
        @import.import_status = "#{table_name} Completed"
      elsif table_name == "mremps"
        @import.mremps_count = Mremp.count
        @import.mremp_employee_experience_policy_levels_count = MrempEmployeeExperiencePolicyLevel.count
        @import.mremp_employee_experience_manual_class_levels_count = MrempEmployeeExperienceManualClassLevel.count
        @import.mremp_employee_experience_claim_levels_count = MrempEmployeeExperienceClaimLevel.count
        @import.import_status = "#{table_name} Completed"
      elsif table_name == "pcombs"
        @import.pcombs_count = Pcomb.count
        @import.pcomb_detail_records_count = PcombDetailRecord.count
        @import.import_status = "#{table_name} Completed"
      elsif table_name == "phmgns"
        @import.phmgns_count = Phmgn.count
        @import.phmgn_detail_records_count = PhmgnDetailRecord.count
        @import.import_status = "#{table_name} Completed"
      end
      @import.save


      time2 = Time.new
      puts "End Time: " + time2.inspect
  end
end
