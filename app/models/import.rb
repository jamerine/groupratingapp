# == Schema Information
#
# Table name: imports
#
#  id                                                  :integer          not null, primary key
#  process_representative                              :integer
#  group_rating_id                                     :integer
#  import_status                                       :text
#  parse_status                                        :text
#  democs_count                                        :integer
#  mrcls_count                                         :integer
#  mremps_count                                        :integer
#  pcombs_count                                        :integer
#  phmgns_count                                        :integer
#  sc220s_count                                        :integer
#  sc230s_count                                        :integer
#  rates_count                                         :integer
#  pdemos_count                                        :integer
#  pemhs_count                                         :integer
#  pcovgs_count                                        :integer
#  democ_detail_records_count                          :integer
#  mrcl_detail_records_count                           :integer
#  mremp_employee_experience_policy_levels_count       :integer
#  mremp_employee_experience_manual_class_levels_count :integer
#  mremp_employee_experience_claim_levels_count        :integer
#  pcomb_detail_records_count                          :integer
#  phmgn_detail_records_count                          :integer
#  sc220_rec1_employer_demographics_count              :integer
#  sc220_rec2_employer_manual_level_payrolls_count     :integer
#  sc220_rec3_employer_ar_transactions_count           :integer
#  sc220_rec4_policy_not_founds_count                  :integer
#  sc230_employer_demographics_count                   :integer
#  sc230_claim_medical_payments_count                  :integer
#  sc230_claim_indemnity_awards_count                  :integer
#  rate_detail_records_count                           :integer
#  pdemo_detail_records_count                          :integer
#  pemh_detail_records_count                           :integer
#  pcovg_detail_records_count                          :integer
#  created_at                                          :datetime         not null
#  updated_at                                          :datetime         not null
#  representative_id                                   :integer
#

class Import < ActiveRecord::Base
  belongs_to :representative
  belongs_to :group_rating

end
