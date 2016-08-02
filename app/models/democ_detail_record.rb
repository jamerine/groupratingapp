class DemocDetailRecord < ActiveRecord::Base
  require 'activerecord-import'

  def self.parse_table
    time1 = Time.new
    puts "Start Time: " + time1.inspect
    Democ.transaction do
      democ_detail_records = []
      Democ.all.each do |row|
        if row.single_rec.slice(9,2) == "02"
          row_hash = {}
          row_hash = { :representative_number => row.single_rec.slice(0,6).to_i,
              :representative_type => row.single_rec.slice(7,2).to_i,
              :record_type => row.single_rec.slice(9,2).to_i,
              :requestor_number => row.single_rec.slice(11,3).to_i,
              :policy_type => row.single_rec.slice(14,1).to_i,
              :policy_number => row.single_rec.slice(15,7).to_i,
              :business_sequence_number => row.single_rec.slice(23,3).to_i,
              :valid_policy_number => row.single_rec.slice(26,1).to_s,
              :current_policy_status => row.single_rec.slice(27,5).to_s,
              :current_policy_status_effective_date => row.single_rec.slice(32,8).to_date,
              :policy_year => row.single_rec.slice(40,4).to_i,
              :policy_year_rating_plan => row.single_rec.slice(44,5).to_s,
              :claim_indicator => row.single_rec.slice(49,1).to_s,
              :claim_number => row.single_rec.slice(50,10).to_s,
              :claim_injury_date => row.single_rec.slice(60,8).to_date,
              :claim_combined => row.single_rec.slice(68,1).to_s,
              :combined_into_claim_number => row.single_rec.slice(69,10).to_s,
              :claim_rating_plan_indicator => row.single_rec.slice(79,1).to_s,
              :claim_status => row.single_rec.slice(80,2).to_s,
              :claim_status_effective_date => row.single_rec.slice(82,8).to_date,
              :claim_manual_number => row.single_rec.slice(110,4).to_i,
              :claim_sub_manual_number => row.single_rec.slice(114,2).to_i,
              :claim_type => row.single_rec.slice(116,4).to_i,
              :claimant_date_of_death => row.single_rec.slice(128,8).to_date,
              :claim_activity_status => row.single_rec.slice(136,1).to_s,
              :claim_activity_status_effective_date => row.single_rec.slice(137,8).to_date,
              :settled_claim => row.single_rec.slice(145,1).to_s,
              :settlement_type => row.single_rec.slice(146,1).to_s,
              :medical_settlement_date => row.single_rec.slice(147,8).to_date,
              :indemnity_settlement_date => row.single_rec.slice(155,8).to_date,
              :maximum_medical_improvement_date => row.single_rec.slice(163,8).to_date,
              :last_paid_medical_date => row.single_rec.slice(171,8).to_date,
              :last_paid_indemnity_date => row.single_rec.slice(179,8).to_date,
              :average_weekly_wage => row.single_rec.slice(187,8).to_f,
              :full_weekly_wage => row.single_rec.slice(195,8).to_f,
              :claim_handicap_percent => row.single_rec.slice(203,3).to_f,
              :claim_handicap_percent_effective_date => row.single_rec.slice(206,8).to_date,
              :claim_mira_ncci_injury_type => row.single_rec.slice(214,2).to_s,
              :claim_medical_paid => row.single_rec.slice(216,7).to_i,
              :claim_mira_medical_reserve_amount => row.single_rec.slice(224,7).to_i,
              :claim_mira_non_reducible_indemnity_paid => row.single_rec.slice(232,7).to_i,
              :claim_mira_reducible_indemnity_paid => row.single_rec.slice(240,7).to_i,
              :claim_mira_indemnity_reserve_amount => row.single_rec.slice(248,7).to_i,
              :industrial_commission_appeal_indicator => row.single_rec.slice(256,1).to_s,
              :claim_mira_non_reducible_indemnity_paid_2 => row.single_rec.slice(257,7).to_i,
              :claim_total_subrogation_collected => row.single_rec.slice(265,7).to_i }
          democ_detail_records << DemocDetailRecord.new(row_hash)
        end

      end
        DemocDetailRecord.import democ_detail_records

    end
    time2 = Time.new
    puts "End Time: " + time2.inspect
  end
end
