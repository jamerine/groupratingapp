class CreateProcessSc220Proc < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION public.proc_process_flat_sc220s()
  RETURNS void AS
$BODY$

BEGIN

/*****************************************************************************/
-- START OF SC220


-- Create Rec Type 1 table


Insert Into sc220_rec1_employer_demographics (
          representative_number,
          representative_type,
          description_ar,
          record_type,
          request_type,
          policy_type,
          policy_number,
          business_sequence_number,
          federal_identification_number,
          business_name,
          trading_as_name,
          in_care_name_contact_name,
          address_1,
          address_2,
          city,
          state,
          zip_code,
          zip_code_plus_4,
          country_code,
          county,
          currently_assigned_representative_number,
          currently_assigned_representative_type,
          successor_policy_number,
          successor_business_sequence_number,
          merit_rate,
          group_code,
          minimum_premium_percentage,
          rate_adjust_factor,
          em_effective_date,
          n2nd_merit_rate,
          n2nd_group_code,
          n2nd_minimum_premium_percentage,
          n2nd_rate_adjust_factor,
          n2nd_em_effective_date,
          n3rd_merit_rate,
          n3rd_group_code,
          n3rd_minimum_premium_percentage,
          n3rd_rate_adjust_factor,
          n3rd_em_effective_date,
          n4th_merit_rate,
          n4th_group_code,
          n4th_minimum_premium_percentage,
          n4th_rate_adjust_factor,
          n4th_em_effective_date,
          n5th_merit_rate,
          n5th_group_code,
          n5th_minimum_premium_percentage,
          n5th_rate_adjust_factor,
          n5th_em_effective_date,
          n6th_merit_rate,
          n6th_group_code,
          n6th_minimum_premium_percentage,
          n6th_rate_adjust_factor,
          n6th_em_effective_date,
          n7th_merit_rate,
          n7th_group_code,
          n7th_minimum_premium_percentage,
          n7th_rate_adjust_factor,
          n7th_em_effective_date,
          n8th_merit_rate,
          n8th_group_code,
          n8th_minimum_premium_percentage,
          n8th_rate_adjust_factor,
          n8th_em_effective_date,
          n9th_merit_rate,
          n9th_group_code,
          n9th_minimum_premium_percentage,
          n9th_rate_adjust_factor,
          n9th_em_effective_date,
          n10th_merit_rate,
          n10th_group_code,
          n10th_minimum_premium_percentage,
          n10th_rate_adjust_factor,
          n10th_em_effective_date,
          n11th_merit_rate,
          n11th_group_code,
          n11th_minimum_premium_percentage,
          n11th_rate_adjust_factor,
          n11th_em_effective_date,
          n12th_merit_rate,
          n12th_group_code,
          n12th_minimum_premium_percentage,
          n12th_rate_adjust_factor,
          n12th_em_effective_date,
          coverage_status,
          coverage_effective_date,
          coverage_end_date,
          n2nd_coverage_status,
          n2nd_coverage_effective_date,
          n2nd_coverage_end_date,
          n3rd_coverage_status,
          n3rd_coverage_effective_date,
          n3rd_coverage_end_date,
          n4th_coverage_status,
          n4th_coverage_effective_date,
          n4th_coverage_end_date,
          n5th_coverage_status,
          n5th_coverage_effective_date,
          n5th_coverage_end_date,
          n6th_coverage_status,
          n6th_coverage_effective_date,
          n6th_coverage_end_date,
          regular_balance_amount,
          attorney_general_balance_amount,
          appealed_balance_amount,
          pending_balance_amount,
          advance_deposit_amount,
          created_at,
          updated_at
)
(select
    cast_to_int(substring(single_rec,1,6)),        -- representative_number char(6),
          cast_to_int(substring(single_rec,7,2)),      -- representative_type char(2),
          substring(single_rec,9,2),      -- description_ar char(2),
          cast_to_int(substring(single_rec,11,1)),     -- record_type char(1),
          cast_to_int(substring(single_rec,12,3)),     -- request_type char(3),
          cast_to_int(substring(single_rec,15,1)),     -- policy_type char(1),
          cast_to_int(substring(single_rec,16,7)),     -- policy_number char(7),
          cast_to_int(substring(single_rec,23,3)),     -- business_sequence_number char(3),
          substring(single_rec,26,11),    -- federal_identification_number numeric,
          substring(single_rec,37,40),    -- business_name char(40),
          substring(single_rec,77,40),    -- trading_as_name char(40),
          substring(single_rec,117,40),   -- in_care_name_contact_name char(40),
          substring(single_rec,157,40),   -- address_1 char(40),
          substring(single_rec,197,40),   -- address_2 char(40),
          substring(single_rec,237,30),   -- city char(30),
          substring(single_rec,267,2),    -- state char(2),
          substring(single_rec,269,5),    -- zip_code char(5),
          substring(single_rec,274,4),    -- zip_code_plus_4 char(4),
          substring(single_rec,278,3),    -- country_code char(3),
          substring(single_rec,281,5),    -- county char(5),
          cast_to_int(substring(single_rec,286,6)) ,    -- currently_assigned_representative_number char(6),
          substring(single_rec,292,2),    -- currently_assigned_representative_type char(2),
          cast_to_int(substring(single_rec,294,8)),    -- successor_policy_number numeric(8,2),
          cast_to_int(substring(single_rec,302,3)),    -- successor_business_sequence_number char(3),
          substring(single_rec,305,6)::numeric/1000,    -- merit_rate char(6),
          substring(single_rec,311,5),    -- group_code char(5),
          substring(single_rec,316,4),    -- minimum_premium_percentage char(4),
          substring(single_rec,320,4),    -- rate_adjust_factor char(4),
          case when substring(single_rec,324,8) > '00000000' THEN to_date(substring(single_rec,324,8), 'MMDDYYYY')
            else null
          end,   -- em_effective_date date,
          substring(single_rec,332,6)::numeric/1000,    -- n2nd_merit_rate char(6),
          substring(single_rec,338,5),    -- n2nd_group_code char(5),
          substring(single_rec,343,4),    -- n2nd_minimum_premium_percentage char(4),
          substring(single_rec,347,4),    -- n2nd_rate_adjust_factor char(4),
          case when substring(single_rec,351,8) > '00000000' THEN to_date(substring(single_rec,351,8), 'MMDDYYYY')
            else null
          end,    -- n2nd_em_effective_date date,
          substring(single_rec,359,6)::numeric/1000,    -- n3rd_merit_rate char(6),
          substring(single_rec,365,5),    -- n3rd_group_code char(5),
          substring(single_rec,370,4),    -- n3rd_minimum_premium_percentage char(4),
          substring(single_rec,374,4),    -- n3rd_rate_adjust_factor char(4),
          case when substring(single_rec,378,8) > '00000000' THEN to_date(substring(single_rec,378,8), 'MMDDYYYY')
            else null
          end,    -- n3rd_em_effective_date date,
          substring(single_rec,386,6)::numeric/1000,    -- n4th_merit_rate char(6),
          substring(single_rec,392,5),    -- n4th_group_code char(5),
          substring(single_rec,397,4),    -- n4th_minimum_premium_percentage char(4),
          substring(single_rec,401,4),    -- n4th_rate_adjust_factor char(4),
          case when substring(single_rec,405,8) > '00000000' THEN to_date(substring(single_rec,405,8), 'MMDDYYYY')
            else null
          end,      -- n4th_em_effective_date date,
          substring(single_rec,413,6)::numeric/1000,    -- n5th_merit_rate char(6),
          substring(single_rec,419,5),    -- n5th_group_code char(5),
          substring(single_rec,424,4),    -- n5th_minimum_premium_percentage char(4),
          substring(single_rec,428,4),    -- n5th_rate_adjust_factor char(4),
          case when substring(single_rec,432,8) > '00000000' THEN to_date(substring(single_rec,432,8), 'MMDDYYYY')
            else null
          end,      -- n5th_em_effective_date date,
          substring(single_rec,440,6)::numeric/1000,    -- n6th_merit_rate char(6),
          substring(single_rec,446,5),    -- n6th_group_code char(5),
          substring(single_rec,451,4),    -- n6th_minimum_premium_percentage char(4),
          substring(single_rec,455,4),    -- n6th_rate_adjust_factor char(4),
          case when substring(single_rec,459,8) > '00000000' THEN to_date(substring(single_rec,459,8), 'MMDDYYYY')
            else null
          end,      -- n6th_em_effective_date date,
          substring(single_rec,467,6)::numeric/1000,    -- n7th_merit_rate char(6),
          substring(single_rec,473,5),    -- n7th_group_code char(5),
          substring(single_rec,478,4),    -- n7th_minimum_premium_percentage char(4),
          substring(single_rec,482,4),    -- n7th_rate_adjust_factor char(4),
          case when substring(single_rec,486,8) > '00000000' THEN to_date(substring(single_rec,486,8), 'MMDDYYYY')
            else null
          end,      -- n7th_em_effective_date date,
          substring(single_rec,494,6)::numeric/1000,    -- n8th_merit_rate char(6),
          substring(single_rec,500,5),    -- n8th_group_code char(5),
          substring(single_rec,505,4),    -- n8th_minimum_premium_percentage char(4),
          substring(single_rec,509,4),    -- n8th_rate_adjust_factor char(4),
          case when substring(single_rec,513,8) > '00000000' THEN to_date(substring(single_rec,513,8), 'MMDDYYYY')
            else null
          end,      -- n8th_em_effective_date date,
          substring(single_rec,521,6)::numeric/1000,    -- n9th_merit_rate char(6),
          substring(single_rec,527,5),    -- n9th_group_code char(5),
          substring(single_rec,532,4),    -- n9th_minimum_premium_percentage char(4),
          substring(single_rec,536,4),    -- n9th_rate_adjust_factor char(4),
          case when substring(single_rec,540,8) > '00000000' THEN to_date(substring(single_rec,540,8), 'MMDDYYYY')
            else null
          end,      -- n9th_em_effective_date date,
          substring(single_rec,548,6)::numeric/1000,    -- n10th_merit_rate char(6),
          substring(single_rec,554,5),    -- n10th_group_code char(5),
          substring(single_rec,559,4),    -- n10th_minimum_premium_percentage char(4),
          substring(single_rec,563,4),    -- n10th_rate_adjust_factor char(4),
          case when substring(single_rec,567,8) > '00000000' THEN to_date(substring(single_rec,567,8), 'MMDDYYYY')
            else null
          end,      -- n10th_em_effective_date date,
          substring(single_rec,575,6)::numeric/1000,    -- n11th_merit_rate char(6),
          substring(single_rec,581,5),    -- n11th_group_code char(5),
          substring(single_rec,586,4),    -- n11th_minimum_premium_percentage char(4),
          substring(single_rec,590,4),    -- n11th_rate_adjust_factor char(4),
          case when substring(single_rec,594,8) > '00000000' THEN to_date(substring(single_rec,594,8), 'MMDDYYYY')
            else null
          end,      -- n11th_em_effective_date date,
          substring(single_rec,602,6)::numeric/1000,    -- n12th_merit_rate char(6),
          substring(single_rec,608,5),    -- n12th_group_code char(5),
          substring(single_rec,613,4),    -- n12th_minimum_premium_percentage char(4),
          substring(single_rec,617,4),    -- n12th_rate_adjust_factor char(4),
          case when substring(single_rec,621,8) > '00000000' THEN to_date(substring(single_rec,621,8), 'MMDDYYYY')
            else null
          end,      -- n12th_em_effective_date date,
          substring(single_rec,629,5),    -- coverage_status char(5),
          case when substring(single_rec,634,8) > '00000000' THEN to_date(substring(single_rec,634,8), 'MMDDYYYY')          else null
          end,     -- coverage_effective_date date,
          case when substring(single_rec,642,8) > '00000000' THEN to_date(substring(single_rec,642,8), 'MMDDYYYY')
            else null
          end,            -- coverage_end_date date,
          substring(single_rec,650,5),    -- n2nd_coverage_status char(5),
          case when substring(single_rec,655,8) > '00000000' THEN to_date(substring(single_rec,655,8), 'MMDDYYYY')
            else null
          end,             -- n2nd_coverage_effective_date date,
          case when substring(single_rec,663,8) > '00000000' THEN to_date(substring(single_rec,663,8), 'MMDDYYYY')
            else null
          end,    -- n2nd_coverage_end_date date,
          substring(single_rec,671,5),    -- n3rd_coverage_status char(5),
          case when substring(single_rec,676,8) > '00000000' THEN to_date(substring(single_rec,676,8), 'MMDDYYYY')
            else null
          end,    -- n3rd_coverage_effective_date date,
          case when substring(single_rec,684,8) > '00000000' THEN to_date(substring(single_rec,684,8), 'MMDDYYYY')
            else null
          end,    -- n3rd_coverage_end_datedate,
          substring(single_rec,692,5),    -- n4th_coverage_status char(5),
          case when substring(single_rec,697,8) > '00000000' THEN to_date(substring(single_rec,697,8), 'MMDDYYYY')
            else null
          end,    -- n4th_coverage_effective_date date,
          case when substring(single_rec,705,8) > '00000000' THEN to_date(substring(single_rec,705,8), 'MMDDYYYY')
            else null
          end,    -- n4th_coverage_end_date date,
          substring(single_rec,713,5),    -- n5th_coverage_status char(5),
          case when substring(single_rec,718,8) > '00000000' THEN to_date(substring(single_rec,718,8), 'MMDDYYYY')
            else null
          end,    -- n5th_coverage_effective_date date,
          case when substring(single_rec,726,8) > '00000000' THEN to_date(substring(single_rec,726,8), 'MMDDYYYY')
            else null
          end,    -- n5th_coverage_end_date date,
          substring(single_rec,734,5),    -- n6th_coverage_status char(5),
          case when substring(single_rec,739,8) > '00000000' THEN to_date(substring(single_rec,739,8), 'MMDDYYYY')
            else null
          end,    -- n6th_coverage_effective_date date,
          case when substring(single_rec,747,8) > '00000000' THEN to_date(substring(single_rec,747,8), 'MMDDYYYY')
            else null
          end,    -- n6th_coverage_end_date date,
          cast_to_int(substring(single_rec,755,12)),   -- regular_balance_amount char(13),
          cast_to_int(substring(single_rec,768,12)),   -- attorney_general_balance_amount char(13),
          cast_to_int(substring(single_rec,781,12)),   -- appealed_balance_amount char(13),
          cast_to_int(substring(single_rec,794,12)),   -- pending_balance_amount char(13),
          cast_to_int(substring(single_rec,807,10)),   -- advance_deposit_amount numeric
          current_timestamp::timestamp as created_at,
          current_timestamp::timestamp as updated_at
from sc220s where substring(single_rec,11,1) = '1');



Insert Into sc220_rec2_employer_manual_level_payrolls
         (representative_number,
          representative_type,
          description_ar,
          record_type,
          request_type,
          policy_type,
          policy_number,
          business_sequence_number,
          manual_number,
          manual_type,
          year_to_date_payroll,
          manual_class_rate,
          year_to_date_premium_billed,
          manual_effective_date,
          n2nd_year_to_date_payroll,
          n2nd_manual_class_rate,
          n2nd_year_to_date_premium_billed,
          n2nd_manual_effective_date,
          n3rd_year_to_date_payroll,
          n3rd_manual_class_rate,
          n3rd_year_to_date_premium_billed,
          n3rd_manual_effective_date,
          n4th_year_to_date_payroll,
          n4th_manual_class_rate,
          n4th_year_to_date_premium_billed,
          n4th_manual_effective_date,
          n5th_year_to_date_payroll,
          n5th_manual_class_rate,
          n5th_year_to_date_premium_billed,
          n5th_manual_effective_date,
          n6th_year_to_date_payroll,
          n6th_manual_class_rate,
          n6th_year_to_date_premium_billed,
          n6th_manual_effective_date,
          n7th_year_to_date_payroll,
          n7th_manual_class_rate,
          n7th_year_to_date_premium_billed,
          n7th_manual_effective_date,
          n8th_year_to_date_payroll,
          n8th_manual_class_rate,
          n8th_year_to_date_premium_billed,
          n8th_manual_effective_date,
          n9th_year_to_date_payroll,
          n9th_manual_class_rate,
          n9th_year_to_date_premium_billed,
          n9th_manual_effective_date,
          n10th_year_to_date_payroll,
          n10th_manual_class_rate,
          n10th_year_to_date_premium_billed,
          n10th_manual_effective_date,
          n11th_year_to_date_payroll,
          n11th_manual_class_rate,
          n11th_year_to_date_premium_billed,
          n11th_manual_effective_date,
          n12th_year_to_date_payroll,
          n12th_manual_class_rate,
          n12th_year_to_date_premium_billed,
          n12th_manual_effective_date,
          created_at,
          updated_at
 )
 (select  cast_to_int(substring(single_rec,1,6)),       -- representative_number
          cast_to_int(substring(single_rec,7,2)),       -- representative_type
          substring(single_rec,9,2),       -- description_ar
          cast_to_int(substring(single_rec,11,1)),      -- record_type
          cast_to_int(substring(single_rec,12,3)),      -- request_type
          cast_to_int(substring(single_rec,15,1)),      -- policy_type
          cast_to_int(substring(single_rec,16,7)),      -- policy_number
          cast_to_int(substring(single_rec,23,3)),      -- business_sequence_number
          cast_to_int(substring(single_rec,26,6)),      -- manual_number
          substring(single_rec,32,2),      -- manual_type
          substring(single_rec,34,11)::numeric/100,     -- year_to_date_payroll
          substring(single_rec,46,8)::numeric/10000,      -- manual_class_rate
          substring(single_rec,55,11)::numeric/100,     -- year_to_date_premium_billed
          case when substring(single_rec,67,8) > '00000000' THEN to_date(substring(single_rec,67,8), 'MMDDYYYY')
            else null
          end,      -- manual_effective_date
          substring(single_rec,75,11)::numeric/100,     -- n2nd_year_to_date_payroll
          substring(single_rec,87,8)::numeric/10000,      -- n2nd_manual_class_rate
          substring(single_rec,96,11)::numeric/100,     -- n2nd_year_to_date_premium_billed
          case when substring(single_rec,108,8) > '00000000' THEN to_date(substring(single_rec,108,8), 'MMDDYYYY')
            else null
          end,     -- n2nd_manual_effective_date
          substring(single_rec,116,11)::numeric/100,    -- n3rd_year_to_date_payroll
          substring(single_rec,128,8)::numeric/10000,     -- n3rd_manual_class_rate
          substring(single_rec,137,11)::numeric/100,    -- n3rd_year_to_date_premium_billed
          case when substring(single_rec,149,8) > '00000000' THEN to_date(substring(single_rec,149,8), 'MMDDYYYY')
            else null
          end,     -- n3rd_manual_effective_date
          substring(single_rec,157,11)::numeric/100,    -- n4th_year_to_date_payroll
          substring(single_rec,169,8)::numeric/10000,     -- n4th_manual_class_rate
          substring(single_rec,178,11)::numeric/100,    -- n4th_year_to_date_premium_billed
          case when substring(single_rec,190,8) > '00000000' THEN to_date(substring(single_rec,190,8), 'MMDDYYYY')
            else null
          end,     -- n4th_manual_effective_date
          substring(single_rec,198,11)::numeric/100,    -- n5th_year_to_date_payroll
          substring(single_rec,210,8)::numeric/10000,     -- n5th_manual_class_rate
          substring(single_rec,219,11)::numeric/100,    -- n5th_year_to_date_premium_billed
          case when substring(single_rec,231,8) > '00000000' THEN to_date(substring(single_rec,231,8), 'MMDDYYYY')
            else null
          end,     -- n5th_manual_effective_date
          substring(single_rec,239,11)::numeric/100,    -- n6th_year_to_date_payroll
          substring(single_rec,251,8)::numeric/10000,     -- n6th_manual_class_rate
          substring(single_rec,260,11)::numeric/100,    -- n6th_year_to_date_premium_billed
          case when substring(single_rec,272,8) > '00000000' THEN to_date(substring(single_rec,272,8), 'MMDDYYYY')
            else null
          end,     -- n6th_manual_effective_date
          substring(single_rec,280,11)::numeric/100,    -- n7th_year_to_date_payroll
          substring(single_rec,292,8)::numeric/10000,     -- n7th_manual_class_rate
          substring(single_rec,301,11)::numeric/100,    -- n7th_year_to_date_premium_billed
          case when substring(single_rec,313,8) > '00000000' THEN to_date(substring(single_rec,313,8), 'MMDDYYYY')
            else null
          end,     -- n7th_manual_effective_date
          substring(single_rec,321,11)::numeric/100,    -- n8th_year_to_date_payroll
          substring(single_rec,333,8)::numeric/10000,     -- n8th_manual_class_rate
          substring(single_rec,342,11)::numeric/100,    -- n8th_year_to_date_premium_billed
          case when substring(single_rec,354,8) > '00000000' THEN to_date(substring(single_rec,354,8), 'MMDDYYYY')
            else null
          end,     -- n8th_manual_effective_date
          substring(single_rec,362,11)::numeric/100,    -- n9th_year_to_date_payroll
          substring(single_rec,374,8)::numeric/10000,     -- n9th_manual_class_rate
          substring(single_rec,383,11)::numeric/100,    -- n9th_year_to_date_premium_billed
          case when substring(single_rec,395,8) > '00000000' THEN to_date(substring(single_rec,395,8), 'MMDDYYYY')
            else null
          end,     -- n9th_manual_effective_date
          substring(single_rec,403,11)::numeric/100,    -- n10th_year_to_date_payroll
          substring(single_rec,415,8)::numeric/10000,     -- n10th_manual_class_rate
          substring(single_rec,424,11)::numeric/100,    -- n10th_year_to_date_premium_billed
          case when substring(single_rec,436,8) > '00000000' THEN to_date(substring(single_rec,436,8), 'MMDDYYYY')
            else null
          end,     -- n10th_manual_effective_date
          substring(single_rec,444,11)::numeric/100,    -- n11th_year_to_date_payroll
          substring(single_rec,456,8)::numeric/10000,     -- n11th_manual_class_rate
          substring(single_rec,465,11)::numeric/100,    -- n11th_year_to_date_premium_billed
          case when substring(single_rec,477,8) > '00000000' THEN to_date(substring(single_rec,477,8), 'MMDDYYYY')
            else null
          end,     -- n11th_manual_effective_date
          substring(single_rec,485,11)::numeric/100,    -- n12th_year_to_date_payroll
          substring(single_rec,497,8)::numeric/10000,     -- n12th_manual_class_rate
          substring(single_rec,506,11)::numeric/100,    -- n12th_year_to_date_premium_billed
          case when substring(single_rec,518,8) > '00000000' THEN to_date(substring(single_rec,518,8), 'MMDDYYYY')
            else null
          end,     -- n12th_manual_effective_date
          current_timestamp::timestamp as created_at,
          current_timestamp::timestamp as updated_at

from sc220s where substring(single_rec,11,1) = '2');

-- Insert Rec Type 3 into the database

INSERT INTO sc220_rec3_employer_ar_transactions
   (representative_number,
    representative_type,
    descriptionar,
    record_type,
    request_type,
    policy_type,
    policy_number,
    business_sequence_number,
    trans_date,
    invoice_number,
    billing_trans_status_code,
    trans_amount,
    trans_type,
    paid_amount,
    n2nd_trans_date,
    n2nd_invoice_number,
    n2nd_billing_trans_status_code,
    n2nd_trans_amount,
    n2nd_trans_type,
    n2nd_paid_amount,
    n3rd_trans_date,
    n3rd_invoice_number,
    n3rd_billing_trans_status_code,
    n3rd_trans_amount,
    n3rd_trans_type,
    n3rd_paid_amount,
    n4th_trans_date,
    n4th_invoice_number,
    n4th_billing_trans_status_code,
    n4th_trans_amount,
    n4th_trans_type,
    n4th_paid_amount,
    n5th_trans_date,
    n5th_invoice_number,
    n5th_billing_trans_status_code,
    n5th_trans_amount,
    n5th_trans_type,
    n5th_paid_amount,
    n6th_trans_date,
    n6th_invoice_number,
    n6th_billing_trans_status_code,
    n6th_trans_amount,
    n6th_trans_type,
    n6th_paid_amount,
    n7th_trans_date,
    n7th_invoice_number,
    n7th_billing_trans_status_code,
    n7th_trans_amount,
    n7th_trans_type,
    n7th_paid_amount,
    n8th_trans_date,
    n8th_invoice_number,
    n8th_billing_trans_status_code,
    n8th_trans_amount,
    n8th_trans_type,
    n8th_paid_amount,
    n9th_trans_date,
    n9th_invoice_number,
    n9th_billing_trans_status_code,
    n9th_trans_amount,
    n9th_trans_type,
    n9th_paid_amount,
    n10th_trans_date,
    n10th_invoice_number,
    n10th_billing_trans_status_code,
    n10th_trans_amount,
    n10th_trans_type,
    n10th_paid_amount,
    n11th_trans_date,
    n11th_invoice_number,
    n11th_billing_trans_status_code,
    n11th_trans_amount,
    n11th_trans_type,
    n11th_paid_amount,
    n12th_trans_date,
    n12th_invoice_number,
    n12th_billing_trans_status_code,
    n12th_trans_amount,
    n12th_trans_type,
    n12th_paid_amount,
    n13th_trans_date,
    n13th_invoice_number,
    n13th_billing_trans_status_code,
    n13th_trans_amount,
    n13th_trans_type,
    n13th_paid_amount,
    n14th_trans_date,
    n14th_invoice_number,
    n14th_billing_trans_status_code,
    n14th_trans_amount,
    n14th_trans_type,
    n14th_paid_amount,
    n15th_trans_date,
    n15th_invoice_number,
    n15th_billing_trans_status_code,
    n15th_trans_amount,
    n15th_trans_type,
    n15th_paid_amount,
    created_at,
    updated_at
)
(select
    cast_to_int(substring(single_rec,1,6)),       -- representative_number
    cast_to_int(substring(single_rec,7,2)),       -- representative_type
    substring(single_rec,9,2),       -- descriptionar
    cast_to_int(substring(single_rec,11,1)),      -- record_type
    cast_to_int(substring(single_rec,12,3)),      -- request_type
    cast_to_int(substring(single_rec,15,1)),     -- policy_type char(1),
    cast_to_int(substring(single_rec,16,7)),     -- policy_number char(7),
    cast_to_int(substring(single_rec,23,3)),      -- business_sequence_number
    case when substring(single_rec,26,8) > '00000000' THEN to_date(substring(single_rec,26,8), 'MMDDYYYY')
      else null
    end,                              -- trans_date
    substring(single_rec,34,12),     -- invoice_number
    substring(single_rec,46,5),      -- billing_trans_status_code
    substring(single_rec,51,10)::numeric/1000,     -- trans_amount
    substring(single_rec,62,5),      -- trans_type
    substring(single_rec,67,10)::numeric/1000,     -- paid_amount
    case when substring(single_rec,78,8) > '00000000' THEN to_date(substring(single_rec,78,8), 'MMDDYYYY')
      else null
    end,                              -- n2nd_trans_date
    substring(single_rec,86,12),     -- n2nd_invoice_number
    substring(single_rec,98,5),      -- n2nd_billing_trans_status_code
    substring(single_rec,103,10)::numeric/1000,    -- n2nd_trans_amount
    substring(single_rec,114,5),     -- n2nd_trans_type
    substring(single_rec,119,10)::numeric/1000,    -- n2nd_paid_amount
    case when substring(single_rec,130,8) > '00000000' THEN to_date(substring(single_rec,130,8), 'MMDDYYYY')
      else null
    end,                             -- n3rd_trans_date
    substring(single_rec,138,12),    -- n3rd_invoice_number
    substring(single_rec,150,5),     -- n3rd_billing_trans_status_code
    substring(single_rec,155,10)::numeric/1000,    -- n3rd_trans_amount
    substring(single_rec,166,5),     -- n3rd_trans_type
    substring(single_rec,171,10)::numeric/1000,    -- n3rd_paid_amount
    case when substring(single_rec,182,8) > '00000000' THEN to_date(substring(single_rec,182,8), 'MMDDYYYY')
      else null
    end,                             -- n4th_trans_date
    substring(single_rec,190,12),    -- n4th_invoice_number
    substring(single_rec,202,5),     -- n4th_billing_trans_status_code
    substring(single_rec,207,10)::numeric/1000,    -- n4th_trans_amount
    substring(single_rec,218,5),     -- n4th_trans_type
    substring(single_rec,223,10)::numeric/1000,    -- n4th_paid_amount
    case when substring(single_rec,234,8) > '00000000' THEN to_date(substring(single_rec,234,8), 'MMDDYYYY')
      else null
    end,                             -- n5th_trans_date
    substring(single_rec,242,12),    -- n5th_invoice_number
    substring(single_rec,254,5),     -- n5th_billing_trans_status_code
    substring(single_rec,259,10)::numeric/1000,    -- n5th_trans_amount
    substring(single_rec,270,5),     -- n5th_trans_type
    substring(single_rec,275,10)::numeric/1000,    -- n5th_paid_amount
    case when substring(single_rec,286,8) > '00000000' THEN to_date(substring(single_rec,286,8), 'MMDDYYYY')
      else null
    end,                             -- n6th_trans_date
    substring(single_rec,294,12),    -- n6th_invoice_number
    substring(single_rec,306,5),     -- n6th_billing_trans_status_code
    substring(single_rec,311,10)::numeric/1000,    -- n6th_trans_amount
    substring(single_rec,322,5),     -- n6th_trans_type
    substring(single_rec,327,10)::numeric/1000,    -- n6th_paid_amount
    case when substring(single_rec,338,8) > '00000000' THEN to_date(substring(single_rec,338,8), 'MMDDYYYY')
      else null
    end,                             -- n7th_trans_date
    substring(single_rec,346,12),    -- n7th_invoice_number
    substring(single_rec,358,5),     -- n7th_billing_trans_status_code
    substring(single_rec,363,10)::numeric/1000,    -- n7th_trans_amount
    substring(single_rec,374,5),     -- n7th_trans_type
    substring(single_rec,379,10)::numeric/1000,    -- n7th_paid_amount
    case when substring(single_rec,390,8) > '00000000' THEN to_date(substring(single_rec,390,8), 'MMDDYYYY')
      else null
    end,                             -- n8th_trans_date
    substring(single_rec,398,12),    -- n8th_invoice_number
    substring(single_rec,410,5),     -- n8th_billing_trans_status_code
    substring(single_rec,415,10)::numeric/1000,    -- n8th_trans_amount
    substring(single_rec,426,5),     -- n8th_trans_type
    substring(single_rec,431,10)::numeric/1000,    -- n8th_paid_amount
    case when substring(single_rec,442,8) > '00000000' THEN to_date(substring(single_rec,442,8), 'MMDDYYYY')
      else null
    end,                             -- n9th_trans_date
    substring(single_rec,450,12),    -- n9th_invoice_number
    substring(single_rec,462,5),     -- n9th_billing_trans_status_code
    substring(single_rec,467,10)::numeric/1000,    -- n9th_trans_amount
    substring(single_rec,478,5),     -- n9th_trans_type
    substring(single_rec,483,10)::numeric/1000,    -- n9th_paid_amount
    case when substring(single_rec,494,8) > '00000000' THEN to_date(substring(single_rec,494,8), 'MMDDYYYY')
      else null
    end,                             -- n10th_trans_date
    substring(single_rec,502,12),    -- n10th_invoice_number
    substring(single_rec,514,5),     -- n10th_billing_trans_status_code
    substring(single_rec,519,10)::numeric/1000,    -- n10th_trans_amount
    substring(single_rec,530,5),     -- n10th_trans_type
    substring(single_rec,535,10)::numeric/1000,    -- n10th_paid_amount
    case when substring(single_rec,546,8) > '00000000' THEN to_date(substring(single_rec,546,8), 'MMDDYYYY')
      else null
    end,                             -- n11th_trans_date
    substring(single_rec,554,12),    -- n11th_invoice_number
    substring(single_rec,566,5),     -- n11th_billing_trans_status_code
    substring(single_rec,571,10)::numeric/1000,    -- n11th_trans_amount
    substring(single_rec,582,5),     -- n11th_trans_type
    substring(single_rec,587,10)::numeric/1000,    -- n11th_paid_amount
    case when substring(single_rec,598,8) > '00000000' THEN to_date(substring(single_rec,598,8), 'MMDDYYYY')
      else null
    end,                             -- n12th_trans_date
    substring(single_rec,606,12),    -- n12th_invoice_number
    substring(single_rec,618,5),     -- n12th_billing_trans_status_code
    substring(single_rec,623,10)::numeric/1000,    -- n12th_trans_amount
    substring(single_rec,634,5),     -- n12th_trans_type
    substring(single_rec,639,10)::numeric/1000,    -- n12th_paid_amount
    case when substring(single_rec,650,8) > '00000000' THEN to_date(substring(single_rec,650,8), 'MMDDYYYY')
      else null
    end,                             -- n13th_trans_date
    substring(single_rec,658,12),    -- n13th_invoice_number
    substring(single_rec,670,5),     -- n13th_billing_trans_status_code
    substring(single_rec,675,10)::numeric/1000,    -- n13th_trans_amount
    substring(single_rec,686,5),     -- n13th_trans_type
    substring(single_rec,691,10)::numeric/1000,    -- n13th_paid_amount
    case when substring(single_rec,702,8) > '00000000' THEN to_date(substring(single_rec,702,8), 'MMDDYYYY')
      else null
    end,                             -- n14th_trans_date
    substring(single_rec,710,12),    -- n14th_invoice_number
    substring(single_rec,722,5),     -- n14th_billing_trans_status_code
    substring(single_rec,727,10)::numeric/1000,    -- n14th_trans_amount
    substring(single_rec,738,5),     -- n14th_trans_type
    substring(single_rec,743,10)::numeric/1000,    -- n14th_paid_amount
    case when substring(single_rec,754,8) > '00000000' THEN to_date(substring(single_rec,754,8), 'MMDDYYYY')
      else null
    end,                             -- n15th_trans_date
    substring(single_rec,762,12),    -- n15th_invoice_number
    substring(single_rec,774,5),     -- n15th_billing_trans_status_code
    substring(single_rec,779,10)::numeric/1000,    -- n15th_trans_amount
    substring(single_rec,790,5),     -- n15th_trans_type
    substring(single_rec,795,10)::numeric/1000,    -- n15th_paid_amount
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
from sc220s where substring(single_rec,11,1) = '3');

-- Insert Rec Type 4 into the database

Insert Into sc220_rec4_policy_not_founds
   (representative_number,
    representative_type,
    description,
    record_type,
    request_type,
    policy_type,
    policy_number,
    business_sequence_number,
    error_message,
    created_at,
    updated_at
)
(select
    cast_to_int(substring(single_rec,1,6)),       -- representative_number
    cast_to_int(substring(single_rec,7,2)),       -- representative_type
    substring(single_rec,9,2),       -- description
    cast_to_int(substring(single_rec,11,1)),      -- record_type
    cast_to_int(substring(single_rec,12,3)),      -- request_type
    cast_to_int(substring(single_rec,15,1)),     -- policy_type char(1),
    cast_to_int(substring(single_rec,16,7)),     -- policy_number char(7),
    cast_to_int(substring(single_rec,23,3)),      -- business_sequence_number
    substring(single_rec,26,25),     -- error_message
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
from sc220s where substring(single_rec,11,1) = '4');


 /*************** END OF SC220 FILE CONVERSION ***************/

 end;

   $BODY$
  LANGUAGE plpgsql;





    })
  end

  def down
    connection.execute(%q{
      DROP FUNCTION public.proc_process_flat_sc220;
    })
  end
end
