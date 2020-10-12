# == Schema Information
#
# Table name: policy_calculations
#
#  id                                                  :integer          not null, primary key
#  advance_deposit_amount                              :float
#  appealed_balance_amount                             :float
#  attorney_general_balance_amount                     :float
#  business_name                                       :string
#  coverage_status_effective_date                      :date
#  coverage_type                                       :string
#  current_coverage_status                             :string
#  currently_assigned_clm_representative_number        :integer
#  currently_assigned_erc_representative_number        :integer
#  currently_assigned_grc_representative_number        :integer
#  currently_assigned_representative_number            :integer
#  currently_assigned_risk_representative_number       :integer
#  data_source                                         :string
#  em_effective_date                                   :date
#  employer_type                                       :string
#  federal_identification_number                       :string
#  group_code                                          :string
#  immediate_successor_business_sequence_number        :integer
#  immediate_successor_policy_number                   :integer
#  in_care_name_contact_name                           :string
#  location_address_line_1                             :string
#  location_address_line_2                             :string
#  location_city                                       :string
#  location_country_code                               :integer
#  location_county                                     :integer
#  location_state                                      :string
#  location_zip_code                                   :integer
#  location_zip_code_plus_4                            :integer
#  mailing_address_line_1                              :string
#  mailing_address_line_2                              :string
#  mailing_city                                        :string
#  mailing_country_code                                :integer
#  mailing_county                                      :integer
#  mailing_state                                       :string
#  mailing_zip_code                                    :integer
#  mailing_zip_code_plus_4                             :integer
#  merit_rate                                          :float
#  minimum_premium_percentage                          :string
#  pending_balance_amount                              :float
#  policy_adjusted_individual_premium                  :float
#  policy_adjusted_standard_premium                    :float
#  policy_coverage_type                                :string
#  policy_creation_date                                :date
#  policy_credibility_group                            :integer
#  policy_credibility_percent                          :float
#  policy_employer_type                                :string
#  policy_group_number                                 :string
#  policy_group_ratio                                  :float
#  policy_individual_adjusted_experience_modified_rate :float
#  policy_individual_experience_modified_rate          :float
#  policy_individual_total_modifier                    :float
#  policy_industry_group                               :integer
#  policy_maximum_claim_value                          :integer
#  policy_number                                       :integer
#  policy_total_claims_count                           :integer
#  policy_total_current_payroll                        :float
#  policy_total_expected_losses                        :float
#  policy_total_four_year_payroll                      :float
#  policy_total_individual_premium                     :float
#  policy_total_limited_losses                         :float
#  policy_total_modified_losses_group_reduced          :float
#  policy_total_modified_losses_individual_reduced     :float
#  policy_total_standard_premium                       :float
#  rate_adjust_factor                                  :string
#  regular_balance_amount                              :float
#  representative_number                               :integer
#  trading_as_name                                     :string
#  ultimate_successor_business_sequence_number         :integer
#  ultimate_successor_policy_number                    :integer
#  valid_location_address                              :string
#  valid_mailing_address                               :string
#  valid_policy_number                                 :string
#  created_at                                          :datetime         not null
#  updated_at                                          :datetime         not null
#  account_id                                          :integer
#  representative_id                                   :integer
#
# Indexes
#
#  index_policy_calculations_on_account_id         (account_id)
#  index_policy_calculations_on_pol_num            (policy_number)
#  index_policy_calculations_on_representative_id  (representative_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (representative_id => representatives.id)
#

class PolicyCalculation < ActiveRecord::Base
  has_many :manual_class_calculations, dependent: :destroy
  has_many :claim_calculations, dependent: :destroy
  has_many :policy_coverage_status_histories, dependent: :destroy
  has_many :policy_program_histories, dependent: :destroy
  has_many :payroll_calculations, through: :manual_class_calculations
  belongs_to :representative
  belongs_to :account

  delegate :name, to: :account, prefix: true, allow_nil: false
  delegate :status, to: :account, prefix: true, allow_nil: false

  scope :by_representative, -> (rep_number) { where(representative_number: rep_number) }
  scope :updated_in_quarterly_report, -> { where('policy_calculations.updated_at >= ?', Date.parse('2020-07-30')) }
  scope :not_recently_updated_payroll, -> { joins(manual_class_calculations: :payroll_calculations).where(payroll_calculations: { recently_updated: false }).distinct }
  scope :current_coverage_statuses, -> { all.select(:current_coverage_status).map(&:current_coverage_status).reject(&:blank?).uniq }
  scope :bwc, -> { where(data_source: 'bwc') }

  before_destroy :delete_claims

  def representative_name
    self.representative&.abbreviated_name
  end

  # Add Papertrail as history tracking
  has_paper_trail :on => [:update]

  def self.find_by_rep_and_policy(rep_number, policy_number)
    find_by(representative_number: rep_number, policy_number: policy_number)
  end

  # def claim_calculations
  #   ClaimCalculation.by_representative(self.representative_number).where(policy_number: self.policy_number)
  # end

  # def manual_class_calculations
  #   ManualClassCalculation.by_representative(self.representative_number).where(policy_number: self.policy_number)
  # end

  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    obj
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end

  def self.search(search)
    where("policy_number LIKE ?", "%#{search}%")
  end

  def self.to_csv
    attributes = self.column_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |policy|
        csv << attributes.map { |attr| policy.send(attr) }
      end
    end
  end

  def adjusted_total_modifier(policy_individual_total_modifier = self.policy_individual_total_modifier)
    experience_modifier = (policy_individual_total_modifier || 0) + 1

    if experience_modifier > 2.00
      experience_modifier = (experience_modifier * 1.05).round(2)
    end

    if experience_modifier < 0.91
      experience_modifier = (experience_modifier * 0.95).round(2)
    end

    experience_modifier - 1
  end

  def calculate_experience
    # self.transaction do
    @group_rating = GroupRating.find_by(process_representative: self.representative_number)

    self.manual_class_calculations.find_each do |manual_class|
      manual_class.calculate_payroll
    end

    @policy_total_four_year_payroll = self.manual_class_calculations.sum(:manual_class_four_year_period_payroll).round(0)

    # TODO: Really need to verify this once quarterly data comes in 7/24/2020
    @policy_total_expected_losses = self.manual_class_calculations.map(&:expected_losses_without_estimates).compact.sum.round(0) # NEED NO ESTIMATED PAYROLL IN THIS CALCULATION

    @policy_total_current_payroll = self.manual_class_calculations.sum(:manual_class_current_estimated_payroll).round(0)

    if @policy_total_expected_losses <= 2000
      @credibility_row                     = BwcCodesCredibilityMaxLoss.where("expected_losses >= :expected_losses", expected_losses: @policy_total_expected_losses).min
      @credibility_row.credibility_group   = 0
      @credibility_row.expected_losses     = 0
      @credibility_row.credibility_percent = 0
      @credibility_row.group_maximum_value = 250000

    elsif @policy_total_expected_losses >= 1000000
      @credibility_row = BwcCodesCredibilityMaxLoss.find_by(expected_losses: 1000000)
    else
      @credibility_row = BwcCodesCredibilityMaxLoss.where("expected_losses >= :expected_losses", expected_losses: @policy_total_expected_losses).min
      @credibility_row = BwcCodesCredibilityMaxLoss.find_by(credibility_group: (@credibility_row.credibility_group - 1))
    end

    self.manual_class_calculations.find_each do |manual_class|
      manual_class.calculate_limited_losses(@credibility_row.credibility_group)
    end

    @policy_total_limited_losses = self.manual_class_calculations.map { |manual| manual.limited_losses_without_estimates(@credibility_row.credibility_group) }.compact.sum.round(0) # TODO: NEED NO ESTIMATED PAYROLL IN THIS CALCULATION

    self.claim_calculations.each do |claim|
      claim.recalculate_experience(@credibility_row.group_maximum_value)
    end

    @claims = self.claim_calculations.where("claim_injury_date >= :experience_period_lower_date and claim_injury_date <= :experience_period_upper_date", experience_period_lower_date: @group_rating.experience_period_lower_date, experience_period_upper_date: @group_rating.experience_period_upper_date)

    if @claims.empty?
      @policy_total_modified_losses_group_reduced      = 0
      @policy_total_modified_losses_individual_reduced = 0
      @policy_group_ratio                              = 0
      @policy_total_claims_count                       = 0
    else
      @policy_total_modified_losses_group_reduced      = @claims.sum(:claim_modified_losses_group_reduced).round(2)
      @policy_total_modified_losses_individual_reduced = @claims.sum(:claim_modified_losses_individual_reduced).round(2)
      @policy_total_claims_count                       = @claims.count
      @policy_group_ratio                              =
        if @policy_total_expected_losses == 0.0
          0
        else
          (@policy_total_modified_losses_group_reduced / @policy_total_expected_losses).round(4)
        end
    end

    @policy_individual_total_modifier =
      if @policy_total_limited_losses == 0
        0
      else
        (((@policy_total_modified_losses_individual_reduced - @policy_total_limited_losses) / @policy_total_limited_losses) * @credibility_row.credibility_percent).round(2)
      end

    @policy_individual_experience_modified_rate = (@policy_individual_total_modifier + 1).round(2)

    # @policy_individual_adjusted_experience_modified_rate = adjust_ind_emr(@policy_individual_experience_modified_rate)
    @policy_individual_adjusted_experience_modified_rate = adjusted_total_modifier(@policy_individual_total_modifier).round(2)

    self.update_attributes(
      policy_total_modified_losses_group_reduced:          @policy_total_modified_losses_group_reduced,
      policy_total_modified_losses_individual_reduced:     @policy_total_modified_losses_individual_reduced,
      policy_total_claims_count:                           @policy_total_claims_count,
      policy_individual_total_modifier:                    @policy_individual_total_modifier,
      policy_individual_experience_modified_rate:          @policy_individual_experience_modified_rate,
      policy_individual_adjusted_experience_modified_rate: @policy_individual_adjusted_experience_modified_rate,
      policy_group_ratio:                                  @policy_group_ratio,
      policy_total_expected_losses:                        @policy_total_expected_losses,
      policy_total_four_year_payroll:                      @policy_total_four_year_payroll,
      policy_total_current_payroll:                        @policy_total_current_payroll,
      policy_credibility_percent:                          @credibility_row.credibility_percent,
      policy_credibility_group:                            @credibility_row.credibility_group,
      policy_total_limited_losses:                         @policy_total_limited_losses,
      policy_maximum_claim_value:                          @credibility_row.group_maximum_value
    )

    # end # transaction end
  end

  def calculate_premium
    # self.transaction do
    @group_rating = GroupRating.find_by(process_representative: self.representative_number)
    #  need policy_individual_experience_modified_rate, administrative_rate for manual_class
    @administrative_rate = (1 + BwcCodesConstantValue.find_by(name: 'administrative_rate', completed_date: nil).rate)

    # TODO: Potentially ADD DWRF Rate Here

    self.manual_class_calculations.find_each do |manual_class_calculation|
      manual_class_calculation.calculate_premium(self.policy_individual_adjusted_experience_modified_rate + 1, @administrative_rate)
    end

    @policy_total_standard_premium      = self.manual_class_calculations.sum(:manual_class_standard_premium).round(0)
    @policy_adjusted_standard_premium   = adjust_premium_size_factors(@policy_total_standard_premium)&.round(0)
    @policy_total_individual_premium    = self.manual_class_calculations.sum(:manual_class_estimated_individual_premium).round(2)
    @policy_adjusted_individual_premium = calculate_premium_with_assessments(@policy_total_individual_premium, @policy_total_standard_premium)
    @collection                         = self.manual_class_calculations.pluck(:manual_class_industry_group).uniq
    @highest_industry_group             = { industry_group: @collection.first, standard_premium: self.manual_class_calculations.where(manual_class_industry_group: @collection.first).sum(:manual_class_standard_premium) }

    @collection.each do |c|
      if self.manual_class_calculations.where(manual_class_industry_group: c).sum(:manual_class_standard_premium) > @highest_industry_group[:standard_premium]
        @highest_industry_group = { industry_group: c, standard_premium: self.manual_class_calculations.where(manual_class_industry_group: c).sum(:manual_class_standard_premium) }
      end
    end
    # Added this logic to default to industry_group 7 when a policy is calculated to industry_group 9 and then changed to 8 if there is more premium in 8 than 7

    if @highest_industry_group == 9
      if @collection.include? 7
        @highest_industry_group = { industry_group: 7, standard_premium: self.manual_class_calculations.where(manual_class_industry_group: 7).sum(:manual_class_standard_premium) }
      end
      if @collection.include? 8
        if self.manual_class_calculations.where(manual_class_industry_group: 8).sum(:manual_class_standard_premium) > self.manual_class_calculations.where(manual_class_industry_group: 7).sum(:manual_class_standard_premium)
          @highest_industry_group = { industry_group: 8, standard_premium: self.manual_class_calculations.where(manual_class_industry_group: 8).sum(:manual_class_standard_premium) }
        end
      end
    end

    # ADDED NEW LOGIC FOR CURRENT PAYROLL FIX FOR NEW POLICIES

    unless self.policy_creation_date.nil?
      if self.policy_creation_date >= @group_rating.current_payroll_period_lower_date
        new_policy_individual_premium = 0
        self.manual_class_calculations.each do |manual|
          manual_class_current_payroll = manual.payroll_calculations.where("reporting_period_start_date >= :current_payroll_period_lower_date and reporting_period_start_date < :current_payroll_period_upper_date", current_payroll_period_lower_date: (@group_rating.current_payroll_period_lower_date + 1.years), current_payroll_period_upper_date: (@group_rating.current_payroll_period_upper_date + 1.years)).sum(:manual_class_payroll).round(2)

          manual_class_standard_premium             = ((manual.manual_class_base_rate * manual_class_current_payroll * self.policy_individual_experience_modified_rate) / 100).round(2)
          manual_class_modification_rate            = (manual.manual_class_base_rate * self.policy_individual_experience_modified_rate).round(2)
          manual_class_individual_total_rate        = ((manual_class_modification_rate * @administrative_rate)).round(4) / 100
          manual_class_estimated_individual_premium = (manual_class_current_payroll * manual_class_individual_total_rate).round(2)

          new_policy_individual_premium += manual_class_estimated_individual_premium
        end

        if new_policy_individual_premium > @policy_total_individual_premium
          self.manual_class_calculations.find_each do |manual_class|
            manual_class.calculate_payroll(true)
            manual_class.calculate_premium(self.policy_individual_adjusted_experience_modified_rate + 1, @administrative_rate)
          end
          # Added logic to update current payroll on 7/24/07
          @policy_total_current_payroll       = self.manual_class_calculations.sum(:manual_class_current_estimated_payroll).round(0)
          @policy_total_standard_premium      = self.manual_class_calculations.sum(:manual_class_standard_premium).round(0)
          @policy_adjusted_standard_premium   = adjust_premium_size_factors(@policy_total_standard_premium)&.round(0)
          @policy_total_individual_premium    = self.manual_class_calculations.sum(:manual_class_estimated_individual_premium).round(2)
          @policy_adjusted_individual_premium = calculate_premium_with_assessments(@policy_total_individual_premium, @policy_total_standard_premium)
          self.update_attributes(policy_total_current_payroll: @policy_total_current_payroll, policy_total_standard_premium: @policy_total_standard_premium)
        end
      end
    end

    if @policy_total_individual_premium < 120
      @policy_total_individual_premium = 120.00
    end

    self.update_attributes(policy_industry_group:              @highest_industry_group[:industry_group],
                           policy_total_individual_premium:    @policy_total_individual_premium,
                           policy_total_standard_premium:      @policy_total_standard_premium,
                           policy_adjusted_standard_premium:   @policy_adjusted_standard_premium,
                           policy_adjusted_individual_premium: @policy_adjusted_individual_premium)

    self.manual_class_calculations.each do |manual|
      unless self.policy_total_individual_premium.nil?
        if manual.manual_class_estimated_individual_premium.nil? # recalculate premium just in case
          manual.calculate_premium(self.policy_individual_adjusted_experience_modified_rate + 1, @administrative_rate)
        end

        manual.update_attributes(manual_class_industry_group_premium_percentage: (manual.manual_class_estimated_individual_premium / @policy_total_individual_premium).round(4))
      end
    end

    # end #transaction
  end

  def calculate_premium_with_assessments(policy_total_individual_premium = self.policy_total_individual_premium, policy_total_standard_premium = self.policy_total_standard_premium)
    assessments = total_assessments(policy_total_individual_premium, policy_total_standard_premium)
    adjust_premium_size_factors(policy_total_standard_premium)&.round(0) + assessments
  end

  def total_assessments(policy_total_individual_premium = self.policy_total_individual_premium, policy_total_standard_premium = self.policy_total_standard_premium)
    policy_total_individual_premium - policy_total_standard_premium
  end

  def calculate_premium_for_risk(new_mod_rate)
    administrative_rate = BwcCodesConstantValue.find_by(name: 'administrative_rate', completed_date: nil).rate

    total_individual_premium = self.manual_class_calculations.map do |manual|
      manual.calculate_potential_premium(new_mod_rate, administrative_rate)
    end.sum


    total_standard_premium = self.manual_class_calculations.map do |manual|
      manual.calculate_potential_standard_premium(new_mod_rate)
    end.sum
    # total_standard_premium = adjust_premium_size_factors(total_standard_premium)&.round(0)

    calculate_premium_with_assessments(total_individual_premium, total_standard_premium)
  end

  def adjust_ind_emr emr
    # 2019 Quoting Changes
    # Muliplier against ind_emr
    case emr
    when (0..0.90)
      emr * 0.95
    when (0.91...2.0)
      emr
    else
      emr * 1.05
    end
  end

  def adjust_premium_size_factors(total_standard_premium)
    return 0 if total_standard_premium < 0

    if total_standard_premium > 500000
      405750 + ((total_standard_premium - 500000) * 0.75).round(0)
    elsif total_standard_premium > 100000
      85750 + ((total_standard_premium - 100000) * 0.8).round(0)
    elsif total_standard_premium > 5000
      # 5000 + ((Y10 - 5000) * 0.85).round(0) Y10?
      5000 + ((total_standard_premium - 5000) * 0.85).round(0)
    else
      total_standard_premium
    end


    # case total_standard_premium
    # when (0..5000)
    #   total_standard_premium
    # when (5001..100000)
    #   5000 + (((total_standard_premium || 0) - 5000) * 0.85)
    # when (100000..500000)
    #   85750 + (((total_standard_premium || 0) - 100000) * 0.80)
    # else
    #   405750 + (((total_standard_premium || 0) - 500000) * 0.75)
    # end
  end

  def delete_claims
    self.claim_calculations.destroy_all
  end
end
