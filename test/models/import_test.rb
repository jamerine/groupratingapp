# == Schema Information
#
# Table name: imports
#
#  id                                                  :integer          not null, primary key
#  clicd_detail_records_count                          :integer
#  clicds_count                                        :integer
#  democ_detail_records_count                          :integer
#  democs_count                                        :integer
#  import_status                                       :text
#  mira_detail_records_count                           :integer
#  miras_count                                         :integer
#  mrcl_detail_records_count                           :integer
#  mrcls_count                                         :integer
#  mremp_employee_experience_claim_levels_count        :integer
#  mremp_employee_experience_manual_class_levels_count :integer
#  mremp_employee_experience_policy_levels_count       :integer
#  mremps_count                                        :integer
#  parse_status                                        :text
#  pcomb_detail_records_count                          :integer
#  pcombs_count                                        :integer
#  pcovg_detail_records_count                          :integer
#  pcovgs_count                                        :integer
#  pdemo_detail_records_count                          :integer
#  pdemos_count                                        :integer
#  pemh_detail_records_count                           :integer
#  pemhs_count                                         :integer
#  phmgn_detail_records_count                          :integer
#  phmgns_count                                        :integer
#  process_representative                              :integer
#  rate_detail_records_count                           :integer
#  rates_count                                         :integer
#  sc220_rec1_employer_demographics_count              :integer
#  sc220_rec2_employer_manual_level_payrolls_count     :integer
#  sc220_rec3_employer_ar_transactions_count           :integer
#  sc220_rec4_policy_not_founds_count                  :integer
#  sc220s_count                                        :integer
#  sc230_claim_indemnity_awards_count                  :integer
#  sc230_claim_medical_payments_count                  :integer
#  sc230_employer_demographics_count                   :integer
#  sc230s_count                                        :integer
#  created_at                                          :datetime         not null
#  updated_at                                          :datetime         not null
#  group_rating_id                                     :integer
#  representative_id                                   :integer
#
# Indexes
#
#  index_imports_on_group_rating_id    (group_rating_id)
#  index_imports_on_representative_id  (representative_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_rating_id => group_ratings.id)
#  fk_rails_...  (representative_id => representatives.id)
#

require 'test_helper'

class ImportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
