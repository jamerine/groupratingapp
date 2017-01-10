class Account < ActiveRecord::Base
  has_paper_trail :ignore => [:user_override, :created_at, :updated_at, :weekly_request, :representative_id], :on => [:update]

  belongs_to :representative
  has_many :account_programs, dependent: :destroy
  has_many :accounts_affiliates
  has_many :accounts_contacts
  has_many :affiliates, through: :accounts_affiliates
  has_many :contacts, through: :accounts_contacts
  has_many :group_rating_exceptions, dependent: :destroy
  has_many :group_rating_rejections, dependent: :destroy
  has_one :policy_calculation, dependent: :destroy
  has_one :quote, dependent: :destroy

  validates :policy_number_entered, :presence => true, length: { maximum: 8 }

  enum status: [:active, :inactive, :invalid_policy_number, :predecessor, :prospect]

  enum group_rating_qualification: [:accept, :pending_predecessor, :reject]



  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

  def build_or_assign_policy_calculation(attributes)
    if self.policy_calculation.policy_number == attributes[:policy_number]
      obj = self.policy_calculation.assign_attributes(attributes)
    else
      obj = self.build_policy_calculation(attributes)
    end
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

  def self.search_name(search_name)
    search_name = search_name.downcase
    where("LOWER(name) LIKE ?", "%#{search_name}%")
  end

  def group_rating_calc(args = {})
    # MANUAL EDIT OF GROUP RATING METHOD
      @user_override = args['user_override']

      if args.empty?
        self.group_rating_reject
      else
        #self.update_attributes(group_rating_qualification: args["group_rating_qualification"])
        @group_rating_qualification = args["group_rating_qualification"]
      end
      @industry_group = policy_calculation.policy_industry_group
      if @group_rating_qualification == "accept"

        group_rating_calc = GroupRating.find_by(representative_id: policy_calculation.representative_id)

        if (args["group_rating_tier"].empty? && args["industry_group"].empty?) || args.empty? || (args["group_rating_tier"].nil? && args["industry_group"].nil?)
          @group_ratio = policy_calculation.policy_group_ratio
          group_rating_rows = BwcCodesIndustryGroupSavingsRatioCriterium.where("ratio_criteria >= :group_ratio and industry_group = :industry_group", group_ratio: @group_ratio, industry_group: @industry_group)
        elsif (args["group_rating_tier"].empty? && !args["industry_group"].empty?)
          @industry_group = args["industry_group"]
          @group_ratio = policy_calculation.policy_group_ratio
          group_rating_rows = BwcCodesIndustryGroupSavingsRatioCriterium.where("ratio_criteria >= :group_ratio and industry_group = :industry_group", group_ratio: @group_ratio, industry_group: @industry_group)
        elsif (!args["group_rating_tier"].empty? && args["industry_group"].empty?)
          @group_rating_tier = args["group_rating_tier"]
          group_rating_rows = BwcCodesIndustryGroupSavingsRatioCriterium.where("market_rate >= :group_rating_tier and industry_group = :industry_group", group_rating_tier: @group_rating_tier, industry_group: @industry_group)
        else
          @industry_group = args["industry_group"]
          @group_rating_tier = args["group_rating_tier"]
          group_rating_rows = BwcCodesIndustryGroupSavingsRatioCriterium.where("market_rate >= :group_rating_tier and industry_group = :industry_group", group_rating_tier: @group_rating_tier, industry_group: @industry_group)
        end


        if !group_rating_rows.empty?
          administrative_rate = BwcCodesConstantValue.find_by("name = 'administrative_rate' and completed_date is null").rate
          @group_rating_tier = group_rating_rows.min.market_rate
          @group_rating_group_number =  group_rating_rows.find_by(market_rate: @group_rating_tier).ac26_group_level
          # manual_classes = policy_calculation.manual_class_calculations
          policy_calculation.manual_class_calculations.each do |manual_class|
            unless manual_class.manual_class_base_rate.nil?
              manual_class_group_total_rate = (1 + @group_rating_tier) * manual_class.manual_class_base_rate * (1 +  administrative_rate)

              manual_class_estimated_group_premium = manual_class.payroll_calculations.where("reporting_period_start_date >= :current_payroll_period_lower_date and reporting_period_start_date <= :current_payroll_period_upper_date", current_payroll_period_lower_date: group_rating_calc.current_payroll_period_lower_date, current_payroll_period_upper_date: group_rating_calc.current_payroll_period_upper_date).sum(:manual_class_payroll) * manual_class_group_total_rate

              manual_class.update_attributes(manual_class_group_total_rate: manual_class_group_total_rate, manual_class_estimated_group_premium: manual_class_estimated_group_premium)
            end
          end

          @group_premium = (policy_calculation.manual_class_calculations.sum(:manual_class_estimated_group_premium)).round(0)

          @group_savings = (policy_calculation.policy_total_individual_premium - @group_premium).round(0)

        else
          @group_rating_group_number = nil
          @group_premium = nil
          @group_savings = nil
          @group_rating_tier = nil
        end
      else
        @group_rating_group_number = nil
        @group_premium = nil
        @group_savings = nil
        @group_rating_tier = nil
      end


      # update_attributes(group_rating_tier: group_rating_tier, group_premium: group_premium, group_savings: group_savings, industry_group: industry_group)


      if args["group_fees"].nil? || args["group_fees"].empty?
        self.fee_calculation(@group_rating_qualification, @group_rating_tier, @group_savings)

        self.update_attributes(user_override: @user_override, group_rating_qualification: @group_rating_qualification, industry_group: @industry_group, group_rating_tier: @group_rating_tier, group_premium: @group_premium, group_savings: @group_savings, group_fees: @group_fees, group_rating_group_number: @group_rating_group_number)
      else
        self.update_attributes(user_override: @user_override, group_rating_qualification: @group_rating_qualification, industry_group: @industry_group, group_rating_tier: @group_rating_tier, group_premium: @group_premium, group_savings: @group_savings, group_fees: args["group_fees"], group_rating_group_number: @group_rating_group_number)
      end
  end

  def group_rating(user_override=nil)

    # AUTOMATIC GROUP RATING METHOD
    unless (self.user_override? && !user_override)
      self.group_rating_reject

      @industry_group = policy_calculation.policy_industry_group

      if @group_rating_qualification == "accept"
        group_rating_calc = GroupRating.find_by(representative_id: policy_calculation.representative_id)

        group_rating_rows = BwcCodesIndustryGroupSavingsRatioCriterium.where("ratio_criteria >= :group_ratio and industry_group = :industry_group", group_ratio: policy_calculation.policy_group_ratio, industry_group: @industry_group)

        if group_rating_rows.empty?
          # self.update_attributes(group_rating_qualification: "reject", group_rating_tier: nil, group_premium: nil, group_savings: nil, industry_group: industry_group)
          @group_rating_qualification = "reject"
          @group_rating_tier = nil
          @group_premium = nil
          @group_savings = nil
        else
          administrative_rate = BwcCodesConstantValue.find_by("name = 'administrative_rate' and completed_date is null").rate

          @group_rating_tier = group_rating_rows.min.market_rate
          @group_rating_group_number =  group_rating_rows.find_by(market_rate: @group_rating_tier).ac26_group_level
          # manual_classes = policy_calculation.manual_class_calculations
          policy_calculation.manual_class_calculations.each do |manual_class|
            unless manual_class.manual_class_base_rate.nil?
              manual_class_group_total_rate = (1 + @group_rating_tier) * manual_class.manual_class_base_rate * (1 +  administrative_rate)

              manual_class_estimated_group_premium = manual_class.payroll_calculations.where("reporting_period_start_date >= :current_payroll_period_lower_date and reporting_period_start_date <= :current_payroll_period_upper_date", current_payroll_period_lower_date: group_rating_calc.current_payroll_period_lower_date, current_payroll_period_upper_date: group_rating_calc.current_payroll_period_upper_date).sum(:manual_class_payroll) * manual_class_group_total_rate

              manual_class.update_attributes(manual_class_group_total_rate: manual_class_group_total_rate, manual_class_estimated_group_premium: manual_class_estimated_group_premium)
            end
          end

          @group_premium = policy_calculation.manual_class_calculations.sum(:manual_class_estimated_group_premium).round(0)

          @group_savings = (policy_calculation.policy_total_individual_premium - @group_premium).round(0)

          # update_attributes(group_rating_tier: group_rating_tier, group_premium: group_premium, group_savings: group_savings, industry_group: industry_group)
        end
      end

      self.fee_calculation(@group_rating_qualification, @group_rating_tier, @group_savings)

      if user_override
        self.update_attributes(user_override: user_override, group_rating_qualification: @group_rating_qualification, industry_group: @industry_group, group_rating_tier: @group_rating_tier, group_premium: @group_premium, group_savings: @group_savings, group_fees: @group_fees, group_rating_group_number: @group_rating_group_number)
      else
        self.update_attributes(group_rating_qualification: @group_rating_qualification, industry_group: @industry_group, group_rating_tier: @group_rating_tier, group_premium: @group_premium, group_savings: @group_savings, group_fees: @group_fees, group_rating_group_number: @group_rating_group_number)
      end

    end
  end


  def group_rating_reject
    self.group_rating_rejections.destroy_all
    self.group_rating_exceptions.where(resolved: nil).destroy_all

    unless self.predecessor?
      @group_rating = GroupRating.where(representative_id: self.representative_id).last


        # NEGATIVE PAYROLL ON A MANUAL CLASS

        if !self.policy_calculation.manual_class_calculations.where("manual_class_current_estimated_payroll < 0 or manual_class_four_year_period_payroll < 0").empty?
          if self.group_rating_exceptions.where(exception_reason: 'manual_class_negative_payroll', resolved: true).empty?
            GroupRatingException.create(account_id: self.id, exception_reason: 'manual_class_negative_payroll', representative_id: self.representative_id)
          end
          GroupRatingRejection.create(account_id: self.id, reject_reason: 'manual_class_negative_payroll', representative_id: @group_rating.representative_id)
        end

      # ----------- Rejection Section -----------
      group_rating_range = @group_rating.experience_period_lower_date..@group_rating.experience_period_upper_date

      if policy_calculation.valid_policy_number == 'N'
        GroupRatingRejection.create(account_id: self.id, reject_reason: 'reject_invalid_policy_number', representative_id: @group_rating.representative_id)
        if self.group_rating_exceptions.where(exception_reason: 'invalid_policy_number', resolved: true).empty?
          GroupRatingException.create(account_id: self.id, exception_reason: 'invalid_policy_number', representative_id: self.representative_id)
        end
      end

      if ["CANFI","CANPN","BKPCA","BKPCO","COMB","CANUN"].include? policy_calculation.current_coverage_status
        GroupRatingRejection.create(account_id: self.id, reject_reason: 'reject_inactive_policy', representative_id: @group_rating.representative_id)
      end

      if policy_calculation.policy_group_ratio.nil? || policy_calculation.policy_group_ratio >= 0.85
        GroupRatingRejection.create(account_id: self.id, reject_reason: 'reject_high_group_ratio', representative_id: @group_rating.representative_id)
      end

      if [3,4,5,7,8,10].exclude? policy_calculation.policy_industry_group
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

      if  self.group_rating_rejections.pluck(:reject_reason).include? 'reject_pending_predecessor'
         qualification = "pending_predecessor"
      elsif self.group_rating_rejections.count > 0
         qualification = "reject"
       else
         qualification = "accept"
       end

       if qualification == "accept"
         # ----------- Exception Section -----------

         #LAPSE PERIOD FOR GROUP RATING
           nov_first = (Date.current.year.to_s + '-11-01').to_date
           days_to_add = (4 - nov_first.wday) % 7
           fourth_thursday = nov_first + days_to_add + 21

           higher_lapse = fourth_thursday - 3
           lower_lapse = higher_lapse - 12.months
           lapse_sum = 0

           coverage_lapse_periods = self.policy_calculation.policy_coverage_status_histories.where("coverage_status = :coverage_status and (coverage_end_date BETWEEN :lower_lapse and :higher_lapse or coverage_end_date is null)", coverage_status: "LAPSE", lower_lapse: lower_lapse, higher_lapse: higher_lapse)

           coverage_lapse_periods.each do |period|
             # period starts before and ends out of range
             if period.coverage_effective_date < lower_lapse && period.coverage_end_date.nil?
               lapse_sum += Date.current - lower_lapse
             # period starts after and ends out of range
             elsif period.coverage_effective_date > lower_lapse && period.coverage_end_date.nil?
               lapse_sum += Date.current - period.coverage_effective_date
             # period starts before and ends in range
             elsif period.coverage_effective_date < lower_lapse && period.coverage_end_date < higher_lapse
               lapse_sum += period.coverage_end_date - lower_lapse
             # period starts after and ends in range
             elsif period.coverage_effective_date > lower_lapse && period.coverage_end_date < higher_lapse
               lapse_sum += period.coverage_end_date - period.coverage_effective_date
             end
           end

           if lapse_sum >= 60
             GroupRatingRejection.create(account_id: self.id, reject_reason: 'reject_60+_lapse', representative_id: self.representative_id)
             if self.group_rating_exceptions.where(exception_reason: 'group_rating_60+_lapse', resolved: true).empty?
               GroupRatingException.create(account_id: self.id, exception_reason: 'group_rating_60+_lapse', representative_id: self.representative_id)
             end
           elsif lapse_sum < 60 && lapse_sum >= 40
             if self.group_rating_exceptions.where(exception_reason: 'group_rating_40-60_lapse', resolved: true).empty?
               GroupRatingException.create(account_id: self.id, exception_reason: 'group_rating_40-60_lapse', representative_id: self.representative_id)
             end
           end

            if self.group_rating_rejections.count > 0
              qualification = "reject"
            else
              qualification = "accept"
            end
         end

      # update_attributes(group_rating_qualification: qualification)
      return @group_rating_qualification = qualification
    end
  end



  def fee_calculation(group_rating_qualification, group_rating_tier, group_savings)
      if policy_calculation.policy_total_individual_premium.nil? || representative.representative_number != 219406
        return
      end

      if group_rating_qualification != "accept"
        # fee = (policy_calculation.policy_total_individual_premium * 0.035).round(0)
        # update_attribute(:group_fees, fee)
        @group_fees = (policy_calculation.policy_total_individual_premium * 0.035).round(0)
      elsif group_rating_tier < -0.35
        # fee = (group_savings * 0.0415).round(0)
        # update_attribute(:group_fees, fee)
        @group_fees = (group_savings * 0.0415).round(0)
      else
        # fee = (policy_calculation.policy_total_individual_premium * 0.0275).round(0)
        # update_attribute(:group_fees, fee)
        @group_fees = (policy_calculation.policy_total_individual_premium * 0.0275).round(0)
      end
      return @group_fees
  end


  def self.to_csv
    @accounts = Account.joins(:policy_calculation).select("accounts.*, policy_calculations.*").limit(5).offset(1000)

    attributes = Account.column_names
    PolicyCalculation.column_names.each do |p|
      unless p == 'id' || p == 'representative_number' || p == 'policy_number' || p ==  'data_source' || p == 'created_at' || p == 'updated_at' || p == 'representative_id'|| p == 'account_id' || p == 'federal_identification_number'
        attributes << p
      end
    end
    CSV.generate(headers: true) do |csv|
      csv << attributes

      @accounts.each do |account|
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
