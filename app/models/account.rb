# == Schema Information
#
# Table name: accounts
#
#  id                            :integer          not null, primary key
#  ac3_approval                  :boolean
#  account_type                  :integer
#  business_contact_name         :string
#  business_email_address        :string
#  business_phone_extension      :string
#  business_phone_number         :string
#  city                          :string
#  cycle_date                    :date
#  fax_number                    :string
#  federal_identification_number :string
#  fee_change                    :float
#  fee_override                  :float
#  group_dues                    :float
#  group_fees                    :float
#  group_premium                 :float
#  group_rating_group_number     :string
#  group_rating_qualification    :integer
#  group_rating_tier             :float
#  group_retro_group_number      :string
#  group_retro_premium           :float
#  group_retro_qualification     :string
#  group_retro_savings           :float
#  group_retro_tier              :float
#  group_savings                 :float
#  industry_group                :integer
#  name                          :string
#  policy_number_entered         :integer
#  quarterly_request             :boolean
#  request_date                  :date
#  state                         :string
#  status                        :integer          default(0)
#  street_address                :string
#  street_address_2              :string
#  total_costs                   :float
#  tpa_end_date                  :date
#  tpa_start_date                :date
#  user_override                 :boolean
#  website_url                   :string
#  weekly_request                :boolean
#  zip_code                      :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  representative_id             :integer
#
# Indexes
#
#  index_accounts_on_representative_id  (representative_id)
#
# Foreign Keys
#
#  fk_rails_...  (representative_id => representatives.id)
#

class Account < ActiveRecord::Base
  has_paper_trail :ignore => [:created_at, :weekly_request], :on => [:update]

  belongs_to :representative
  has_many :account_programs, dependent: :destroy
  has_many :accounts_affiliates, dependent: :destroy
  has_many :affiliates, through: :accounts_affiliates, dependent: :destroy
  has_many :accounts_contacts, dependent: :destroy
  has_many :contacts, through: :accounts_contacts, dependent: :destroy
  has_many :group_rating_exceptions, dependent: :destroy
  has_many :group_rating_rejections, dependent: :destroy
  has_one :policy_calculation, dependent: :destroy
  has_many :quotes, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_one :accounts_mco, dependent: :destroy
  has_one :mco, through: :accounts_mco

  validates :policy_number_entered, :presence => true, length: { maximum: 8 }
  validate :valid_group_retro_tier

  accepts_nested_attributes_for :accounts_mco, reject_if: :all_blank

  enum status: [:active, :cancelled, :client, :dead, :inactive, :invalid_policy_number, :new_account, :predecessor, :prospect, :suspended]
  enum account_type: [:grp_group, :gtro_group_retro, :individual_retro, :non_group, :ocp_one_claim_program, :pg_pregroup, :self_insured_tail]

  enum group_rating_qualification: [:accept, :pending_predecessor, :reject]

  # Scopes
  scope :active_policy, -> { joins(:policy_calculation).where('policy_calculations.current_coverage_status IN (?)', ["ACTIV", "REINS", "LAPSE"]) }
  scope :status, -> (status) { where status: status }
  scope :by_policy_status, -> (status) { joins(:policy_calculation).where('policy_calculations.current_coverage_status = ?', status.upcase) }
  scope :group_rating_tier, -> (group_rating_tier) { where group_rating_tier: group_rating_tier }
  scope :group_retro_tier, -> (group_retro_tier) { where group_retro_tier: group_retro_tier }
  # scope :policy_search, -> (policy_search) { self.search(policy_search)}
  scope :fee_change_percent, -> (fee_change_percent) { where("fee_change >= ?", (fee_change_percent)) }

  delegate :representative_number, to: :representative, prefix: false, allow_nil: false
  delegate :name, to: :mco, prefix: true, allow_nil: true
  delegate :public_employer?, to: :policy_calculation, prefix: false, allow_nil: true

  attr_accessor :group_rating_id, :start_date, :end_date

  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

  def employer_demographics
    EmployerDemographic.where(policy_number: self.policy_number_entered, representative_id: self.representative_id)
  end

  def group_rating_rejected?
    self.group_rating_qualification == 'reject'
  end

  def group_retro_rejected?
    self.group_retro_qualification == 'reject'
  end

  def self.find_by_rep_and_policy(rep_id, policy_number)
    where(representative_id: rep_id, policy_number_entered: policy_number)&.select { |account| account.policy_calculation.present? }&.first
    # find_by(policy_number_entered: policy_number, representative_id: rep_id)
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
    joins(:policy_calculation).where("LOWER(accounts.name) LIKE ? OR LOWER(policy_calculations.trading_as_name) LIKE ?", "%#{search_name}%", "%#{search_name}%")
  end

  def self.search_affiliate(search_name)
    search_name = search_name.downcase
    joins(:affiliates).where("LOWER(affiliates.first_name) LIKE ? OR LOWER(affiliates.last_name) LIKE ?", "%#{search_name}%", "%#{search_name}%")
  end

  def self.search_employer_type(type)
    type = type == 'None' ? '' : type
    joins(:policy_calculation).where(policy_calculations: { employer_type: type })
  end

  def tpa_from_date
    self.tpa_start_date || Date.new(self.representative.program_year, 12, 1)
  end

  def tpa_to_date
    self.tpa_end_date || Date.new(self.representative.quote_year_upper_date.year, 3, 31)
  end

  def group_rating_calc(args = {})
    # MANUAL EDIT OF GROUP RATING METHOD - FROM UI/APP
    if args['user_override'] == true
      @user_override = args['user_override']
      self.group_rating_rejections.where(program_type: 'group_rating').destroy_all
    end

    @fee_override = args['fee_override']

    if args.empty?
      self.group_rating_reject
    else
      #self.update_attributes(group_rating_qualification: args["group_rating_qualification"])
      @group_rating_qualification = args["group_rating_qualification"]
    end

    @industry_group = policy_calculation.policy_industry_group

    if @group_rating_qualification == "accept"
      if (args["group_rating_tier"].empty? && args["industry_group"].empty?) || args.empty? || (args["group_rating_tier"].nil? && args["industry_group"].nil?)
        @group_ratio      = policy_calculation.policy_group_ratio
        group_rating_rows = BwcCodesIndustryGroupSavingsRatioCriterium.where("ratio_criteria >= :group_ratio and industry_group = :industry_group", group_ratio: @group_ratio, industry_group: @industry_group)
      elsif (args["group_rating_tier"].empty? && !args["industry_group"].empty?)
        @industry_group   = args["industry_group"]
        @group_ratio      = policy_calculation.policy_group_ratio
        group_rating_rows = BwcCodesIndustryGroupSavingsRatioCriterium.where("ratio_criteria >= :group_ratio and industry_group = :industry_group", group_ratio: @group_ratio, industry_group: @industry_group)
      elsif (!args["group_rating_tier"].empty? && args["industry_group"].empty?)
        @group_rating_tier = args["group_rating_tier"]
        group_rating_rows  = BwcCodesIndustryGroupSavingsRatioCriterium.where("market_rate >= :group_rating_tier and industry_group = :industry_group", group_rating_tier: @group_rating_tier, industry_group: @industry_group)
      else
        @industry_group    = args["industry_group"]
        @group_rating_tier = args["group_rating_tier"]
        group_rating_rows  = BwcCodesIndustryGroupSavingsRatioCriterium.where("market_rate >= :group_rating_tier and industry_group = :industry_group", group_rating_tier: @group_rating_tier, industry_group: @industry_group)
      end

      if !group_rating_rows.empty?
        @group_rating_tier         = group_rating_rows.min.market_rate
        @group_rating_group_number = group_rating_rows.find_by(market_rate: @group_rating_tier).ac26_group_level

        handle_manual_class_group_premium_calculations(@group_rating_tier)

        @group_premium = (policy_calculation.manual_class_calculations.sum(:manual_class_estimated_group_premium)).round(2)

        if @group_premium < 120
          @group_premium = 120.00
        end

        @group_savings = (policy_calculation.policy_adjusted_individual_premium - @group_premium).round(2)

      else
        @group_rating_group_number = nil
        @group_premium             = nil
        @group_savings             = nil
        @group_rating_tier         = nil
      end
    else
      @group_rating_group_number = nil
      @group_premium             = nil
      @group_savings             = nil
      @group_rating_tier         = nil
    end

    # update_attributes(group_rating_tier: group_rating_tier, group_premium: group_premium, group_savings: group_savings, industry_group: industry_group)

    self.fee_calculation(@group_rating_qualification, @group_rating_tier, @group_savings)

    self.update_attributes(user_override: @user_override, group_rating_qualification: @group_rating_qualification, industry_group: @industry_group, group_rating_tier: @group_rating_tier, group_premium: @group_premium, group_savings: @group_savings, group_fees: @group_fees, fee_change: @fee_change, fee_override: @fee_override, group_rating_group_number: @group_rating_group_number)
  end

  def group_rating(user_override = nil)
    # AUTOMATIC GROUP RATING METHOD (FROM ACCOUNT CALCULATION)
    unless self.user_override? && !user_override
      self.group_rating_reject

      return unless self.policy_calculation.present?

      @industry_group = self.policy_calculation.policy_industry_group

      if @group_rating_qualification == "accept"
        group_rating_rows = BwcCodesIndustryGroupSavingsRatioCriterium.where("ratio_criteria >= :group_ratio and industry_group = :industry_group", group_ratio: self.policy_calculation.policy_group_ratio, industry_group: @industry_group)

        if group_rating_rows.empty?
          # self.update_attributes(group_rating_qualification: "reject", group_rating_tier: nil, group_premium: nil, group_savings: nil, industry_group: industry_group)
          @group_rating_qualification = "reject"
          @group_rating_tier          = nil
          @group_premium              = nil
          @group_savings              = nil
        else
          @group_rating_tier         = group_rating_rows.min.market_rate
          @group_rating_group_number = group_rating_rows.find_by(market_rate: @group_rating_tier).ac26_group_level

          handle_manual_class_group_premium_calculations(@group_rating_tier)

          @group_premium = policy_calculation.manual_class_calculations.sum(:manual_class_estimated_group_premium).round(2)

          if @group_premium < 120
            @group_premium = 120.00
          end

          @group_savings = (policy_calculation.policy_adjusted_individual_premium - @group_premium).round(2)
        end

      else
        @group_rating_group_number = nil
        @group_premium             = nil
        @group_savings             = nil
        @group_rating_tier         = nil
      end
      self.fee_calculation(@group_rating_qualification, @group_rating_tier, @group_savings)

      if user_override
        self.update_attributes(user_override: user_override, group_rating_qualification: @group_rating_qualification, industry_group: @industry_group, group_rating_tier: @group_rating_tier, group_premium: @group_premium, group_savings: @group_savings, group_fees: @group_fees, fee_change: @fee_change, group_rating_group_number: @group_rating_group_number)
      else
        self.update_attributes(group_rating_qualification: @group_rating_qualification, industry_group: @industry_group, group_rating_tier: @group_rating_tier, group_premium: @group_premium, group_savings: @group_savings, group_fees: @group_fees, fee_change: @fee_change, group_rating_group_number: @group_rating_group_number)
      end
    end
  end

  def group_rating_reject
    #  self.group_rating_rejections.where(program_type: 'group_rating').destroy_all
    self.group_rating_exceptions.where(resolved: nil).destroy_all
    @group_rating_rejection_array = []

    @group_rating = GroupRating.where(representative_id: self.representative_id).last
    # NEGATIVE PAYROLL ON A MANUAL CLASS

    return unless self.policy_calculation.present?

    unless self.policy_calculation&.manual_class_calculations&.where("manual_class_current_estimated_payroll < 0 or manual_class_four_year_period_payroll < 0")&.empty?
      if self.group_rating_exceptions.where(exception_reason: 'manual_class_negative_payroll', resolved: true).empty?
        GroupRatingException.create(account_id: self.id, exception_reason: 'manual_class_negative_payroll', representative_id: self.representative_id)
      end
      if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'manual_class_negative_payroll', program_type: 'group_rating')
        @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'manual_class_negative_payroll', representative_id: @group_rating.representative_id, program_type: 'group_rating', hide: @found_rejection.hide)
      else
        @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'manual_class_negative_payroll', representative_id: @group_rating.representative_id, program_type: 'group_rating')
      end
    end

    # ----------- Rejection Section -----------
    group_rating_range = @group_rating.experience_period_lower_date..@group_rating.experience_period_upper_date

    if policy_calculation.valid_policy_number == 'N'
      if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_invalid_policy_number', program_type: 'group_rating')
        @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_invalid_policy_number', representative_id: @group_rating.representative_id, program_type: 'group_rating', hide: @found_rejection.hide)
      else
        @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_invalid_policy_number', representative_id: @group_rating.representative_id, program_type: 'group_rating')
      end
      if self.group_rating_exceptions.where(exception_reason: 'invalid_policy_number', resolved: true).empty?
        GroupRatingException.create(account_id: self.id, exception_reason: 'invalid_policy_number', representative_id: self.representative_id)
      end
    end

    if ["CANFI", "CANPN", "BKPCA", "BKPCO", "COMB", "CANUN"].include? policy_calculation.current_coverage_status
      if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_inactive_policy', program_type: 'group_rating')
        @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_inactive_policy', representative_id: @group_rating.representative_id, program_type: 'group_rating', hide: @found_rejection.hide)
      else
        @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_inactive_policy', representative_id: @group_rating.representative_id, program_type: 'group_rating')
      end
    end

    if policy_calculation.policy_group_ratio.nil? || policy_calculation.policy_group_ratio >= 0.85
      if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_high_group_ratio', program_type: 'group_rating')
        @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_high_group_ratio', representative_id: @group_rating.representative_id, program_type: 'group_rating', hide: @found_rejection.hide)
      else
        @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_high_group_ratio', representative_id: @group_rating.representative_id, program_type: 'group_rating')
      end
    end

    if BwcCodesIndustryGroupSavingsRatioCriterium.industry_groups.exclude? policy_calculation.policy_industry_group
      if @found_rejection = self.group_rating_rejections.find_by(reject_reason: "reject_homogeneity_ig_#{policy_calculation.policy_industry_group}", program_type: 'group_rating')
        @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: "reject_homogeneity_ig_#{policy_calculation.policy_industry_group}", representative_id: @group_rating.representative_id, program_type: 'group_rating', hide: @found_rejection.hide)
      else
        @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: "reject_homogeneity_ig_#{policy_calculation.policy_industry_group}", representative_id: @group_rating.representative_id, program_type: 'group_rating')

      end
    end

    # Check for waiting on predecessor payroll
    if Account.find_by(name: "Predecessor Policy for #{self.policy_number_entered}", representative_id: self.representative_id)
      if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_pending_predecessor', program_type: 'group_rating')
        @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_pending_predecessor', representative_id: @group_rating.representative_id, program_type: 'group_rating', hide: @found_rejection.hide)
      else
        @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_pending_predecessor', representative_id: @group_rating.representative_id, program_type: 'group_rating')
      end
    end

    #Check if Policy_number is on the Accept Reject List for Group Rating
    #  @accept_reject_list = BwcGroupAcceptRejectList.find_by(policy_number: self.policy_number_entered)
    #  @representative_number_adjust = "#{self.representative.representative_number.to_s.rjust(6, "0")}-80"
    #  if @accept_reject_list && (@accept_reject_list.bwc_rep_id != @representative_number_adjust)
    #    if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_partner_conflict', program_type: 'group_rating')
    #      @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_partner_conflict', representative_id: @group_rating.representative_id, program_type: 'group_rating', hide: @found_rejection.hide)
    #    else
    #       @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_partner_conflict', representative_id: @group_rating.representative_id, program_type: 'group_rating')
    #     end
    #  end

    # CONDITIONS FOR State Fund and Self Insured PEO
    if peo_records = ProcessPolicyExperiencePeriodPeo.where(policy_number: policy_calculation.policy_number, representative_number: @group_rating.process_representative)
      peo_records.each do |peo_record|
        if (peo_record.manual_class_sf_peo_lease_effective_date.nil? && peo_record.manual_class_sf_peo_lease_termination_date.nil?)
          if ((group_rating_range === peo_record.manual_class_si_peo_lease_effective_date) || (group_rating_range === peo_record.manual_class_si_peo_lease_termination_date))
            # if @accept_reject_list && (@accept_reject_list.bwc_rep_id != @representative_number_adjust)
            if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_si_peo', program_type: 'group_rating')
              @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_si_peo', representative_id: @group_rating.representative_id, program_type: 'group_rating', hide: @found_rejection.hide)
            else
              @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_si_peo', representative_id: @group_rating.representative_id, program_type: 'group_rating')
            end
            # end
          end
        else
          if ((!peo_record.manual_class_sf_peo_lease_effective_date.nil? && peo_record.manual_class_sf_peo_lease_termination_date.nil?) || (peo_record.manual_class_sf_peo_lease_effective_date > peo_record.manual_class_sf_peo_lease_termination_date)) ||
            ((group_rating_range === peo_record.manual_class_sf_peo_lease_effective_date) && (peo_record.manual_class_sf_peo_lease_termination_date.nil?))
            if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_sf_peo', program_type: 'group_rating')
              @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_sf_peo', representative_id: @group_rating.representative_id, program_type: 'group_rating', hide: @found_rejection.hide)
            else
              @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_sf_peo', representative_id: @group_rating.representative_id, program_type: 'group_rating')
            end
          end
        end
      end
    end

    if @group_rating_rejection_array.collect(&:reject_reason).include? 'reject_pending_predecessor'
      qualification = "pending_predecessor"
    elsif @group_rating_rejection_array.count > 0
      qualification = "reject"
    else
      qualification = "accept"
    end

    if qualification == "accept"
      # ----------- Exception Section -----------

      #LAPSE PERIOD FOR GROUP RATING
      nov_first       = (Date.current.year.to_s + '-11-01').to_date
      days_to_add     = (4 - nov_first.wday) % 7
      fourth_thursday = nov_first + days_to_add + 21

      higher_lapse = fourth_thursday - 3
      lower_lapse  = higher_lapse - 12.months
      lapse_sum    = 0

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
        if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_60', program_type: 'group_rating')
          @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_60', representative_id: @group_rating.representative_id, program_type: 'group_rating', hide: @found_rejection.hide)
        else
          @group_rating_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_60', representative_id: @group_rating.representative_id, program_type: 'group_rating')
        end
        #  if self.group_rating_exceptions.where(exception_reason: 'group_rating_60+_lapse', resolved: true).empty?
        #    GroupRatingException.create(account_id: self.id, exception_reason: 'group_rating_60+_lapse', representative_id: self.representative_id)
        #  end
      elsif lapse_sum < 60 && lapse_sum >= 40
        if self.group_rating_exceptions.where(exception_reason: 'group_rating_40-60_lapse', resolved: true).empty?
          GroupRatingException.create(account_id: self.id, exception_reason: 'group_rating_40-60_lapse', representative_id: self.representative_id)
        end
      end

    end

    # Removed the if else for reject_pending_predecessor for predecessor accounts.  It is the wrong reason for rejecting
    # else
    #   GroupRatingRejection.create(program_type: 'group_rating', account_id: self.id, reject_reason: 'reject_pending_predecessor', representative_id: @group_rating.representative_id)
    # end

    self.group_rating_rejections.where(program_type: 'group_rating').destroy_all

    if @group_rating_rejection_array.count > 0
      qualification = "reject"
      @group_rating_rejection_array.each { |a| a.save }
    else
      qualification = "accept"
    end

    return @group_rating_qualification = qualification

  end

  def group_retro(user_override = nil)
    # AUTOMATIC GROUP RETRO (FROM ACCOUNT CALCULATION)
    unless self.user_override? && !user_override
      self.group_retro_reject

      return unless self.policy_calculation.present?

      @industry_group = policy_calculation.policy_industry_group

      if @group_retro_qualification == "accept"
        @group_retro_tier         = BwcCodesGroupRetroTier.find_by(industry_group: @industry_group, public_employer_only: public_employer?).discount_tier
        @group_retro_group_number = @industry_group

        if @group_retro_tier.nil?
          @group_retro_qualification = "reject"
          @group_retro_premium       = nil
          @group_retro_savings       = nil
        else
          @group_retro_premium = (policy_calculation.policy_adjusted_standard_premium * (1 + @group_retro_tier)).round(0)

          @group_retro_savings = (policy_calculation.policy_adjusted_standard_premium - @group_retro_premium).round(0)
        end

        if user_override
          self.update_attributes(user_override: user_override, group_retro_qualification: @group_retro_qualification, industry_group: @industry_group, group_retro_tier: @group_retro_tier, group_retro_premium: @group_retro_premium, group_retro_savings: @group_retro_savings, group_retro_group_number: @group_retro_group_number)
        else
          self.update_attributes(group_retro_qualification: @group_retro_qualification, industry_group: @industry_group, group_retro_tier: @group_retro_tier, group_retro_premium: @group_retro_premium, group_retro_savings: @group_retro_savings, group_retro_group_number: @group_retro_group_number)
        end
      else
        self.update_attributes(group_retro_qualification: "reject", group_retro_premium: nil, group_retro_savings: nil, group_retro_tier: nil, group_retro_group_number: nil)
      end
    end
  end

  def group_retro_calc(args = {})
    # manual edit of group retro method - FROM UI/APP
    if args['user_override'] == true
      @user_override = args['user_override']
      self.group_rating_rejections.where(program_type: 'group_retro').destroy_all
    end

    @fee_override = args['fee_override']

    if args.empty?
      self.group_retro_reject
    else
      @group_retro_qualification = args["group_retro_qualification"]
    end

    if @group_retro_qualification == "accept"

      if args[:industry_group].empty?
        @industry_group = policy_calculation.policy_industry_group
      else
        @industry_group = args["industry_group"]
      end

      if args["group_retro_tier"].empty?
        @group_retro_tier = BwcCodesGroupRetroTier.find_by(industry_group: @industry_group, public_employer_only: public_employer?)&.discount_tier
      else
        @group_retro_tier = args["group_retro_tier"]
      end

      if @group_retro_tier.nil?
        @group_retro_qualification = "reject"
        @group_retro_premium       = nil
        @group_retro_savings       = nil
        @group_retro_group_number  = nil
      else
        @group_retro_premium      = (policy_calculation.policy_adjusted_standard_premium * (1 + @group_retro_tier.to_f)).round(0)
        @group_retro_group_number = "#{@industry_group}"
        @group_retro_savings      = (policy_calculation.policy_adjusted_standard_premium - @group_retro_premium).round(0)
      end
    else
      @group_retro_group_number = nil
      @group_retro_premium      = nil
      @group_retro_savings      = nil
      @group_retro_tier         = nil
    end

    self.update_attributes(user_override: @user_override, group_retro_qualification: @group_retro_qualification, industry_group: @industry_group, group_retro_tier: @group_retro_tier, group_retro_premium: @group_retro_premium, group_retro_savings: @group_retro_savings, group_retro_group_number: @group_retro_group_number, fee_override: @fee_override)
  end

  def group_retro_reject
    # self.group_rating_rejections.where(program_type: 'group_retro').destroy_all
    @group_retro_rejection_array = []

    return unless self.policy_calculation.present?

    @group_rating = GroupRating.where(representative_id: self.representative_id).last
    # NEGATIVE PAYROLL ON A MANUAL CLASS

    unless self.policy_calculation.manual_class_calculations.where("manual_class_current_estimated_payroll < 0 or manual_class_four_year_period_payroll < 0").empty?
      if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'manual_class_negative_payroll', program_type: 'group_retro')
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'manual_class_negative_payroll', representative_id: @group_rating.representative_id, program_type: 'group_retro', hide: @found_rejection.hide)
      else
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'manual_class_negative_payroll', representative_id: @group_rating.representative_id, program_type: 'group_retro')
      end
    end

    # ----------- Rejection Section -----------
    group_retro_range = @group_rating.experience_period_lower_date..@group_rating.experience_period_upper_date

    if policy_calculation.valid_policy_number == 'N'
      if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_invalid_policy_number', program_type: 'group_retro')
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_invalid_policy_number', representative_id: @group_rating.representative_id, program_type: 'group_retro', hide: @found_rejection.hide)
      else
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_invalid_policy_number', representative_id: @group_rating.representative_id, program_type: 'group_retro')
      end
    end

    if self.policy_calculation.policy_total_standard_premium.nil? || self.policy_calculation.policy_total_standard_premium < 5000
      # @account.policy_calculation.policy_total_standard_premium.nil? || @account.policy_calculation.policy_total_standard_premium < 5000
      if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_low_standard_premium', program_type: 'group_retro')
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_low_standard_premium', representative_id: @group_rating.representative_id, program_type: 'group_retro', hide: @found_rejection.hide)
      else
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_low_standard_premium', representative_id: @group_rating.representative_id, program_type: 'group_retro')
      end
    end

    retro_industry_groups = BwcCodesGroupRetroTier.industry_groups(false)
    retro_industry_groups += BwcCodesGroupRetroTier.industry_groups(true) if public_employer?

    if retro_industry_groups.exclude?(policy_calculation.policy_industry_group)
      if @found_rejection = self.group_rating_rejections.find_by(reject_reason: "reject_homogeneity_ig_#{policy_calculation.policy_industry_group}", program_type: 'group_retro')
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: "reject_homogeneity_ig_#{policy_calculation.policy_industry_group}", representative_id: @group_rating.representative_id, program_type: 'group_retro', hide: @found_rejection.hide)
      else
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: "reject_homogeneity_ig_#{policy_calculation.policy_industry_group}", representative_id: @group_rating.representative_id, program_type: 'group_retro')
      end
    end

    if peo_records = ProcessPolicyExperiencePeriodPeo.where(policy_number: policy_calculation.policy_number, representative_number: @group_rating.process_representative)
      peo_records.each do |peo_record|
        if (peo_record.manual_class_sf_peo_lease_effective_date.nil? && peo_record.manual_class_sf_peo_lease_termination_date.nil?)
          if ((group_retro_range === peo_record.manual_class_si_peo_lease_effective_date) || (group_retro_range === peo_record.manual_class_si_peo_lease_termination_date))
            if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_si_peo', program_type: 'group_retro')
              @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_si_peo', representative_id: @group_rating.representative_id, program_type: 'group_retro', hide: @found_rejection.hide)
            else
              @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_si_peo', representative_id: @group_rating.representative_id, program_type: 'group_retro')
            end
          end
        else
          # Fixed group retro to only reject if effective date is within range and termination dat nil saying that they are still in a sf peo.
          if ((!peo_record.manual_class_sf_peo_lease_effective_date.nil? && peo_record.manual_class_sf_peo_lease_termination_date.nil?) || (peo_record.manual_class_sf_peo_lease_effective_date > peo_record.manual_class_sf_peo_lease_termination_date)) ||
            ((group_retro_range === peo_record.manual_class_sf_peo_lease_effective_date) && (peo_record.manual_class_sf_peo_lease_termination_date.nil?))
            if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_sf_peo', program_type: 'group_retro')
              @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_sf_peo', representative_id: @group_rating.representative_id, program_type: 'group_retro', hide: @found_rejection.hide)
            else
              @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_sf_peo', representative_id: @group_rating.representative_id, program_type: 'group_retro')
            end
          end
        end
      end
    end

    if ["CANFI", "CANPN", "BKPCA", "BKPCO", "COMB", "CANUN"].include? policy_calculation.current_coverage_status
      if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_inactive_policy', program_type: 'group_retro')
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_inactive_policy', representative_id: @group_rating.representative_id, program_type: 'group_retro', hide: @found_rejection.hide)
      else
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_inactive_policy', representative_id: @group_rating.representative_id, program_type: 'group_retro')
      end
    end

    if policy_calculation.policy_group_ratio.nil? || policy_calculation.policy_group_ratio >= 3.0
      if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_high_group_ratio', program_type: 'group_retro')
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_high_group_ratio', representative_id: @group_rating.representative_id, program_type: 'group_retro', hide: @found_rejection.hide)
      else
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_high_group_ratio', representative_id: @group_rating.representative_id, program_type: 'group_retro')
      end
    end

    # Check for waiting on predecessor payroll
    if PolicyCalculation.find_by(business_name: "Predecessor Policy for #{self.policy_calculation.policy_number}")
      if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_pending_predecessor', program_type: 'group_retro')
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_pending_predecessor', representative_id: @group_rating.representative_id, program_type: 'group_retro', hide: @found_rejection.hide)
      else
        @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_pending_predecessor', representative_id: @group_rating.representative_id, program_type: 'group_retro')
      end
    end

    ## Rejection for Partner Conflict
    # Check BWCGroupAcceptRejectList
    # @accept_reject_list = BwcGroupAcceptRejectList.find_by(policy_number: self.policy_number_entered)
    # representative_number_adjust = "#{self.representative.representative_number.to_s.rjust(6, "0")}"
    # in_bwc_list = @accept_reject_list&.bwc_rep_id&.ljust(6, @representative_number_adjust).present?
    # # Check AccountPrograms of other representatives
    # other_accounts = Account.where("policy_number_entered = ? and representative_id != ?", self.policy_number_entered, self.representative_id).pluck(:id)
    # other_account_programs = AccountProgram.where("effective_start_date = ? and effective_end_date = ? and account_id in (?)", @group_rating.program_year_lower_date, @group_rating.program_year_upper_date, other_accounts)
    # in_other_acct_programs = other_account_programs.present?

    # if in_bwc_list || in_other_acct_programs
    #   if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_partner_conflict', program_type: 'group_retro')
    #     @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_partner_conflict', representative_id: @group_rating.representative_id, program_type: 'group_retro', hide: @found_rejection.hide)
    #   else
    #     @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_partner_conflict', representative_id: @group_rating.representative_id, program_type: 'group_retro')
    #   end
    # end

    if @group_retro_rejection_array.collect(&:reject_reason).include? 'reject_pending_predecessor'
      qualification = "pending_predecessor"
    elsif @group_retro_rejection_array.count > 0
      qualification = "reject"
    else
      qualification = "accept"
    end

    if qualification == "accept"
      # ----------- Exception Section -----------
      #LAPSE PERIOD FOR GROUP RATING
      nov_first       = (Date.current.year.to_s + '-11-01').to_date
      days_to_add     = (4 - nov_first.wday) % 7
      fourth_thursday = nov_first + days_to_add + 21

      higher_lapse = fourth_thursday - 3
      lower_lapse  = higher_lapse - 9.months
      lapse_sum    = 0

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

      if lapse_sum >= 40
        if @found_rejection = self.group_rating_rejections.find_by(reject_reason: 'reject_40+_lapse', program_type: 'group_retro')
          @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_40+_lapse', representative_id: @group_rating.representative_id, program_type: 'group_retro', hide: @found_rejection.hide)
        else
          @group_retro_rejection_array << self.group_rating_rejections.new(reject_reason: 'reject_40+_lapse', representative_id: @group_rating.representative_id, program_type: 'group_retro')
        end
      end

      if self.group_rating_rejections.where("program_type = ?", :group_retro).count > 0
        qualification = "reject"
      else
        qualification = "accept"
      end
    end

    # update_attributes(group_rating_qualification: qualification)

    # Removed the if else for reject_pending_predecessor for predecessor accounts.  It is the wrong reason for rejecting
    # else
    #   GroupRatingRejection.create(program_type: 'group_retro', account_id: self.id, reject_reason: 'reject_pending_predecessor', representative_id: @group_rating.representative_id)
    # end
    self.group_rating_rejections.where(program_type: 'group_retro').destroy_all

    if @group_retro_rejection_array.count > 0
      qualification = "reject"
      @group_retro_rejection_array.each { |a| a.save }
    else
      qualification = "accept"
    end

    @group_retro_qualification = qualification
  end

  def fee_calculation(group_rating_qualification, group_rating_tier, group_savings)
    if policy_calculation.policy_total_individual_premium.nil? || representative.representative_number != 219406
      return
    end
    @previus_fee = self.account_programs.empty? ? '0.00'.to_f : self.account_programs.last.fees_amount

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

    if @group_fees < 55
      @group_fees = 55
    end
    if @previus_fee == '0.00'.to_f
      @fee_change = '0.00'.to_f
    else
      @fee_change = (@group_fees - @previus_fee) / @previus_fee
    end

    return @group_fees, @fee_change
  end

  def self.to_csv
    @accounts = Account.joins(:policy_calculation).select("accounts.*, policy_calculations.*").limit(5).offset(1000)

    attributes = Account.column_names
    PolicyCalculation.column_names.each do |p|
      unless p == 'id' || p == 'representative_number' || p == 'policy_number' || p == 'data_source' || p == 'created_at' || p == 'updated_at' || p == 'representative_id' || p == 'account_id' || p == 'federal_identification_number'
        attributes << p
      end
    end
    CSV.generate(headers: true) do |csv|
      csv << attributes

      @accounts.each do |account|
        csv << attributes.map { |attr| account.send(attr) }
      end
    end
  end

  # def self.to_request(representative_number)
  #   rep_num = "%06d" % representative_number + '-80'
  #
  #   CSV.generate(:col_sep => "\t") do |csv|
  #     all.each do |account|
  #       policy_number = "%08d" % account.policy_number_entered + '-000'
  #       csv << ["159",policy_number, rep_num ]
  #       account.update_attributes(request_date: Time.now)
  #     end
  #   end
  #
  # end

  def administrative_rate
    (public_employer? ? BwcCodesConstantValue.current_public_rate : BwcCodesConstantValue.current_rate).rate
  end

  def estimated_premium(market_rate)
    premiums = []
    self.policy_calculation.manual_class_calculations.each { |mc| premiums << mc.calculate_estimated_premium(market_rate, administrative_rate) }
    premiums.sum.round(2)
  end

  def calculate
    policy = self.policy_calculation || PolicyCalculation.find_by_rep_and_policy(self.representative&.representative_number, self.policy_number_entered)

    policy&.calculate_experience
    policy&.calculate_premium
    group_rating
    group_retro
  end

  private

  def valid_group_retro_tier
    return unless self.group_retro_tier.present?
    tiers = BwcCodesGroupRetroTier.by_public_employer(self.public_employer?).where(discount_tier: self.group_retro_tier)
    return unless tiers.any?

    self.errors.add(:group_retro_tier, 'is not valid for this account\'s industry group/public employer status.') unless self.industry_group.in?(tiers.pluck(:industry_group))
  end

  def handle_manual_class_group_premium_calculations(group_rating_tier)
    group_rating_calc = GroupRating.find_by(representative_id: self.representative_id)

    self.policy_calculation.manual_class_calculations.each do |manual_class|
      next unless manual_class.manual_class_base_rate.present?

      start_date = group_rating_calc.current_payroll_period_lower_date
      end_date   = group_rating_calc.current_payroll_period_upper_date

      if public_employer?
        start_date = (start_date + 1.year).beginning_of_year
        end_date   = start_date.end_of_year
      end

      if policy_calculation.policy_creation_date >= group_rating_calc.current_payroll_period_lower_date
        start_date += 1.year
        end_date   += 1.year
      end

      manual_class_group_total_rate = (((1 + group_rating_tier) * manual_class.manual_class_base_rate).round(2) * (1 + administrative_rate)).round(4) / 100
      payroll                       = manual_class.payroll_calculations.where("reporting_period_start_date >= :current_payroll_period_lower_date and reporting_period_start_date < :current_payroll_period_upper_date",
                                                                              current_payroll_period_lower_date: start_date,
                                                                              current_payroll_period_upper_date: end_date).sum(:manual_class_payroll)
      group_premium                 = (payroll * manual_class_group_total_rate).round(2)

      manual_class.update_attributes(manual_class_group_total_rate: manual_class_group_total_rate, manual_class_estimated_group_premium: group_premium)
    end
  end

end
