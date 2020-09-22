class FilterClaimsProcess
  include Sidekiq::Worker

  sidekiq_options queue: :filter_claims_process, retry: 1

  def perform(group_rating_id, all_process = nil)
    @group_rating   = GroupRating.find_by(id: group_rating_id)
    @representative = Representative.find_by(id: @group_rating.representative_id)

    # Per Doug delete claims we don't actually use more than 10 years old
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

    # Remove duplicate claims
    result               = ActiveRecord::Base.connection.exec_query("SELECT DISTINCT claim_number, policy_number
                                                      FROM claim_calculations
                                                      WHERE claim_number IN (
                                                        SELECT claim_number
                                                        FROM (
                                                               SELECT claim_number,
                                                                      ROW_NUMBER() OVER (PARTITION BY claim_number, policy_number ORDER BY claim_number) AS row
                                                               FROM claim_calculations
                                                               WHERE representative_number = #{@representative.representative_number}
                                                                 AND trim(claim_number) <> ''
                                                             ) dups
                                                        WHERE dups.row > 1)
                                                        AND representative_number = #{@representative.representative_number}
                                                      ORDER BY claim_number")
    claim_policies       = result.rows.map { |claim, policy| [claim, policy&.to_i] }
    policies             = claim_policies.map(&:last)
    claims_to_be_removed = []

    claim_policies.each do |claim_policy|
      claim_number  = claim_policy[0]
      policy_number = claim_policy[1]

      claims = ClaimCalculation.by_rep_and_policy(@representative.representative_number, policy_number).where('claim_number LIKE ?', "%#{claim_number}%").order(created_at: :asc)
      next unless claims.count > 1

      claim_to_keep = claims.first
      claims_to_be_removed << claims.where.not(id: claim_to_keep.id)
    end

    claims_to_be_removed.flatten.each(&:destroy)
    policies.each { |policy_number| Account.find_by_rep_and_policy(@representative.id, policy_number)&.calculate }

    GroupRatingMarkComplete.perform_async(group_rating_id, all_process)
  end
end
