class FilterClaimsProcess
  include Sidekiq::Worker

  sidekiq_options queue: :filter_claims_process, retry: 1

  def perform(group_rating_id, all_process = nil)
    @group_rating        = GroupRating.find_by(id: group_rating_id)
    @group_rating.status = "Preparing to Filter Claims"
    @group_rating.save

    @representative = Representative.find_by(id: @group_rating.representative_id)

    result = ActiveRecord::Base.connection.exec_query("SELECT claims.id
                                                      FROM claim_calculations claims
                                                      LEFT JOIN policy_calculations policies
                                                      ON 	policies.policy_number = claims.policy_number AND policies.representative_number = #{@representative.representative_number}
                                                      WHERE claims.representative_number = #{@representative.representative_number}
                                                      AND policies.current_coverage_status IN ('ACTIV', 'REINS', 'LAPSE')
                                                      AND claims.claim_injury_date >= '#{BwcCodesConstantValue.current_rate.start_date - 10.years}'
                                                      AND claims.data_source = 'bwc'
                                                      AND NOT EXISTS (SELECT 1
                                                                    FROM democ_detail_records democs
                                                                    WHERE democs.claim_number = claims.claim_number
                                                                      AND democs.policy_number = claims.policy_number
                                                                      AND democs.representative_number = #{@representative.representative_number})
                                                      AND EXISTS (SELECT 1
                                                                  FROM democ_detail_records democs
                                                                  WHERE democs.policy_number = policies.policy_number
                                                                    AND democs.representative_number = #{@representative.representative_number})")

    ClaimCalculation.where('claim_calculations.id IN (?)', result.rows.flatten.map(&:to_i)).delete_all

    GroupRatingMarkComplete.perform_async(group_rating_id, all_process)
  end
end
