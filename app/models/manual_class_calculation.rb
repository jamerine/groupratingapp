class ManualClassCalculation < ActiveRecord::Base

  belongs_to :policy_calculation
  has_many :payroll_calculations, dependent: :destroy

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end

  def recalculate_experience
    @group_rating = GroupRating.find_by(process_representative: self.representative_number)

    four_year_sum = self.payroll_calculations.where("manual_class_effective_date BETWEEN :experience_period_lower_date and :experience_period_upper_date",  experience_period_lower_date: @group_rating.experience_period_lower_date, experience_period_upper_date: @group_rating.experience_period_upper_date).sum(:manual_class_payroll)

    current_payroll = self.payroll_calculations.where("manual_class_effective_date >= :current_payroll_period_lower_date", current_payroll_period_lower_date: @group_rating.current_payroll_period_lower_date).sum(:manual_class_payroll)


    update_attribute(:manual_class_four_year_period_payroll, four_year_sum)

    @bwc_base_rate = BwcCodesBaseRatesExpLossRate.find_by(class_code: self.manual_number)

    expected_losses = @bwc_base_rate.expected_loss_rate * four_year_sum

    update_attributes(manual_class_expected_loss_rate: @bwc_base_rate.expected_loss_rate, manual_class_base_rate: @bwc_base_rate.base_rate, manual_class_expected_losses: expected_losses, manual_class_current_estimated_payroll: current_payroll)

    @policy_calculation = PolicyCalculation.find(self.policy_calculation_id)

    four_year_sum = @policy_calculation.manual_class_calculations.sum(:manual_class_four_year_period_payroll)
    policy_expected_losses = @policy_calculation.manual_class_calculations.sum(:manual_class_expected_losses)
    policy_estimated_current_payroll =  @policy_calculation.manual_class_calculations.sum(:manual_class_current_estimated_payroll)


    @policy_calculation.update_attributes(policy_total_expected_losses: policy_expected_losses, policy_total_four_year_payroll: four_year_sum, policy_total_current_payroll: policy_estimated_current_payroll )


    @credibility_row = BwcCodesCredibilityMaxLoss.where("expected_losses >= :expected_losses", expected_losses: @policy_calculation.policy_total_expected_losses).min

    if @policy_calculation.policy_total_expected_losses <= 2000
      @credibility_row.credibility_group = 0
      @credibility_row.expected_losses = 0
      @credibility_row.credibility_percent = 0
      @credibility_row.group_maximum_value = 0
    elsif @policy_calculation.policy_total_expected_losses >= 1000000
      @credibility_row = BwcCodesCredibilityMaxLoss.find_by(expected_losses: 1000000)
    else
      @credibility_row = BwcCodesCredibilityMaxLoss.find_by(credibility_group: (@credibility_row.credibility_group - 1))
    end

    @limited_loss_rate = BwcCodesLimitedLossRatio.find_by(industry_group: self.manual_class_industry_group, credibility_group: @policy_calculation.policy_credibility_group)

    limited_loss_rate = @limited_loss_rate.limited_loss_ratio
    limited_losses = self.manual_class_expected_losses * @limited_loss_rate.limited_loss_ratio

    update_attributes(manual_class_limited_losses: limited_losses, manual_class_limited_loss_rate: limited_loss_rate)

    policy_limited_losses = @policy_calculation.manual_class_calculations.sum(:manual_class_limited_losses)

    @policy_calculation.update_attributes(policy_maximum_claim_value: @credibility_row.group_maximum_value)

    @policy_calculation.update_attributes(policy_credibility_percent: @credibility_row.credibility_percent, policy_credibility_group: @credibility_row.credibility_group, policy_total_limited_losses: policy_limited_losses)

    @claims = @policy_calculation.claim_calculations.where("claim_injury_date >= :experience_period_lower_date and claim_injury_date <= :experience_period_upper_date",  experience_period_lower_date: @group_rating.experience_period_lower_date, experience_period_upper_date: @group_rating.experience_period_upper_date)

    if @claims.nil? || @policy_calculation.policy_total_expected_losses == 0
      policy_total_modified_losses_group_reduced = 0

      policy_total_modified_losses_individual_reduced = 0

      policy_total_claims_count = 0
    else
      @claims.each do |claim|
        claim.recalculate_experience
      end

      policy_total_modified_losses_group_reduced = @claims.sum(:claim_modified_losses_group_reduced)

      policy_total_modified_losses_individual_reduced = @claims.sum(:claim_modified_losses_individual_reduced)

      policy_total_claims_count = @claims.count
    end

      if @policy_calculation.policy_total_expected_losses == 0
        policy_group_ratio = 0
      else
        policy_group_ratio = (policy_total_modified_losses_group_reduced / @policy_calculation.policy_total_expected_losses).round(6)
      end


    policy_individual_total_modifier =
        if @policy_calculation.policy_total_limited_losses == 0
          0
        else
          (((@policy_calculation.policy_total_modified_losses_individual_reduced - @policy_calculation.policy_total_limited_losses ) / @policy_calculation.policy_total_limited_losses) * @policy_calculation.policy_credibility_percent).round(6)
        end

   policy_individual_experience_modified_rate = (policy_individual_total_modifier + 1).round(6)

   @policy_calculation.update_attributes(policy_total_modified_losses_group_reduced: policy_total_modified_losses_group_reduced, policy_total_modified_losses_individual_reduced: policy_total_modified_losses_individual_reduced, policy_total_claims_count: policy_total_claims_count, policy_individual_total_modifier: policy_individual_total_modifier, policy_individual_experience_modified_rate: policy_individual_experience_modified_rate, policy_group_ratio: policy_group_ratio )

   self.recalculate_premium

  end

  def recalculate_premium
    @policy_calculation = PolicyCalculation.find(self.policy_calculation_id)

    @policy_calculation.manual_class_calculations.each do |manual_class_calculation|

      manual_class_standard_premium = manual_class_calculation.manual_class_base_rate * manual_class_calculation.manual_class_current_estimated_payroll * @policy_calculation.policy_individual_experience_modified_rate

      manual_class_calculation.update_attribute(:manual_class_standard_premium, manual_class_standard_premium)

      manual_class_industry_group_premium_total = @policy_calculation.manual_class_calculations.where(manual_class_industry_group: manual_class_calculation.manual_class_industry_group).sum(:manual_class_standard_premium)

      manual_class_calculation.update_attribute(:manual_class_industry_group_premium_total, manual_class_industry_group_premium_total)

      manual_class_modification_rate = (manual_class_calculation.manual_class_base_rate * @policy_calculation.policy_individual_experience_modified_rate)

      manual_class_calculation.update_attribute(:manual_class_modification_rate, manual_class_modification_rate)

      manual_class_individual_total_rate = manual_class_modification_rate * (1 + BwcCodesConstantValue.find_by(name: 'administrative_rate', completed_date: nil).value )

      manual_class_calculation.update_attribute(:manual_class_individual_total_rate, manual_class_individual_total_rate)

    end


      policy_total_standard_premium = @policy_calculation.manual_class_calculations.sum(:manual_class_standard_premium)

      @policy_calculation.update_attribute(:policy_total_standard_premium, policy_total_standard_premium)

      @collection = @policy_calculation.manual_class_calculations.select(:manual_class_industry_group).distinct

      @collection_hash = {}
      @collection.each do |c|
        @collection_hash[c.manual_class_industry_group] = @policy_calculation.manual_class_calculations.where(manual_class_industry_group: c.manual_class_industry_group).sum(:manual_class_standard_premium)
      end

    @policy_calculation.manual_class_calculations.each do |manual_class_calculation|

      manual_class_industry_group_premium_percentage =
        if @policy_calculation.policy_total_standard_premium == 0 || @policy_calculation.policy_total_standard_premium.nil?
          0
        else
          manual_class_industry_group_premium_total = @collection_hash[manual_class_calculation.manual_class_industry_group]

          (manual_class_industry_group_premium_total / @policy_calculation.policy_total_standard_premium).round(4)
        end

      manual_class_calculation.update_attribute(:manual_class_industry_group_premium_percentage, manual_class_industry_group_premium_percentage )

    end

      manual_class_industry_group_premium_percentage = @policy_calculation.manual_class_calculations.maximum("manual_class_industry_group_premium_percentage")

      manual_class_industry_group = @policy_calculation.manual_class_calculations.find_by(manual_class_industry_group_premium_percentage: manual_class_industry_group_premium_percentage).manual_class_industry_group

      @policy_calculation.update_attribute(:policy_industry_group, manual_class_industry_group)

      # COULD ADD LOGIC HERE FOR AUTOMATICALLY CHANGING THE INDUSTRY GROUP FOR POLICIES WITH INDUSTY GROUP 10 HERE

      policy_group_rating_tier = BwcCodesIndustryGroupSavingsRatioCriterium.where("ratio_criteria >= :policy_group_ratio and industry_group = :policy_industry_group", policy_group_ratio: @policy_calculation.policy_group_ratio, policy_industry_group: @policy_calculation.policy_industry_group).minimum(:market_rate)

      @policy_calculation.update_attribute(:group_rating_tier, policy_group_rating_tier)

    @policy_calculation.manual_class_calculations.each do |manual_class_calculation|

      if @policy_calculation.group_rating_tier.nil?
        manual_class_calculation.manual_class_group_total_rate = 0
        manual_class_group_total_ratemanual_class_estimated_group_premium = 0
      else
        manual_class_group_total_rate = (1 + @policy_calculation.group_rating_tier) * manual_class_calculation.manual_class_base_rate * (1 + BwcCodesConstantValue.find_by(name: 'administrative_rate', completed_date: nil).value )
        manual_class_estimated_group_premium = manual_class_calculation.manual_class_current_estimated_payroll * manual_class_group_total_rate
      end



      manual_class_estimated_individual_premium = manual_class_calculation.manual_class_current_estimated_payroll * manual_class_calculation.manual_class_individual_total_rate

      manual_class_calculation.update_attributes(manual_class_group_total_rate: manual_class_group_total_rate, manual_class_estimated_group_premium: manual_class_estimated_group_premium, manual_class_estimated_individual_premium: manual_class_estimated_individual_premium )

    end

  policy_total_individual_premium =   @policy_calculation.manual_class_calculations.sum(:manual_class_estimated_individual_premium)

  if @policy_calculation.group_rating_tier.nil?
    policy_total_group_premium = nil
  else
    policy_total_group_premium =   @policy_calculation.manual_class_calculations.sum(:manual_class_estimated_group_premium)
  end

  @policy_calculation.update_attributes(policy_total_individual_premium: policy_total_individual_premium, policy_total_group_premium: policy_total_group_premium)
  end




  def self.to_csv
    attributes = self.column_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |manual_class|
        csv << attributes.map{ |attr| manual_class.send(attr) }
      end
    end
  end


end
