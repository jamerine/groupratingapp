class Account < ActiveRecord::Base

  has_one :policy_calculation, dependent: :destroy
  belongs_to :representative

  validates :policy_number_entered, :presence => true, length: { maximum: 8 }

  enum status: [:active, :inactive, :predecessor, :prospect]

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end


  def self.search(search)
    where("policy_number_entered = ?", "#{search}")
  end

  def group_rating(group_rating_tier_entered=nil)

    policy_calculation = PolicyCalculation.includes(manual_class_calculations: :payroll_calculations).find_by(account_id: self.id)

    group_rating_calc = GroupRating.find_by(representative_id: policy_calculation.representative_id)

    unless policy_calculation.policy_group_ratio.nil?

      if group_rating_tier_entered.nil?
        group_rating_rows = BwcCodesIndustryGroupSavingsRatioCriterium.where("ratio_criteria >= :group_ratio and industry_group = :industry_group", group_ratio: policy_calculation.policy_group_ratio, industry_group: policy_calculation.policy_industry_group)
      else
        group_rating_rows = BwcCodesIndustryGroupSavingsRatioCriterium.where("market_rate >= :group_rating_tier_entered and industry_group = :industry_group", group_rating_tier_entered: group_rating_tier_entered, industry_group: policy_calculation.policy_industry_group)
      end

      unless group_rating_rows.empty?
        administrative_rate = BwcCodesConstantValue.find_by("name = 'administrative_rate' and completed_date is null").rate

        group_rating_tier = group_rating_rows.min.market_rate

        # manual_classes = policy_calculation.manual_class_calculations
        policy_calculation.manual_class_calculations.each do |manual_class|
          unless manual_class.manual_class_base_rate.nil?
            manual_class_group_total_rate = (1 + group_rating_tier) * manual_class.manual_class_base_rate * (1 +  administrative_rate)

            manual_class_estimated_group_premium = manual_class.payroll_calculations.where("manual_class_effective_date >= :current_payroll_period_lower_date", current_payroll_period_lower_date: group_rating_calc.current_payroll_period_lower_date).sum(:manual_class_payroll) * manual_class_group_total_rate

            manual_class.update_attributes(manual_class_group_total_rate: manual_class_group_total_rate, manual_class_estimated_group_premium: manual_class_estimated_group_premium)
          end
        end

        group_premium = policy_calculation.manual_class_calculations.sum(:manual_class_estimated_group_premium)

        group_savings = policy_calculation.policy_total_individual_premium - group_premium

        update_attributes(group_rating_tier: group_rating_tier, group_premium: group_premium, group_savings: group_savings)
      end
    end



  end

  def fee_calculation
      if policy_calculation.policy_total_individual_premium.nil? || representative.representative_number != 219406
        return
      end
      if group_rating_tier.nil?
        fee = (policy_calculation.policy_total_individual_premium * 0.035)
        update_attribute(:group_fees, fee)
      elsif group_rating_tier < -0.35
        fee = (group_savings * 0.0415)
        update_attribute(:group_fees, fee)
      else
        fee = (policy_calculation.policy_total_individual_premium * 0.0275)
        update_attribute(:group_fees, fee)
      end
  end


end
