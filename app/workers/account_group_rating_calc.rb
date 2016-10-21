class AccountGroupRatingCalc
  include Sidekiq::Worker

  sidekiq_options queue: :account_group_rating_calc

  def perform(account_id)
    @account = Account.includes(policy_calculation: :manual_class_calculations).find(account_id)
    @account.group_rating_rejections

    unless @account.group_rating_qualification = 2

      group_rating_rows = BwcCodesIndustryGroupSavingsRatioCriterium.where("ratio_criteria >= :group_ratio and industry_group = :industry_group", group_ratio: @account.policy_calculation.policy_group_ratio, industry_group: @account.policy_calculation.policy_industry_group)

      unless group_rating_rows.empty?
        administrative_rate = BwcCodesConstantValue.find_by("name = 'administrative_rate' and completed_date is null").rate

        group_rating_tier = group_rating_rows.min.market_rate

        @account.policy_calculation.manual_class_calculations.each do |manual_class|
          unless manual_class.manual_class_base_rate.nil?
            manual_class_group_total_rate = (1 + group_rating_tier) * manual_class.manual_class_base_rate * (1 +  administrative_rate)
            manual_class_estimated_group_premium = manual_class.manual_class_current_estimated_payroll * manual_class_group_total_rate

            manual_class.update_attributes(manual_class_group_total_rate: manual_class_group_total_rate, manual_class_estimated_group_premium: manual_class_estimated_group_premium)
          end
        end

        group_premium = @account.policy_calculation.manual_class_calculations.sum(:manual_class_estimated_group_premium)

        group_savings = @account.policy_calculation.policy_total_individual_premium - group_premium

        @account.update_attributes(group_rating_tier: group_rating_tier, group_premium: group_premium, group_savings: group_savings)


      end
      @account.fee_calculation
    end

  end

end
