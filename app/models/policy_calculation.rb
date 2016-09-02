class PolicyCalculation < ActiveRecord::Base

  has_many :manual_class_calculations, dependent: :destroy
  has_many :claim_calculations, dependent: :destroy

  belongs_to :representative

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end

  def self.search(search)
    where("policy_number = ?", "#{search}")
  end


  def recalculate_experience
    @group_rating = GroupRating.find_by(process_representative: self.representative_number)


  end


  def recalculate_premium

    policy_total_standard_premium = self.manual_class_calculations.sum(:manual_class_standard_premium)

    policy_total_current_payroll = self.manual_class_calculations.sum(:manual_class_current_estimated_payroll)

    @group_rating_row = BwcCodesIndustryGroupSavingsRatioCriterium.where("ratio_criteria >= :policy_group_ratio", policy_group_ratio: self.policy_group_ratio).min

    unless @group_rating_row.nil?
      group_rating_tier =
          if self.policy_group_ratio == 0
            -0.53
          else
            @group_rating_row.market_rate
          end
    end

    self.manual_class_calculations.each do |manual_class|

      manual_class_industry_group_premium_percentage =
        if policy_total_standard_premium.nil? || policy_total_standard_premium == 0 || manual_class.manual_class_industry_group_premium_total.nil? || manual_class.manual_class_industry_group_premium_total == 0
          0
        else
          manual_class.manual_class_industry_group_premium_total / policy_total_standard_premium
        end


      manual_class_modification_rate = manual_class.manual_class_base_rate * self.policy_individual_experience_modified_rate


      manual_class_individual_total_rate = manual_class_modification_rate * (1 + BwcCodesConstantValue.find_by(name: 'administrative_rate', completed_date: nil).value )

      manual_class.update_attributes(manual_class_modification_rate: manual_class_modification_rate, manual_class_individual_total_rate: manual_class_individual_total_rate, manual_class_industry_group_premium_percentage: manual_class_industry_group_premium_percentage)


      manual_class_group_total_rate = (1 + group_rating_tier) * manual_class.manual_class_base_rate * (1 + BwcCodesConstantValue.find_by(name: 'administrative_rate', completed_date: nil).value )

      manual_class_estimated_group_premium = manual_class.manual_class_current_estimated_payroll * manual_class_group_total_rate

      manual_class_estimated_individual_premium = manual_class.manual_class_current_estimated_payroll * manual_class.manual_class_individual_total_rate

      manual_class.update_attributes(manual_class_group_total_rate: manual_class_group_total_rate, manual_class_estimated_group_premium: manual_class_estimated_group_premium, manual_class_estimated_individual_premium: manual_class_estimated_individual_premium )

    end

    policy_total_group_premium = self.manual_class_calculations.sum(:manual_class_estimated_group_premium)

    policy_total_individual_premium = self.manual_class_calculations.sum(:manual_class_estimated_individual_premium)

    policy_total_group_savings = policy_total_individual_premium - policy_total_group_premium

    update_attributes(policy_total_standard_premium: policy_total_standard_premium, policy_total_current_payroll: policy_total_current_payroll, group_rating_tier: group_rating_tier, policy_total_group_premium: policy_total_group_premium, policy_total_individual_premium: policy_total_individual_premium, policy_total_group_savings: policy_total_group_savings )



  end

end
