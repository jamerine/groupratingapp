class Account < ActiveRecord::Base

  has_one :policy_calculation, dependent: :destroy
  belongs_to :representative
  has_many :group_rating_rejections, dependent: :destroy

  validates :policy_number_entered, :presence => true, length: { maximum: 8 }

  enum status: [:active, :inactive, :predecessor, :prospect]

  enum group_rating_qualification: [:accept, :pending_predecessor, :reject]

  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

  # def self.assign_or_new(attributes)
  #   obj = first || new
  #   obj.assign_attributes(attributes)
  #   obj
  # end


  def self.search(search)
    where("policy_number_entered = ?", "#{search}")
  end


  def group_rating(args = {})

      if args[:group_rating_qualification].nil?
        self.group_rating_reject
      end

      if group_rating_qualification != "reject"
        group_rating_calc = GroupRating.find_by(representative_id: policy_calculation.representative_id)

        if args[:group_rating_tier_entered].nil?
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


  def group_rating_reject
    GroupRatingRejection.where(representative_id: self.representative_id, account_id: self.id).destroy_all
    unless self.predecessor?
      @group_rating = GroupRating.where(representative_id: self.representative_id).last

      group_rating_range = @group_rating.experience_period_lower_date..@group_rating.experience_period_upper_date
      if ["CANFI","CANPN","BKPCA","BKPCO","COMB","CANUN"].include? policy_calculation.policy_status
        GroupRatingRejection.create(account_id: self.id, reject_reason: 'reject_inactive_policy', representative_id: @group_rating.representative_id)
      end

      if policy_calculation.policy_group_ratio.nil? || policy_calculation.policy_group_ratio >= 0.85
        GroupRatingRejection.create(account_id: self.id, reject_reason: 'reject_high_group_ratio', representative_id: @group_rating.representative_id)
      end

      if [3,4,5,7,8].exclude? policy_calculation.policy_industry_group
        GroupRatingRejection.create(account_id: self.id, reject_reason: 'reject_homogeneity', representative_id: @group_rating.representative_id)
      end

      # Check for waiting on predecessor payroll
      if PolicyCalculation.find_by(business_name: "Predecessor Policy for #{self.policy_calculation.policy_number}")
        GroupRatingRejection.create(account_id: self.id, reject_reason: 'reject_pending_predecessor', representative_id: @group_rating.representative_id)
      end





      # CONDITIONS FOR State Fund and Self Insured PEO
      if peo_records = ProcessPolicyExperiencePeriodPeo.where(policy_number: policy_calculation.policy_number, representative_number: @group_rating.process_representative)
        peo_records.each do |peo_record|
          if (peo_record.manual_class_sf_peo_lease_effective_date.nil? && peo_record.manual_class_sf_peo_lease_termination_date.nil?)
            if
              ((group_rating_range === peo_record.manual_class_si_peo_lease_effective_date) || (group_rating_range === peo_record.manual_class_si_peo_lease_termination_date))
              GroupRatingRejection.create(account_id: self.id, reject_reason: 'reject_si_peo', representative_id: @group_rating.representative_id)
            end
          else
            if
              ((!peo_record.manual_class_sf_peo_lease_effective_date.nil? && peo_record.manual_class_sf_peo_lease_termination_date.nil?) || (peo_record.manual_class_sf_peo_lease_effective_date > peo_record.manual_class_sf_peo_lease_termination_date)) ||
              ((group_rating_range === peo_record.manual_class_sf_peo_lease_effective_date) || (group_rating_range === peo_record.manual_class_sf_peo_lease_termination_date))
              GroupRatingRejection.create(account_id: self.id, reject_reason: 'reject_sf_peo', representative_id: @group_rating.representative_id)
            end
          end
        end
      end
      if self.group_rating_rejections.count > 0
         qualification = 2
       else
         qualification = 0
       end

      update_attributes(group_rating_qualification: qualification)
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


  def self.to_csv
    attributes = self.column_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |account|
        csv << attributes.map{ |attr| account.send(attr) }
      end
    end
  end


  def self.to_request(representative_number)
    rep_num = "%06d" % representative_number + '-80'

    CSV.generate(:col_sep => "\t") do |csv|
      all.each do |account|
        policy_number = "%08d" % account.policy_number_entered + '-000'
        csv << ["159",policy_number, rep_num ]
        account.update_attributes(request_date: Time.now)
      end
    end

  end

end
