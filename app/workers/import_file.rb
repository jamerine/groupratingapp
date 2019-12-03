class ImportFile
  include Sidekiq::Worker
  sidekiq_options queue: :import_file, retry: 1

  def perform(url, table_name, import_id, group_rating_id, all_process = nil)
    time1 = Time.new
    puts "Start Time: " + time1.inspect
    conn = ActiveRecord::Base.connection
    rc   = conn.raw_connection
    if table_name == 'rates'
      rc.exec("COPY " + table_name + " (single_rec) FROM STDIN WITH DELIMITER AS '~'")
    else
      rc.exec("COPY " + table_name + " (single_rec) FROM STDIN WITH DELIMITER AS '|'")
    end
    file = open(url)

    while !file.eof?
      # Add row to copy data
      line = file.readline
      if line[40, 4] == "0000"
        #puts "incorrect characters"
      else
        rc.put_copy_data(line)
      end
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
      @import.sc230s_count                       = Sc230.count
      @import.sc230_employer_demographics_count  = Sc230EmployerDemographic.count
      @import.sc230_claim_medical_payments_count = Sc230ClaimMedicalPayment.count
      @import.sc230_claim_indemnity_awards_count = Sc230ClaimIndemnityAward.count
      @import.import_status                      = "#{table_name} Completed"
      # elsif table_name == "sc220s"
      #   @import.sc220s_count = Sc220.count
      #   @import.sc220_rec1_employer_demographics_count = Sc220Rec1EmployerDemographic.count
      #   @import.sc220_rec2_employer_manual_level_payrolls_count = Sc220Rec2EmployerManualLevelPayroll.count
      #   @import.sc220_rec3_employer_ar_transactions_count = Sc220Rec3EmployerArTransaction.count
      #   @import.sc220_rec4_policy_not_founds_count = Sc220Rec4PolicyNotFound.count
      #   @import.import_status = "#{table_name} Completed"
    elsif table_name == "democs"
      @import.democs_count               = Democ.count
      @import.democ_detail_records_count = DemocDetailRecord.count
      @import.import_status              = "#{table_name} Completed"
    elsif table_name == "mrcls"
      @import.mrcls_count               = Mrcl.count
      @import.mrcl_detail_records_count = MrclDetailRecord.count
      @import.import_status             = "#{table_name} Completed"
    elsif table_name == "mremps"
      @import.mremps_count                                        = Mremp.count
      @import.mremp_employee_experience_policy_levels_count       = MrempEmployeeExperiencePolicyLevel.count
      @import.mremp_employee_experience_manual_class_levels_count = MrempEmployeeExperienceManualClassLevel.count
      @import.mremp_employee_experience_claim_levels_count        = MrempEmployeeExperienceClaimLevel.count
      @import.import_status                                       = "#{table_name} Completed"
    elsif table_name == "pcombs"
      @import.pcombs_count               = Pcomb.count
      @import.pcomb_detail_records_count = PcombDetailRecord.count
      @import.import_status              = "#{table_name} Completed"
    elsif table_name == "phmgns"
      @import.phmgns_count               = Phmgn.count
      @import.phmgn_detail_records_count = PhmgnDetailRecord.count
      @import.import_status              = "#{table_name} Completed"
    elsif table_name == "rates"
      @import.rates_count               = Rate.count
      @import.rate_detail_records_count = RateDetailRecord.count
      @import.import_status             = "#{table_name} Completed"
    elsif table_name == "pdemos"
      @import.pdemos_count               = Pdemo.count
      @import.pdemo_detail_records_count = PdemoDetailRecord.count
      @import.import_status              = "#{table_name} Completed"
    elsif table_name == "pemhs"
      @import.pemhs_count               = Pemh.count
      @import.pemh_detail_records_count = PemhDetailRecord.count
      @import.import_status             = "#{table_name} Completed"
    elsif table_name == "pcovgs"
      @import.pcovgs_count               = Pcovg.count
      @import.pcovg_detail_records_count = PcovgDetailRecord.count
      @import.import_status              = "#{table_name} Completed"
    elsif table_name == "miras"
      @import.miras_count               = Mira.count
      @import.mira_detail_records_count = MiraDetailRecord.count
      @import.import_status             = "#{table_name} Completed"
    end

    @import.save

    @import = Import.find_by(id: import_id)
    if (!@import.sc230s_count.nil? || !@import.sc230_employer_demographics_count.nil? || !@import.sc230_claim_medical_payments_count.nil? || !@import.sc230_claim_indemnity_awards_count.nil?) &&
      # (!@import.sc220s_count.nil? || !@import.sc220_rec1_employer_demographics_count.nil? || !@import.sc220_rec2_employer_manual_level_payrolls_count.nil? ||    !@import.sc220_rec3_employer_ar_transactions_count.nil?) &&
      (!@import.democs_count.nil? || !@import.democ_detail_records_count.nil?) &&
      (!@import.mrcls_count.nil? || !@import.mrcl_detail_records_count.nil?) &&
      (!@import.mremps_count.nil? || !@import.mremp_employee_experience_policy_levels_count.nil? || !@import.mremp_employee_experience_manual_class_levels_count.nil? ||
        !@import.mremp_employee_experience_claim_levels_count.nil?) &&
      (!@import.pcombs_count.nil? || !@import.pcomb_detail_records_count.nil?) &&
      (!@import.phmgns_count.nil? || !@import.phmgn_detail_records_count.nil?) &&
      (!@import.rates_count.nil? || !@import.rate_detail_records_count.nil?) &&
      (!@import.pdemos_count.nil? || !@import.pdemo_detail_records_count.nil?) &&
      (!@import.pemhs_count.nil? || !@import.pemh_detail_records_count.nil?) &&
      (!@import.pcovgs_count.nil? || !@import.pcovg_detail_records_count.nil?) &&
      (!@import.miras_count.nil? || !@import.mira_detail_records_count.nil?)

      @import.import_status = "Completed"
      @import.save
      @group_rating = GroupRating.find(group_rating_id)
      #GroupRatingStepOne.perform_async("1", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date, @group_rating.current_payroll_period_upper_date, @group_rating.id, all_process)
    end


    time2 = Time.new
    puts "End Time: " + time2.inspect
  end
end
